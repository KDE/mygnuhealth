import datetime
from uuid import uuid4
from PySide2.QtCore import QObject, Signal, Slot, Property
from tinydb import TinyDB, Query
from mygnuhealth.myghconf import dbfile
from mygnuhealth.core import PageOfLife


class Osat(QObject):
    """Class that manages the person Hb oxygen saturation readings

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

    def insert_values(self, hb_osat):
        osat = self.db.table('osat')
        current_date = datetime.datetime.now().isoformat()

        if hb_osat > 0:
            event_id = str(uuid4())
            synced = False
            osat.insert({'timestamp': current_date,
                         'event_id': event_id,
                         'synced': synced,
                         'osat': hb_osat})

            print("Saved osat", event_id, synced, hb_osat, current_date)

            # Create a new PoL with the values
            # within the medical domain and the self monitoring context
            pol_vals = {
                'page': event_id,
                'page_date': current_date,
                'measurements': [{'osat': hb_osat}]
                }

            # Create the Page of Life associated to this reading
            PageOfLife.create_pol(PageOfLife, pol_vals, 'medical',
                                  'self_monitoring')

    @Slot(int)
    def getvals(self, hb_osat):
        self.insert_values(hb_osat)
        self.setOK.emit()

    # Signal to emit to QML if the Osat values were stored correctly
    setOK = Signal()
