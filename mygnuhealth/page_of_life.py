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
from mygnuhealth.core import check_date, PageOfLife, vardb

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
            get_domains: Returns main domains (medical, social, biographical..)

    """

    def __init__(self):
        QObject.__init__(self)
        self.db = TinyDB(dbfile)
        self.domain = 'medical'
        self.pol_context = ''
        self.rsinfo = {}

    def get_rsinfo(self):
        return self.rsinfo

    def get_domains(self):
        """ Return the domains to be used in the QML form
            We use value and text keys to match QML Combobox"""
        self.domain = PageOfLife.pol_domain
        return self.domain

    def get_contexts(self):
        """ Return the domains to be used in the QML form
            We use value and text keys to match QML Combobox"""
        if self.domain == 'social':
            self.pol_context = PageOfLife.social_context
        if self.domain == 'medical':
            self.pol_context = PageOfLife.medical_context
        if self.domain == 'lifestyle':
            self.pol_context = PageOfLife.lifestyle_context
        if self.domain == 'biographical':
            self.pol_context = PageOfLife.biographical_context
        if self.domain == 'other':
            self.pol_context = PageOfLife.other_context

        return self.pol_context

    @Signal
    def domainChanged(self):
        pass

    @Signal
    def rsChanged(self):
        pass

    @Slot(str)
    def update_context(self, domain):
        """ Set the value of the domain from the QML selection"""
        if domain == 'social':
            self.pol_context = PageOfLife.social_context
        if domain == 'medical':
            self.pol_context = PageOfLife.medical_context
        if domain == 'lifestyle':
            self.pol_context = PageOfLife.lifestyle_context
        if domain == 'biographical':
            self.pol_context = PageOfLife.biographical_context
        if domain == 'other':
            self.pol_context = PageOfLife.other_context
        # Emit the change of domain, so it updates the context
        self.domainChanged.emit()

        return self.pol_context

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
            'page_date': data['page_date'],
            'domain': data['domain'],
            'context': data['context'],
            'relevance': data['relevance'],
            'privacy': data['privacy'],
            'summary': data['summary'],
            'info': data['info']
            }
        if (data['context'] == 'genetics'):
            pol_vals.update({'genetic_info': data['genetic_info']})

        PageOfLife.create_pol(PageOfLife, pol_vals)

    @Slot(str)
    def checkSNP(self, rs):
        Rsnp = Query()
        self.rsinfo = {}
        res = vardb.search(Rsnp.dbsnp == rs)
        if len(res) > 0:
            res = res[0]
            self.rsinfo = {
                    'rsid': res['dbsnp'],
                    'gene': res['gene'],
                    'aa_change': res['aa_change'],
                    'variant': res['variant'],
                    'protein': res['protein'],
                    'significance': res['category'],
                    'disease': res['disease']
                    }

        else:
            self.rsinfo = {}

        return (self.rsinfo)

    @Slot(list, str, str, str, bool, list, str, str)
    def createPage(self, page_date, domain, context, relevance, private_page,
                   genetic_info, summary, info):
        # Retrieves the inforation from the initialization form
        # Creates the page from the information on the form
        if (page_date):
            if (check_date(page_date[:3])):
                # Sets the page of life date and time
                year, month, day, hour, minute = page_date
                daterp = str(datetime.datetime(year, month, day, hour, minute))
                page = {'page_date': daterp,
                        'domain': domain,
                        'context': context,
                        'relevance': relevance,
                        'privacy': private_page,
                        'summary': summary,
                        'info': info
                        }
                if (context == 'genetics'):
                    rsinfo = {
                        'rsid': genetic_info[0],
                        'gene': genetic_info[1],
                        'aa_change': genetic_info[2],
                        'variant': genetic_info[3],
                        'protein': genetic_info[4],
                        'significance': genetic_info[5],
                        'disease': genetic_info[6]
                        }
                    page.update({'genetic_info': rsinfo})
                self.new_page(page)
            else:
                validation_process = False
                self.wrongDate.emit()

        self.createSuccess.emit()

    # Properties
    todayDate = Property("QVariantList", get_date, constant=True)
    poldomain = Property("QVariantList", get_domains, constant=True)
    polcontext = Property("QVariantList", get_contexts, notify=domainChanged)
    polrs = Property("QVariant", get_rsinfo, notify=rsChanged)

    # Signals
    createSuccess = Signal()
    wrongDate = Signal()
