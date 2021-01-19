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


class NetworkSettings(QObject):

    db = TinyDB(dbfile)

    def update_federation_info(self, protocol, federation_server,
                               federation_port, federation_id, enable_sync):

        fedinfo = self.db.table('federation')
        # If the "Singleton" table is empty, insert, otherwise, update
        # TODO: Use upsert with doc_id == 1 as condition
        if not len(fedinfo):
            fedinfo.insert({'protocol': protocol,
                            'federation_server': federation_server,
                            'federation_port': federation_port,
                            'federation_id': federation_id,
                            'enable_sync': enable_sync})
        else:
            fedinfo.update({'protocol': protocol,
                            'federation_server': federation_server,
                            'federation_port': federation_port,
                            'federation_id': federation_id,
                            'enable_sync': enable_sync})

    @Slot(str, str, str, str, str)
    def test_connection(self, protocol, *args):
        conn_res = fc(protocol, *args)
        print(conn_res)

    @Slot(str, str, str, str, bool)
    def getvals(self, *args):
        self.update_federation_info(*args)

    # Signal to emit to QML if the values were stored correctly
    setOK = Signal()
