####################################################################
#   Copyright (C) 2020-2021 Luis Falcon <falcon@gnuhealth.org>
#   Copyright (C) 2020-2021 GNU Solidario <health@gnusolidario.org>
#   GPL v3+
#   Please read the COPYRIGHT and LICENSE files of the package
####################################################################

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

    def default_weight(self):
        weighttable = self.db.table('weight')
        if (len(weighttable) > 0):
            last_weight = weighttable.all()[-1]
            return (last_weight['weight'])
        else:
            return 0

    def insert_values(self, body_weight):
        weighttable = self.db.table('weight')
        profiletable = self.db.table('profile')
        current_date = datetime.datetime.now().isoformat()
        domain = 'medical'
        context = 'self_monitoring'

        if body_weight > 0:
            event_id = str(uuid4())
            synced = False
            height = None
            bmi = None
            if (len(profiletable) > 0):
                height = profiletable.all()[0]['height']
            vals = {'timestamp': current_date,
                    'event_id': event_id,
                    'synced': synced,
                    'weight': body_weight}
            measurements = {'wt': body_weight}

            # If height is in the person profile, calculate the BMI
            if height:
                bmi = body_weight/((height/100)**2)
                bmi = round(bmi, 1)  # Use one decimal
                vals['bmi'] = bmi
                measurements['bmi'] = bmi

            weighttable.insert(vals)

            print("Saved weight", event_id, synced, body_weight, bmi,
                  current_date)

            # Create a new PoL with the values
            # within the medical domain and the self monitoring context
            pol_vals = {
                'page': event_id,
                'page_date': current_date,
                'domain': domain,
                'context': context,
                'measurements': [measurements]
                }

            # Create the Page of Life associated to this reading
            PageOfLife.create_pol(PageOfLife, pol_vals)

    @Slot(float)
    def getvals(self, body_weight):
        self.insert_values(body_weight)
        self.setOK.emit()

    # Signal to emit to QML if the body weight values were stored correctly
    setOK = Signal()

    # Expose to QML the value of the last weight recording
    last_weight = Property(float, default_weight, constant=True)
