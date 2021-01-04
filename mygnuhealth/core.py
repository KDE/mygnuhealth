#!/usr/bin/env python3
##############################################################################
#
#    MyGNUHealth : Mobile and Desktop PHR node for GNU Health
#
#           MyGNUHealth is part of the GNU Health project
#
##############################################################################
#
#    GNU Health: The Free Health and Hospital Information System
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

import dateutil.parser
from tinydb import TinyDB, Query
from mygnuhealth.myghconf import dbfile, bolfile


def datefromisotz(isotz):
    """This method is compatible with Python 3.6 .
    datetime fromisoformat is not present until Python 3.7
    """

    if isotz:
        return dateutil.parser.parse(isotz)


def get_personal_key(db):
    """Retrives the user personal key"""

    credentials = db.table('credentials')
    # Credentials table holds a singleton, so only one record
    personal_key = credentials.all()[0]['personal_key']
    return personal_key.encode()


def get_federation_account():
    """Retrieves the user GH Federation account, if any."""

    db = TinyDB(dbfile)
    fedtable = db.table('federation')

    # Federation Account table holds a singleton, so only one record
    fedacct = fedtable.all()[0]['federation_account']
    return fedacct


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
        'book', 'page_date', 'age', 'page_type', 'relevance',
        'medical_context', 'health_condition_code', 'health_condition_text',
        'procedure_code', 'procedure_text', 'gene', 'natural_variant',
        'phenotype', 'social_context', 'summary', 'info', 'measurements',
        'node', 'author', 'author_acct'
        ])

    medical_context = {
        'health_condition': 'Health Condition',
        'encounter': 'Encounter',
        'procedure': 'Procedure',
        'self_monitoring': 'Self monitoring',
        'immunization': 'Immunization',
        'prescription': 'Prescription',
        'surgery': 'Surgery',
        'hospitalization': 'Hospitalization',
        'lab': 'lab',
        'dx_imaging': 'Dx Imaging',
        'genetics': 'Genetics',
        'family': 'Family history',
        'birth': 'Birth',
        'death': 'Death',
        }

    social_context = {
        'social_gradient': 'Social Gradient / Equity',
        'stress': 'Stress',
        'early_life_development': 'Early life development',
        'social_exclusion': 'Social exclusion',
        'working_conditions': 'Working conditions',
        'education': 'Education',
        'physical_environment': 'Physical environment',
        'unemployment': 'unemployment',
        'social_support': 'Social Support',
        'addiction': 'Addiction',
        'food': 'Food',
        'transport': 'transport',
        'health_services': 'Health services',
        'uninsured': 'uninsured',
        'family_functionality': 'Family functionality',
        'family_violence': 'Family violence',
        'bullying': 'Bullying',
        'war': 'War',
        }

    def create_pol(self, pol_vals, domain, context):
        """Creates a Page of Life associated to the reading

        Parameters
        ----------
        monitor_vals: values taken from the user or device.
            The method is called after updating the specific measurement table
            (glucose, heart rate, osat.. )
        domain: the domain (medical, psycho, social)
        context: the context within a domain (possible contexts are listed
            in the core module.
        """

        fed_acct = get_federation_account()
        poltable = self.boldb.table('pol')
        page_of_life = self.pol_model
        med_cxt = self.medical_context

        if (fed_acct):
            print("Retrieved Federation Account: ", fed_acct)
            page_of_life['book'] = fed_acct
            page_of_life['author'] = fed_acct

        page_of_life['page'] = pol_vals['page']
        page_of_life['page_date'] = pol_vals['page_date']
        page_of_life['page_type'] = domain

        if (context in med_cxt.keys()):
            # Verifies against the dictionary on core module
            # that the key exists before assigning it.
            page_of_life['medical_context'] = context

        page_of_life['measurements'] = pol_vals['measurements']

        # create the new PoL entry
        print("New Page of Life:", page_of_life)
        data = page_of_life
        poltable.insert(data)

# Sample measurements keys accepted by Thalamus / GH Federation HIS
#  {'bp': {'systolic': 116, 'diastolic': 79}, 't': 36.0, 'hr': 756, 'rr': 16,
#  'osat': 99, 'wt': 68.0, 'ht': 168.0, 'bmi': 24.09, 'bg': 116}
