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


class GHPhysicalActivity(QObject):

    db = TinyDB(dbfile)

    def insert_values(self, aerobic, anaerobic, steps):
        physical_activity = self.db.table('physicalactivity')
        current_date = datetime.datetime.now().isoformat()
        pamon = stepsmon = False  # Init to false 
        domain = 'lifestyle'
        context = 'physical_activity'

        pa_event_id = str(uuid4())
        synced = False
        physical_activity.insert({'timestamp': current_date,
                                  'event_id': pa_event_id,
                                  'synced': synced,
                                  'aerobic': aerobic,
                                  'anaerobic': anaerobic,
                                  'steps': steps})

        print("Saved Physical Activity", pa_event_id, synced, aerobic,
              anaerobic, steps, current_date)

        # Page of Life block related to Physical Activity
        event_id = str(uuid4())
        monitor_readings = [
            {'pa': {'aerobic': aerobic, 'anaerobic': anaerobic,
                    'steps': steps}},
            ]

        pol_vals = {
            'page': event_id,
            'page_date': current_date,
            'domain': domain,
            'context': context,
            'measurements': monitor_readings
            }

        # Create the Page of Life associated to this reading
        PageOfLife.create_pol(PageOfLife, pol_vals)

    @Slot(int, int, int)
    def getvals(self, aerobic, anaerobic, steps):
        self.insert_values(aerobic, anaerobic, steps)
        self.setOK.emit()

    # Signal to emit to QML if the values were stored correctly
    setOK = Signal()
