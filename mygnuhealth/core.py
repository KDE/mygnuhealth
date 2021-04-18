#!/usr/bin/env python3
##############################################################################
#
#    MyGNUHealth : Mobile and Desktop PHR node for GNU Health
#
#           MyGNUHealth is part of the GNU Health project
#
##############################################################################
#
#    GNU Health: The Libre Digital Health Ecosystem
#    Copyright (C) 2008-2021 Luis Falcon <falcon@gnuhealth.org>
#    Copyright (C) 2011-2021 GNU Solidario <health@gnusolidario.org>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################

import datetime
import dateutil.parser
import os
from tinydb import TinyDB, Query
from mygnuhealth.myghconf import dbfile, bolfile

''' Import the Natural variants database from the data
directory, relative to the this mygnuhealth module
The datafile is loaded into the TinyDB "vardb" variable
'''
moddir = os.path.dirname(os.path.abspath(__file__))
varfile = os.path.join(moddir, 'data/variants.db')
vardb = TinyDB(varfile, access_mode='r')


def datefromisotz(isotz):
    """This method is compatible with Python 3.6 .
    datetime fromisoformat is not present until Python 3.7
    """

    if isotz:
        return dateutil.parser.parse(isotz)


def get_user_profile(db):
    """Retrives the user profile (DoB, sex, height ...)"""

    profile_table = db.table('profile')
    profile = None
    # Credentials table holds a singleton, so only one record
    if (len(profile_table) > 0):
        profile = profile_table.all()[0]
    return profile


def get_personal_key(db):
    """Retrives the user personal key"""

    credentials_table = db.table('credentials')
    # Credentials table holds a singleton, so only one record
    personal_key = credentials_table.all()[0]['personal_key']
    return personal_key.encode()


def get_federation_account():
    """Retrieves the user GH Federation account, if any."""

    db = TinyDB(dbfile)
    federation_table = db.table('federation')
    fedacct = None
    if (len(federation_table) > 0):
        # Federation Account table holds a singleton, so only one record
        res = federation_table.all()[0]
        if 'federation_account' in res.keys():
            fedacct = res['federation_account']
            print("Fed account ", fedacct)
    return fedacct


def check_date(date):
    """ Verifies that the entered date is valid"""
    year, month, day = date
    try:
        datetime.date(year, month, day)
        return True
    except ValueError:
        print("Invalid date")
        return False


