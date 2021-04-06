####################################################################
#   Copyright (C) 2020-2021 Luis Falcon <falcon@gnuhealth.org>
#   Copyright (C) 2020-2021 GNU Solidario <health@gnusolidario.org>
#   GPL v3+
#   Please read the COPYRIGHT and LICENSE files of the package
####################################################################
import os
import sys
import bcrypt
import getpass
from pathlib import Path
import configparser
from mygnuhealth import about

homedir = str(Path.home())
gh_dir = os.path.join(homedir, 'mygh')
config_file = os.path.join(gh_dir, 'ghealth.conf')
dbfile = os.path.join(gh_dir, 'ghealth.db')

# The boldb holds the Book of Life
# containing all pages of life and their sync status on the federation
bolfile = os.path.join(gh_dir, 'bol.db')


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
        print("DB file not found.")


def set_default_config_file():
    config = configparser.ConfigParser()
    config.read(config_file)
    if not ('security' in config.sections()):
        config.add_section('security')

    config.set('security', 'key_method', 'bcrypt')
    output_file = open(config_file, 'w')
    config.write(output_file)


def verify_installation_status():
    print("Initializing MyGNUHealth version", about.__version__)
    check_inst_dir()
    check_config()
    check_db()
    return True
