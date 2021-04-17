####################################################################
#   Copyright (C) 2020-2021 Luis Falcon <falcon@gnuhealth.org>
#   Copyright (C) 2020-2021 GNU Solidario <health@gnusolidario.org>
#   License: GPL v3+
#   Please read the COPYRIGHT and LICENSE files of the package
####################################################################

import datetime
from uuid import uuid4
from PySide2.QtCore import QObject, Signal, Slot, Property
from tinydb import TinyDB, Query
from mygnuhealth.myghconf import dbfile
from mygnuhealth.core import PageOfLife


class GHSleep(QObject):

    db = TinyDB(dbfile)

    def insert_values(self, sleeptime, sleepquality, information):
        sleep = self.db.table('sleep')
        current_date = datetime.datetime.now().isoformat()
        domain = 'lifestyle'
        context = 'sleep'

        sleep_event_id = str(uuid4())
        synced = False
        sleep.insert({'timestamp': current_date,
                      'event_id': sleep_event_id,
                      'synced': synced,
                      'sleeptime': sleeptime,
                      'sleepquality': sleepquality})

        print("Saved Sleep information", sleep_event_id,
              sleeptime, sleepquality, current_date)

        # Page of Life block related to Nutrition
        event_id = str(uuid4())
        monitor_readings = [
            {'sleep': {'sleeptime': sleeptime,
                       'sleepquality': sleepquality}},
            ]

        pol_vals = {
            'page': event_id,
            'page_date': current_date,
            'domain': domain,
            'context': context,
            'measurements': monitor_readings,
            'info': information
            }

        # Create the Page of Life associated to this reading
        PageOfLife.create_pol(PageOfLife, pol_vals)

    @Slot(int, str, str)
    def getvals(self, sleeptime, sleepquality, information):
        self.insert_values(sleeptime, sleepquality, information)
        self.setOK.emit()

    # Signal to emit to QML if the values were stored correctly
    setOK = Signal()
