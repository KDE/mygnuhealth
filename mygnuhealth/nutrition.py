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


class GHNutrition(QObject):

    db = TinyDB(dbfile)

    def insert_values(self, calmorning, calafternoon, calevening, caltotal,
                      information):
        nutrition = self.db.table('nutrition')
        current_date = datetime.datetime.now().isoformat()
        domain = 'lifestyle'
        context = 'nutrition'

        nutrition_event_id = str(uuid4())
        synced = False
        nutrition.insert({'timestamp': current_date,
                          'event_id': nutrition_event_id,
                          'synced': synced,
                          'calmorning': calmorning,
                          'calafternoon': calafternoon,
                          'calevening': calevening,
                          'caltotal': caltotal})

        print("Saved Nutrition information", nutrition_event_id,
              calmorning, calafternoon, calevening, caltotal, current_date)

        # Page of Life block related to Nutrition
        event_id = str(uuid4())
        monitor_readings = [
            {'nutrition': {'calmorning': calmorning,
                           'calafternoon': calafternoon,
                           'calevening': calevening, 'caltotal': caltotal}},
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

    @Slot(int, int, int, int, str)
    def getvals(self, calmorning, calafternoon, calevening, caltotal,
                information):
        self.insert_values(calmorning, calafternoon, calevening, caltotal,
                           information)
        self.setOK.emit()

    # Signal to emit to QML if the blood pressure values were stored correctly
    setOK = Signal()
