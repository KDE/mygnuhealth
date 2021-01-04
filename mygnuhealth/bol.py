import datetime
from uuid import uuid4
from PySide2.QtCore import QObject, Signal, Slot, Property
from tinydb import TinyDB, Query
import json
from mygnuhealth.myghconf import bolfile
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

    def format_bol(self, bookoflife):
        """Takes the necessary fields and formats the book in a way that can
        be shown in the device, mixing fields and compacting entries in a more
        human readable formtat"""
        book = []
        for pageoflife in bookoflife:
            pol = {}
            dateobj = datefromisotz(pageoflife['page_date'])
            # Use a localized and easy to read date format
            date_repr = dateobj.strftime("%a, %b %d '%y - %H:%M")

            pol['date'] = date_repr
            pol['domain'] = f"{pageoflife['page_type']}\
                \n{pageoflife['medical_context']}"

            summ = ''
            for measure in pageoflife['measurements']:
                if 'bg' in measure.keys():
                    summ = summ + f"Blood glucose: {measure['bg']} mg/dl\n"
                if 'hr' in measure.keys():
                    summ = summ + f"Heart rate: {measure['hr']} bpm\n"
                if 'bp' in measure.keys():
                    summ = summ + \
                        f"BP: {measure['bp']['systolic']} / " \
                        f"{measure['bp']['diastolic']} mmHg\n"
                if 'wt' in measure.keys():
                    summ = summ + f"Weight: {measure['wt']} kg\n"

                if 'osat' in measure.keys():
                    summ = summ + f"osat: {measure['osat']} %\n"

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
    # Property block
    book = Property("QVariantList", read_book, constant=True)
