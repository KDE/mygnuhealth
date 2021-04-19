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


class MoodEnergy(QObject):

    db = TinyDB(dbfile)

    def insert_values(self, mood, energy):
        mood_table = self.db.table('mood')
        current_date = datetime.datetime.now().isoformat()
        moodmon = False  # Init to false the mood monitoring process
        domain = 'medical'
        context = 'self_monitoring'

        if (energy > -1):  # Will evaluate to True since energy lower lim = 0
            moodmon = True
            mood_event_id = str(uuid4())
            synced = False
            mood_table.insert({'timestamp': current_date,
                               'event_id': mood_event_id,
                               'synced': synced,
                               'mood': mood,
                               'energy': energy})

            print("Saved Mood and Energy Levels", mood_event_id, synced, mood,
                  energy, current_date)

        if (moodmon):
            # This block is related to the Page of Life creation
            event_id = str(uuid4())
            monitor_readings = [
                {'mood_energy': {'mood': mood, 'energy': energy}},
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

    @Slot(int, int)
    def getvals(self, *args):
        self.insert_values(*args)
        self.setOK.emit()

    # Signal to emit to QML if the mood and energy values were stored correctly
    setOK = Signal()
