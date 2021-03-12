####################################################################
#   Copyright (C) 2020-2021 Luis Falcon <falcon@gnuhealth.org>
#   Copyright (C) 2020-2021 GNU Solidario <health@gnusolidario.org>
#   License: GPL v3+
#   Please read the COPYRIGHT and LICENSE files of the package
####################################################################

from PySide2.QtCore import QObject, Signal, Slot, Property
from tinydb import TinyDB, Query
from uuid import uuid4
from mygnuhealth.myghconf import dbfile
from mygnuhealth.core import check_date, PageOfLife

import json
import logging
import datetime


class PoL(QObject):
    """This class creates a new page in the user's Book of Life

        Attributes:
        -----------
            wrongDate: Signal to emit when an invalid date is found
            todayDate: Property with current date

        Methods:
        --------
            init_personal_key: Sets the personal key at the initial run.
            login: Slot that receives the personal key to login, and checks
                    if it is the correct one to log in.
            createAccount: Slot that receives the initial personal key to
                create an account.

    """
    def get_domains(self):
        """ Return the domains to be used in the QML form
            We use value and text keys to match QML Combobox"""
        return PageOfLife.pol_domain

    def __init__(self):
        QObject.__init__(self)
        self.db = TinyDB(dbfile)

    def get_date(self):
        """
        Returns the date packed into an array (day,month,year)
        """
        rightnow = datetime.datetime.now()
        dateobj = []
        dateobj.append(rightnow.day)
        dateobj.append(rightnow.month)
        dateobj.append(rightnow.year)
        dateobj.append(rightnow.hour)
        dateobj.append(rightnow.minute)
        return dateobj

    def new_page(self, data):
        page_id = str(uuid4())

        pol_vals = {
            'page': page_id,
            'page_date': current_date,
            'gene': gene,
            'aa_change': aa_change,
            'rsid': rsid,
            'variant': variant,
            'age': onset,
            'summary': summary,
            'info': info,
            }
        domain = 'medical'
        context = 'genetics'
        PageOfLife.create_pol(PageOfLife, pol_vals, domain,
                              context)

    @Slot(list)
    def createPage(self, page_date):
        # Retrieves the inforation from the initialization form
        # Creates the page from the information on the form
        if (page_date):
            if (check_date(page_date)):
                # Sets the page of life date and time
                year, month, day, hour, minute = page_date
                daterp = str(datetime.date(year, month, day, hour, minute))
                page = {'page_date': daterp}
                self.new_page(page)
            else:
                print("Wrong Date!")
                validation_process = False
                self.wrongDate.emit()

        self.createSuccess.emit()

    # Properties
    todayDate = Property("QVariantList", get_date, constant=True)
    poldomain = Property("QVariantList", get_domains, constant=True)

    # Signals
    createSuccess = Signal()
    wrongDate = Signal()
