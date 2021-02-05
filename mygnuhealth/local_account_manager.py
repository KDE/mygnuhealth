####################################################################
#   Copyright (C) 2020-2021 Luis Falcon <falcon@gnuhealth.org>
#   Copyright (C) 2020-2021 GNU Solidario <health@gnusolidario.org>
#   Copyright (C) 2020-2021 Carl Schwan <carlschwan@kde.org>
#   License: GPL v3+
#   Please read the COPYRIGHT and LICENSE files of the package
####################################################################

from PySide2.QtCore import QObject, Signal, Slot, Property
import bcrypt
from tinydb import TinyDB, Query
from mygnuhealth.myghconf import dbfile
from mygnuhealth.core import get_personal_key, check_date, get_user_profile

import logging
import datetime


class LocalAccountManager(QObject):
    """This class manages the login and initialization of the personal key

        Attributes:
        -----------
            loginSuccess: Signal to emit when entering the correct personal key
            invalidCredentials: Signal to emit when entering the wrong key
            wrongDate: Signal to emit when an invalid date is found

            accountExist: Property that checks if the user account
                has been created
            todayDate: Property with current date

        Methods:
        --------
            init_personal_key: Sets the personal key at the initial run.
            login: Slot that receives the personal key to login, and checks
                    if it is the correct one to log in.
            createAccount: Slot that receives the initial personal key to
                create an account.

    """

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
        return dateobj

    def account_exist(self):
        """
        Check if an account exist in the database.
        """
        if (self.db.table('credentials')):
            print("DB is initialized")
            rc = True

        else:
            print("We need to init the personal Key")
            rc = False

        return rc

    def update_profile(self, profile):
        # Include height and other user settings at initialization
        profiletable = self.db.table('profile')
        if (len(profiletable) > 0):
            print(f"Updating profile ... {profile}")
            profiletable.update(profile)

        else:
            print(f"Initializing profile. Setting profile {profile}")
            profiletable.insert(profile)

    def init_personal_key(self, key):
        encrypted_key = bcrypt.hashpw(key.encode('utf-8'),
                                      bcrypt.gensalt()).decode('utf-8')

        credentialstable = self.db.table('credentials')
        if (len(credentialstable) > 0):
            credentialstable.update({'personal_key': encrypted_key})
        else:
            logging.info("Initializing credentials table")
            credentialstable.insert({'personal_key': encrypted_key})

        logging.info("Initialized personal key: {}".format(encrypted_key))
        return encrypted_key

    def get_username(self):
        if get_user_profile(self.db):
            return get_user_profile(self.db)['username']

    @Slot(str)
    def login(self, key):
        key = key.encode()

        personal_key = get_personal_key(self.db)

        if bcrypt.checkpw(key, personal_key):
            logging.info("Login correct - Move to main PHR page")
            self.loginSuccess.emit()
        else:
            self.invalidCredentials.emit()

    @Slot(str, str, str, list)
    def createAccount(self, key, height, personname, birthdate):
        # Retrieves the inforation from the initialization form
        # Initializes user profile and sets the initial password
        validation_process = True
        if (height):
            # Sets the user height
            height = int(height)
            profile = {'height': height}
            self.update_profile(profile)

        if (personname):
            # Sets the user name
            profile = {'username': personname}
            self.update_profile(profile)

        if (birthdate):
            if (check_date(birthdate)):
                # Sets the birthdate
                year, month, day = birthdate
                daterp = str(datetime.date(year, month, day))
                profile = {'birthdate': daterp}
                self.update_profile(profile)
            else:
                print("Wrong Date!")
                validation_process = False
                self.wrongDate.emit()

        key = key.encode()
        if (validation_process and
                self.init_personal_key(key.decode('utf-8'))):
            self.loginSuccess.emit()

    # Properties
    accountExist = Property(bool, account_exist, constant=True)

    todayDate = Property("QVariantList", get_date, constant=True)

    person = Property(str, get_username, constant=True)

    # Signals
    loginSuccess = Signal()
    invalidCredentials = Signal()
    wrongDate = Signal()
