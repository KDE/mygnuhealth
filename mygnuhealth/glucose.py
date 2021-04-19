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


class Glucose(QObject):
    """Class that manages the person blood glucose readings

        Attributes:
        -----------
            db: TinyDB instance.
                Holds demographics and bio readings
        Methods:
        --------
            insert_values: Places the new reading values on the 'glucose' table
            and creates the associated page of life

    """

    db = TinyDB(dbfile)

    def insert_values(self, blood_glucose):
        """Places the new reading values on the 'glucose' table

        Parameters
        ----------
        blood_glucose: value coming from the getvals method
        """

        glucose = self.db.table('glucose')
        current_date = datetime.datetime.now().isoformat()
        domain = 'medical'
        context = 'self_monitoring'

        if blood_glucose > 0:
            event_id = str(uuid4())
            synced = False
            monitor_vals = {'timestamp': current_date,
                            'event_id': event_id,
                            'synced': synced,
                            'glucose': blood_glucose
                            }
            glucose.insert(monitor_vals)

            print("Saved glucose", event_id, synced, blood_glucose,
                  current_date)

            # Create a new PoL with the values
            # within the medical domain and the self monitoring context
            pol_vals = {
                'page': event_id,
                'page_date': current_date,
                'domain': domain,
                'context': context,
                'measurements': [{'bg': blood_glucose}]
                }

            # Create the Page of Life associated to this blood glucose reading
            PageOfLife.create_pol(PageOfLife, pol_vals)

    @Slot(int)
    def getvals(self, blood_glucose):
        """ Gets the value from the PageGlucose.qml file """
        self.insert_values(blood_glucose)
        self.setOK.emit()

    # Signal to emit to QML if the glucose values were stored correctly
    setOK = Signal()
