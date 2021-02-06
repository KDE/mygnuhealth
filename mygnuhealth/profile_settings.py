####################################################################
#   Copyright (C) 2020-2021 Luis Falcon <falcon@gnuhealth.org>
#   Copyright (C) 2020-2021 GNU Solidario <health@gnusolidario.org>
#   GPL v3+
#   Please read the COPYRIGHT and LICENSE files of the package
####################################################################

import datetime
from PySide2.QtCore import QObject, Signal, Slot, Property
from tinydb import TinyDB, Query
import bcrypt
from mygnuhealth.myghconf import dbfile
from mygnuhealth.core import get_personal_key, get_user_profile, \
    get_federation_account


class ProfileSettings(QObject):
    def __init__(self):
        QObject.__init__(self)

    db = TinyDB(dbfile)

    def check_current_password(self, current_password):
        personal_key = get_personal_key(self.db)
        cpw = current_password.encode()
        rc = bcrypt.checkpw(cpw, personal_key)
        if not rc:
            print("Wrong current password")
            self.errorPassword.emit()
        return rc

    def check_new_password(self, password, password_repeat):
        rc = password == password_repeat
        if not rc:
            print("New passwords do not match")
            self.errorPassword.emit()
        return rc

    def update_personalkey(self, password):
        encrypted_key = bcrypt.hashpw(password.encode('utf-8'),
                                      bcrypt.gensalt()).decode('utf-8')

        credentialstable = self.db.table('credentials')
        if (len(credentialstable) > 0):
            credentialstable.update({'personal_key': encrypted_key})
        else:
            print("Initializing credentials table")
            credentialstable.insert({'personal_key': encrypted_key})

        print("Saved personal key", encrypted_key)

    def update_profile(self, profile):
        profiletable = self.db.table('profile')
        if (len(profiletable) > 0):
            print(f"Updating height to {profile['height']}")
            profiletable.update({'height': profile['height']})

        else:
            print(f"Initializing profile. Setting height {profile['height']}")
            profiletable.insert({'height': profile['height']})

        return True

    @Slot(str)
    def get_profile(self, height):
        height = int(height)
        profile = {'height': height}
        if (height):
            self.update_profile(profile)
            self.setOK.emit()

    def update_fedacct(self, fedacct):
        fedtable = self.db.table('federation')
        if (len(fedtable) > 0):
            fedtable.update({'federation_account': fedacct})
        else:
            print("Initializing federation settings")
            fedtable.insert({'federation_account': fedacct})

        print("Saved personal key", fedacct)
        return True

    @Slot(str)
    def get_fedacct(self, userfedacct):
        if (userfedacct):
            self.update_fedacct(userfedacct)
            self.setOK.emit()

    @Slot(str, str, str)
    def get_personalkey(self, current_password, password, password_repeat):
        if (self.check_current_password(current_password) and
                self.check_new_password(password, password_repeat)):
            self.update_personalkey(password)
            self.setOK.emit()

    # Signal to emit to QML if the password, profile values or
    # the federation account were stored correctly
    setOK = Signal()

    # Error signal to emit when the there is an error setting the new password
    errorPassword = Signal()

    def default_height(self):
        if get_user_profile(self.db):
            return get_user_profile(self.db)['height']

    def default_fedacct(self):
        return get_federation_account()

    # Properties block

    # Expose to QML the value of the person height
    height = Property(int, default_height, constant=True)

    # Expose to QML the value of federation account
    fedacct = Property(str, default_fedacct, constant=True)