class PageOfLife():
    """
    Page of Life
    The basic shema of PoL from GH Federation HIS, used  by Thalamus

    Attributes
    ----------
        boldb: TinyDB instance
            The book of life DB. It contains all the Pages of Life created
            by the user.

        pol_model : dict
            Dictionary holding the schema of the GNU Healtth Federation
            Health Information System  database

        medical_context: In a page of life, when the medical domain is chosen,
            the user can choose

        social_context: The different contexts within the Social domain.

        Methods:
        --------
            create_pol: Creates a Page of Life associated the event / reading

    """
    boldb = TinyDB(bolfile)

    pol_model = dict.fromkeys([
        'book', 'page_date', 'age', 'domain', 'relevance', 'privacy',
        'context', 'measurements', 'genetic_info', 'summary', 'info',
        'node', 'author', 'author_acct', 'fsynced'
        ])

    pol_domain = [{'value': 'medical', 'text': 'Medical'},
                  {'value': 'social', 'text': 'Social'},
                  {'value': 'biographical', 'text': 'Biographical'},
                  {'value': 'lifestyle', 'text': 'Lifestyle'},
                  {'value': 'other', 'text': 'Other'}
                  ]

    medical_context = [
        {'value': 'health_condition', 'text': 'Health Condition'},
        {'value': 'encounter', 'text': 'Encounter'},
        {'value': 'procedure', 'text': 'Procedure'},
        {'value': 'self_monitoring', 'text': 'Self monitoring'},
        {'value': 'immunization', 'text': 'Immunization'},
        {'value': 'prescription', 'text': 'Prescription'},
        {'value': 'surgery', 'text': 'Surgery'},
        {'value': 'hospitalization', 'text': 'Hospitalization'},
        {'value': 'lab', 'text': 'Lab test'},
        {'value': 'dx_imaging', 'text': 'Dx Imaging'},
        {'value': 'genetics', 'text': 'Genetics'},
        {'value': 'family', 'text': 'Family history'},
        ]

    social_context = [
        {'value': 'social_gradient', 'text': 'Social Gradient / Equity'},
        {'value': 'stress', 'text': 'Stress'},
        {'value': 'early_life_development', 'text': 'Early life development'},
        {'value': 'social_exclusion', 'text': 'Social exclusion'},
        {'value': 'working_conditions', 'text': 'Working conditions'},
        {'value': 'education', 'text': 'Education'},
        {'value': 'physical_environment', 'text': 'Physical environment'},
        {'value': 'unemployment', 'text': 'Unemployment'},
        {'value': 'social_support', 'text': 'Social Support'},
        {'value': 'addiction', 'text': 'Addiction'},
        {'value': 'food', 'text': 'Food'},
        {'value': 'transportation', 'text': 'Transportation'},
        {'value': 'health_services', 'text': 'Health services'},
        {'value': 'family_functionality', 'text': 'Family functionality'},
        {'value': 'family_violence', 'text': 'Family violence'},
        {'value': 'bullying', 'text': 'Bullying'},
        {'value': 'war', 'text': 'War'},
        {'value': 'misc', 'text': 'Misc'},
        ]

    lifestyle_context = [
        {'value': 'physical_activity', 'text': 'Physical Activity'},
        {'value': 'nutrition', 'text': 'Nutrition'},
        {'value': 'sleep', 'text': 'Sleep'},
        ]

    biographical_context = [
        {'value': 'birth', 'text': 'Birth'},
        {'value': 'death', 'text': 'Death'},
        {'value': 'misc', 'text': 'Misc'}
        ]

    other_context = [
        {'value': 'misc', 'text': 'Misc'},
        ]

    def create_pol(self, pol_vals):
        """Creates a Page of Life associated to the reading

        Parameters
        ----------
        pol_vals: Takes all the values from the page of life, which is a 
        dictionary. Some of them:
            domain: the domain (medical, psycho, social)
            context: the context within a domain (possible contexts are listed
                in the core module.
            genetic_info: variant, rsref, protein, gene, aa_change
            measurements: blood pressure, Osat, temp, heart & resp frequency,..
            summary: Short description / title of the page
            info: Extended information related to this page of life.
        """

        node = "mygnuhealth"  # The node name is generic. "mygnuhealth"
        fed_acct = get_federation_account()
        poltable = self.boldb.table('pol')
        page_of_life = self.pol_model
        domain = pol_vals['domain']
        context = pol_vals['context']

        if (fed_acct):
            #  If the Federation account does not exist, it will be
            #  a private entry, not linked to a book or author
            #  and it won't be shared in the GNU Health Federation

            print("Retrieved Federation Account: ", fed_acct)
            page_of_life['book'] = fed_acct
            page_of_life['author'] = fed_acct
            page_of_life['author_acct'] = fed_acct

        page_of_life['node'] = node
        page_of_life['page'] = pol_vals['page']
        page_of_life['page_date'] = pol_vals['page_date']
        page_of_life['domain'] = domain

        page_of_life['context'] = context
    
        if ('relevance' in pol_vals.keys()):
            page_of_life['relevance'] = pol_vals['relevance']

        if ('privacy' in pol_vals.keys()):
            page_of_life['privacy'] = pol_vals['privacy']

        if ('genetic_info' in pol_vals.keys()):
            page_of_life['genetic_info'] = pol_vals['genetic_info'] or ''

        if ('measurements' in pol_vals.keys()):
            page_of_life['measurements'] = pol_vals['measurements']
        if ('summary' in pol_vals.keys()):
            page_of_life['summary'] = pol_vals['summary'] or ''
        if ('info' in pol_vals.keys()):
            page_of_life['info'] = pol_vals['info'] or ''

        # The fsync key reflects whether the page has been sent to the
        # GNU Health Federation HIS (Health Information System)
        page_of_life['fsynced'] = False
        # create the new PoL entry
        
        print("New Page of Life:", page_of_life)
        data = page_of_life
        poltable.insert(data)

        # Sample measurements keys accepted by Thalamus / GH Federation HIS
        #  {'bp': {'systolic': 116, 'diastolic': 79}, 't': 36.0, 'hr': 756, '
        #    rr': 16,
        #  'osat': 99, 'wt': 68.0, 'ht': 168.0, 'bmi': 24.09, 'bg': 116}

