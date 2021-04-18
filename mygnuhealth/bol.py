####################################################################
#   Copyright (C) 2020-2021 Luis Falcon <falcon@gnuhealth.org>
#   Copyright (C) 2020-2021 GNU Solidario <health@gnusolidario.org>
#   License: GPL v3+
#   Please read the COPYRIGHT and LICENSE files of the package
####################################################################

import datetime
import json
import requests

from uuid import uuid4
from PySide2.QtCore import QObject, Signal, Slot, Property
from tinydb import TinyDB, Query
from mygnuhealth.myghconf import bolfile, dbfile
from mygnuhealth.core import PageOfLife, datefromisotz


class GHBol(QObject):
    """Class that manages the person Book of Life

        Attributes:
        -----------
            boldb: TinyDB instance.
                Holds the book of life with all the events (pages of life)
        Methods:
        --------
            read_book: retrieves all pages
            format_bol: compacts and shows the relevant fields in a
            human readable format
    """

    boldb = TinyDB(bolfile)
    db = TinyDB(dbfile)

    def format_bol(self, bookoflife):
        """Takes the necessary fields and formats the book in a way that can
        be shown in the device, mixing fields and compacting entries in a more
        human readable format"""
        book = []
        for pageoflife in bookoflife:
            pol = {}
            dateobj = datefromisotz(pageoflife['page_date'])
            # Use a localized and easy to read date format
            date_repr = dateobj.strftime("%a, %b %d '%y - %H:%M")

            pol['date'] = date_repr
            pol['domain'] = f"{pageoflife['domain']}\
                \n{pageoflife['context']}"

            summ = ''
            msr = ''

            title = pageoflife['summary']
            details = pageoflife['info']

            if title:
                summ = f'{title}\n'

            if ('measurements' in pageoflife.keys() and
                    pageoflife['measurements']):
                for measure in pageoflife['measurements']:
                    if 'bg' in measure.keys():
                        msr = msr + f"Blood glucose: {measure['bg']} mg/dl\n"
                    if 'hr' in measure.keys():
                        msr = msr + f"Heart rate: {measure['hr']} bpm\n"
                    if 'bp' in measure.keys():
                        msr = msr + \
                            f"BP: {measure['bp']['systolic']} / " \
                            f"{measure['bp']['diastolic']} mmHg\n"
                    if 'wt' in measure.keys():
                        msr = msr + f"Weight: {measure['wt']} kg\n"

                    if 'bmi' in measure.keys():
                        msr = msr + f"BMI: {measure['bmi']} kg/m2\n"

                    if 'osat' in measure.keys():
                        msr = msr + f"osat: {measure['osat']} %\n"

                    if 'mood_energy' in measure.keys():
                        msr = msr + \
                            f"mood: {measure['mood_energy']['mood']} " \
                            f"energy: {measure['mood_energy']['energy']}\n"
                    summ = summ + msr

                # Include the Lifestyle measures
                if (pageoflife['domain'] == 'lifestyle'):
                    # Show / format the Physical activity values ("pa" key)
                    if 'pa' in pageoflife['measurements'][0].keys():
                        for key, value in \
                                pageoflife['measurements'][0]['pa'].items():
                            summ = summ + f"{key}: {value}\n"

                    # Show / format the nutrition values ("nutrition" key)
                    if 'nutrition' in pageoflife['measurements'][0].keys():
                        for key, value in \
                                pageoflife['measurements'][0]['nutrition'].items():
                            summ = summ + f"{key}: {value}\n"

                    # Show / format the sleep values ("sleep" key)
                    if 'sleep' in pageoflife['measurements'][0].keys():
                        for key, value in \
                                pageoflife['measurements'][0]['sleep'].items():
                            summ = summ + f"{key}: {value}\n"


            if ('genetic_info' in pageoflife.keys() and
                    pageoflife['genetic_info']):
                genetics = pageoflife['genetic_info']
                summ = summ + f'{genetics}\n'

            if details:
                summ = summ + f'{details}\n'

            pol['summary'] = summ

            book.append(pol)
        return book

    def read_book(self):
        """retrieves all pages of the individual Book of Life
        """
        booktable = self.boldb.table('pol')
        book = booktable.all()
        formatted_bol = self.format_bol(book)
        return formatted_bol

    def check_sync_status(self):
        fedinfo = self.db.table('federation')
        if len(fedinfo):
            sync = fedinfo.all()[0]['enable_sync']
            return sync

    @Slot(str)
    def sync_book(self, fedkey):
        """This method will go through each page in the book of life
        that has not been sent to the GNU Health Federation server yet
        (fsynced = False).
        It also checks for records that have a book associated to it
        and that the specific page is has not the "private" flag set.

        Parameters
        ----------
        """
        fedinfo = self.db.table('federation')
        if len(fedinfo):
            res = fedinfo.all()[0]

        # Refresh all pages of life
        booktable = self.boldb.table('pol')
        book = booktable.all()
        user = res['federation_account']
        protocol = res['protocol']
        server = res['federation_server']
        port = res['federation_port']

        for pol in book:
            timestamp = pol['page_date']
            node = pol['node']
            id = pol['page']
            synced = pol['fsynced']

            # Only sync those pages that are not private
            if 'privacy' in pol.keys():
                privacy = pol['privacy']
                if not privacy and not synced:
                    creation_info = {'user': user, 'timestamp': timestamp,
                                     'node': node}

                    pol['creation_info'] = creation_info
                    pol['id'] = id

                    url = f"{protocol}://{server}:{port}/pols/{user}/{id}"

                    pol['fsynced'] = True
                    send_data = requests.request('POST', url,
                                                 data=json.dumps(pol),
                                                 auth=(user, fedkey),
                                                 verify=False)
                    if send_data:
                        print("Page successfully sent to the GH Federation",
                              send_data.status_code)
                        # Update page of life sync status locally to true
                        print("Setting fsynced to True on page... ", id)
                        Page = Query()
                        booktable.update({'fsynced': True}, Page.page == id)
                    
                    else:
                        print("Error sending the page.",
                              send_data.status_code)
                        
                else:
                    if privacy:
                        print("This page is private, not syncing", pol)
                    if synced:
                        print("Page already synced", pol)

    # Property block
    book = Property("QVariantList", read_book, constant=True)

    # Expose to QML the value of sync status
    # It will disable the password field if sync is not enabled.
    sync_status = Property(bool, check_sync_status, constant=True)

