####################################################################
#   Copyright (C) 2020-2021 Luis Falcon <falcon@gnuhealth.org>
#   Copyright (C) 2020-2021 GNU Solidario <health@gnusolidario.org>
#   License: GPL v3+
#   Please read the COPYRIGHT and LICENSE files of the package
####################################################################

import datetime
from uuid import uuid4
from PySide2.QtCore import QObject, Signal, Slot, Property
from tinydb import TinyDB, Query
import json
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

    @Slot()
    def sync_book(self):
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
            print (res)

    # Property block
    book = Property("QVariantList", read_book, constant=True)
