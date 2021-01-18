from PySide2.QtCore import QObject, Signal, Slot, Property
import bcrypt
from tinydb import TinyDB, Query
from mygnuhealth.myghconf import dbfile
from mygnuhealth.core import get_personal_key


class GHLogin(QObject):
    """This class manages the login and initialization of the personal key

        Attributes:
        -----------
            db: Main MyGH database instance
                Holds the credentials table
            login_OK: Signal to emit when entering the correct personal key
            errorOccurred: Signal to emit when enteting the wrong key

            init_key: Property that exposes the initialization status of
                    personal key.

        Methods:
        --------
            check_initpwd: Verifies if the personal key has been initialized
            init_personal_key: Sets the personal key at the initial run.
            getkey: Slot that receives the personal key to login, and checks
                    if it is the correct one to log in.
            getInittKey: Slot that receives the initial personal key

    """

    def __init__(self):
        QObject.__init__(self)

    db = TinyDB(dbfile)

    def check_initpwd(self):
        if (self.db.table('credentials')):
            print("DB is initialized")
            rc = "set"
        else:
            print("We need to init the personal Key")
            rc = "unset"

        return rc

    def init_personal_key(self, key):
        encrypted_key = bcrypt.hashpw(key.encode('utf-8'),
                                      bcrypt.gensalt()).decode('utf-8')

        credentialstable = self.db.table('credentials')
        if (len(credentialstable) > 0):
            credentialstable.update({'personal_key': encrypted_key})
        else:
            print("Initializing credentials table")
            credentialstable.insert({'personal_key': encrypted_key})

        print("Initialized personal key", encrypted_key)
        return encrypted_key

    @Slot(str)
    def getKey(self, key):

        key = key.encode()

        personal_key = get_personal_key(self.db)

        if bcrypt.checkpw(key, personal_key):
            print("Login correct - Move to main PHR page")
            self.loginOK.emit()
        else:
            self.errorOccurred.emit()

    @Slot(str)
    def getInittKey(self, key):
        key = key.encode()
        if (self.init_personal_key(key.decode('utf-8'))):
            self.loginOK.emit()
        else:
            self.errorOccurred.emit()

    # Signal to emit to QML if the provided credentials are correct
    loginOK = Signal()
    # Signal to emit if the password is incorrect
    errorOccurred = Signal()

    # Property that exposes to QML the personal key initialization status
    init_key = Property(str, check_initpwd, constant=True)

