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
from mygnuhealth.fedlogin import test_federation_connection as fc
import json


class NetworkSettings(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.db = TinyDB(dbfile)
        self.fed_table = self.db.table('federation')
        self.fedinfo = {}
        # Cast to dict the resulting tinydb.table.Document 
        if (len(self.fed_table) > 0):
            self.fedinfo = dict(self.fed_table.all()[0])

    def conn_params(self):
        return self.fedinfo

    def update_federation_info(self, protocol, federation_server,
                               federation_port, enable_sync):

        # If the "Singleton" table is empty, insert, otherwise, update
        # TODO: Use upsert with doc_id == 1 as condition
        if not len(self.fed_table):
            self.fed_table.insert({'protocol': protocol,
                                   'federation_server': federation_server,
                                   'federation_port': federation_port,
                                   'enable_sync': enable_sync})
        else:
            self.fed_table.update({'protocol': protocol,
                                   'federation_server': federation_server,
                                   'federation_port': federation_port,
                                   'enable_sync': enable_sync})

        self.setOK.emit()

    @Signal
    def connChanged(self):
        pass

    @Slot(str, str, str, str, str)
    def test_connection(self, protocol, *args):
        conn_res = fc(protocol, *args)
        if (conn_res == 0):
            self.connectionOK.emit()
        if (conn_res == -1):
            self.invalidCredentials.emit()
        if (conn_res == -2):
            self.connectionError.emit()

    @Slot(str, str, str, bool)
    def getvals(self, *args):
        self.update_federation_info(*args)

    # Signal to emit to QML if the values were updated correctly
    setOK = Signal()

    # Signal to emit if the test connection to Thalamus was successful
    connectionOK = Signal()

    # Signal to emit when wrong credentials
    invalidCredentials = Signal()

    # Signal to emit when there is an error in the connection
    connectionError = Signal()

    # Properties block

    # Expose to QML the the federation conn settings
    conn = Property("QVariant", conn_params, notify=connChanged)
