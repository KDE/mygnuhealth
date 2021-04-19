####################################################################
#   Copyright (C) 2020-2021 Luis Falcon <falcon@gnuhealth.org>
#   Copyright (C) 2020-2021 GNU Solidario <health@gnusolidario.org>
#   GPL v3+
#   Please read the COPYRIGHT and LICENSE files of the package
####################################################################

import datetime
from uuid import uuid4
from PySide2.QtCore import QObject, Signal, Slot
from tinydb import TinyDB
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
        domain = 'medical'
        context = 'self_monitoring'

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
                'domain': domain,
                'context': context,
                'measurements': [{'osat': hb_osat}]
                }

            # Create the Page of Life associated to this reading
            PageOfLife.create_pol(PageOfLife, pol_vals)

    @Slot(int)
    def getvals(self, hb_osat):
        self.insert_values(hb_osat)
        self.setOK.emit()

    # Signal to emit to QML if the Osat values were stored correctly
    setOK = Signal()
