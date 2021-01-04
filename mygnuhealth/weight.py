import datetime
from uuid import uuid4
from PySide2.QtCore import QObject, Signal, Slot, Property
from tinydb import TinyDB, Query
from mygnuhealth.myghconf import dbfile
from mygnuhealth.core import PageOfLife


class Weight(QObject):
    """Class that manages the person weight readings

        Attributes:
        -----------
            db: TinyDB instance.
                Holds demographics and bio readings
        Methods:
        --------
            insert_values: Places the new reading values on the 'weight'
            and creates the associated page of life
    """

    db = TinyDB(dbfile)

    def insert_values(self, body_weight):
        weight = self.db.table('weight')
        current_date = datetime.datetime.now().isoformat()

        if body_weight > 0:
            event_id = str(uuid4())
            synced = False
            weight.insert({'timestamp': current_date,
                           'event_id': event_id,
                           'synced': synced,
                           'weight': body_weight})

            print("Saved weight", event_id, synced, body_weight, current_date)

            # Create a new PoL with the values
            # within the medical domain and the self monitoring context
            pol_vals = {
                'page': event_id,
                'page_date': current_date,
                'measurements': [{'wt': body_weight}]
                }

            # Create the Page of Life associated to this reading
            PageOfLife.create_pol(PageOfLife, pol_vals, 'medical',
                                  'self_monitoring')

    @Slot(float)
    def getvals(self, body_weight):
        self.insert_values(body_weight)
        self.setOK.emit()

    # Signal to emit to QML if the body weight values were stored correctly
    setOK = Signal()
