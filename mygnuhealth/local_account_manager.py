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
from mygnuhealth.core import get_personal_key

import logging


class LocalAccountManager(QObject):
    """This class manages the login and initialization of the personal key

        Attributes:
        -----------
            loginSuccess: Signal to emit when entering the correct personal key
            errorOccurred: Signal to emit when enteting the wrong key

            initKey: Property that exposes the initialization status of
                    personal key.

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

    @Slot(str)
    def login(self, key):
        key = key.encode()

        personal_key = get_personal_key(self.db)

        if bcrypt.checkpw(key, personal_key):
            logging.info("Login correct - Move to main PHR page")
            self.loginSuccess.emit()
        else:
            self.errorOccurred.emit()

    @Slot(str)
    def createAccount(self, key):
        key = key.encode()
        if (self.init_personal_key(key.decode('utf-8'))):
            self.loginSuccess.emit()
        else:
            self.errorOccurred.emit()

    # Properties
    accountExist = Property(bool, account_exist, constant=True)

    # Signals
    loginSuccess = Signal()
    errorOccurred = Signal()

