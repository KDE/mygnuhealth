#!/usr/bin/env python3

##############################################################################
#
#    GNU Health: The Free Health and Hospital Information System
#    Copyright (C) 2008-2021 Luis Falcon <falcon@gnu.org>
#    Copyright (C) 2011-2021 GNU Solidario <health@gnusolidario.org>
#
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

import os
import sys
import bcrypt
import getpass
import tinydb
from pathlib import Path
from tinydb import TinyDB, Query
import configparser
from mygnuhealth import about

homedir = str(Path.home())
gh_dir = os.path.join(homedir, 'mygh')
config_file = os.path.join(gh_dir, 'ghealth.conf')
dbfile = os.path.join(gh_dir, 'ghealth.db')

# The boldb holds the Book of Life
# containing all pages of life and their sync status on the federation
bolfile = os.path.join(gh_dir, 'bol.db')
GH_KEY = "mygh"


def check_inst_dir():
    if os.path.isdir(gh_dir):
        print("Directory exists... skipping")
    else:
        print("Initializing MyGNUHealth directory")
        try:
            os.mkdir(gh_dir)
        except Exception as e:
            print(f"Error initializing MyGNUHealth directory: {e}")


def check_config():
    if os.path.isfile(config_file):
        print("Found myGNUHealth configuration file.. skipping")
    else:
        print("Configuration file not found. Writing defaults")
        set_default_config_file()


def check_db():
    print("Verifying MyGNUHealth Database.....")
    if os.path.isfile(dbfile):
        print("MyGNUHealth DB exists.. skipping")
    else:
        print("DB file not found. Initializing MyGNUHealth...")
        db = TinyDB(dbfile)
        init_db(db)


def set_default_config_file():
    config = configparser.ConfigParser()
    config.read(config_file)
    if not ('security' in config.sections()):
        config.add_section('security')

    config.set('security', 'key_method', 'bcrypt')
    output_file = open(config_file, 'w')
    config.write(output_file)


def init_db(db):
    encrypted_key = bcrypt.hashpw(GH_KEY.encode('utf-8'),
                                  bcrypt.gensalt()).decode('utf-8')

    credentials = db.table('credentials')
    credentials.insert({'personal_key': encrypted_key})

    print("MyGNUHealth DB initialized !")


def verify_installation_status():
    print("Initializing MyGNUHealth version", about.__version__)
    check_inst_dir()
    check_config()
    check_db()
    return True
