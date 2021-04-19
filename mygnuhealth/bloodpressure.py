####################################################################
#   Copyright (C) 2020-2021 Luis Falcon <falcon@gnuhealth.org>
#   Copyright (C) 2020-2021 GNU Solidario <health@gnusolidario.org>
#   License: GPL v3+
#   Please read the COPYRIGHT and LICENSE files of the package
####################################################################

import datetime
from uuid import uuid4
from PySide2.QtCore import QObject, Signal, Slot
from tinydb import TinyDB
from mygnuhealth.myghconf import dbfile
from mygnuhealth.core import PageOfLife


class BloodPressure(QObject):

    db = TinyDB(dbfile)

    def insert_values(self, systolic, diastolic, heart_rate):
        blood_pressure = self.db.table('bloodpressure')
        hr = self.db.table('heart_rate')
        current_date = datetime.datetime.now().isoformat()
        bpmon = hrmon = False  # Init to false the bp and hr monitoring process
        domain = 'medical'
        context = 'self_monitoring'

        if (systolic > 0) and (diastolic > 0):
            bpmon = True
            bp_event_id = str(uuid4())
            synced = False
            blood_pressure.insert({'timestamp': current_date,
                                   'event_id': bp_event_id,
                                   'synced': synced,
                                   'systolic': systolic,
                                   'diastolic': diastolic})

            print("Saved blood pressure", bp_event_id, synced, systolic,
                  diastolic, current_date)

        if heart_rate > 0:
            hrmon = True
            hr_event_id = str(uuid4())
            synced = False
            hr.insert({'timestamp': current_date,
                       'event_id': hr_event_id,
                       'synced': synced,
                       'heart_rate': heart_rate})

            print("Saved Heart rate", hr_event_id, synced,
                  heart_rate, current_date)

        if (bpmon or hrmon):
            # This block is related to the Page of Life creation
            if (bpmon and hrmon):
                # Group both HR and BP monitors in one PoL if both readings
                # where taken at the same moment / device
                # The event_id will be unique
                event_id = str(uuid4())
                monitor_readings = [
                    {'bp': {'systolic': systolic, 'diastolic': diastolic}},
                    {'hr': heart_rate}
                    ]
            elif (bpmon and not hrmon):
                event_id = bp_event_id
                monitor_readings = [
                    {'bp': {'systolic': systolic, 'diastolic': diastolic}},
                    ]
            else:
                event_id = hr_event_id
                monitor_readings = [{'hr': heart_rate}]

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
    def getvals(self, *args):
        self.insert_values(*args)
        self.setOK.emit()

    # Signal to emit to QML if the blood pressure values were stored correctly
    setOK = Signal()
