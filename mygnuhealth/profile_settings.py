import datetime
from PySide2.QtCore import QObject, Signal, Slot, Property
from tinydb import TinyDB, Query
import bcrypt
from mygnuhealth.myghconf import dbfile
from mygnuhealth.core import get_personal_key


class ProfileSettings(QObject):

    db = TinyDB(dbfile)

    # TODO: Include date of birth, height and sex

    def check_current_password(self, current_password):
        personal_key = get_personal_key(self.db)
        cpw = current_password.encode()
        rc = bcrypt.checkpw(cpw, personal_key)
        if not rc:
            print("Wrong current password")
        return rc

    def check_new_password(self, password, password_repeat):
        rc = password == password_repeat
        if not rc:
            print("New passwords do not match")
        return rc

    def update_personalkey(self, password):
        encrypted_key = bcrypt.hashpw(password.encode('utf-8'),
                                      bcrypt.gensalt()).decode('utf-8')

        credentials = self.db.table('credentials')
        credentials.update({'personal_key': encrypted_key})

        print("Saved personal key", encrypted_key)

    def update_fedacct(self, fedacct):
        credentials = self.db.table('federation')
        credentials.update({'federation_account': fedacct})

        print("Saved personal key", fedacct)

    @Slot(str)
    def get_fedacct(self, userfedacct):
        if (userfedacct):
            self.update_fedacct(userfedacct)
            self.setOK.emit()

    @Slot(str, str, str)
    def getvals(self, current_password, password, password_repeat):
        if (self.check_current_password(current_password) and
                self.check_new_password(password, password_repeat)):
            self.update_personalkey(password)
            self.setOK.emit()

    # Signal to emit to QML if the password or
    # the federation account was stored correctly
    setOK = Signal()
