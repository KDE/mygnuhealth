####################################################################
#   Copyright (C) 2020-2021 Luis Falcon <falcon@gnuhealth.org>
#   Copyright (C) 2020-2021 GNU Solidario <health@gnusolidario.org>
#   License: GPL v3+
#   Please read the COPYRIGHT and LICENSE files of the package
####################################################################

import io
import datetime
from PySide2.QtCore import QObject, Signal, Slot, Property
from tinydb import TinyDB, Query
import matplotlib.pyplot as plt
import base64
import numpy as np
from mygnuhealth.core import datefromisotz
from mygnuhealth.myghconf import dbfile


class GHLifestyle(QObject):

    def __init__(self):
        QObject.__init__(self)

        self.current_pa = ""

    db = TinyDB(dbfile)

    def read_physical_activity(self):
        # Retrieve the physical activity history
        physical_activity = self.db.table('physicalactivity')
        pahist = physical_activity.all()
        return pahist

    def getPA(self):
        # Extracts the latest readings from Physical Activity table
        pahist = self.read_physical_activity()
        paobj = ['', '', '', '']  # Init to empty string to avoid undefined val
        if pahist:
            pa = pahist[-1]  # Get the latest (newest) record

            # dateobj =  datetime.datetime.fromisoformat(bp['timestamp'])
            dateobj = datefromisotz(pa['timestamp'])
            date_repr = dateobj.strftime("%a, %b %d '%y - %H:%M")

            paobj = [str(date_repr), str(pa['aerobic']),
                     str(pa['anaerobic']), str(pa['steps'])]

        return paobj

    def getPAHist(self):
        # Retrieves all the history and packages into an array.
        pahist = self.read_physical_activity()

        pa_aerobic = []
        pa_anaerobic = []
        steps = []
        for element in pahist:
            pa_aerobic.append(element['aerobic'])
            pa_anaerobic.append(element['anaerobic'])
            pa_anaerobic.append(element['steps'])
        aggrpahist.append(pa_aerobic)  # Aggregated aerobic + anaerobic info
        aggrpahist.append(pa_anaerobic)
        aggrpahist.append(steps)

        return pahist

    def paplot(self):
        # Retrieves all the history and packages into an array.
        pahist = self.read_physical_activity()
        pa_aerobic = []
        pa_anaerobic = []
        pa_date = []
        lastreading = ''
        for element in pahist:

            dateobj = datefromisotz(element['timestamp'])
            date_repr = dateobj.strftime("%a, %b %d '%y")

            # Only print one value per day to avoid artifacts in plotting.
            if (lastreading != date_repr):
                pa_date.append(dateobj)
                pa_aerobic.append(element['aerobic'])
                pa_anaerobic.append(element['anaerobic'])

            lastreading = date_repr

        fig, axs = plt.subplots(2)

        # Plot both systolic and diastolic history
        axs[0].plot(pa_date, pa_aerobic)
        axs[1].plot(pa_date, pa_anaerobic, color='teal')

        axs[0].set_ylabel('Aerobic', size=13)
        axs[1].set_ylabel('Anaerobic', size=13)

        fig.autofmt_xdate()
        fig.suptitle("Time (minutes)", size=20)
        holder = io.BytesIO()
        fig.savefig(holder, format="svg")
        image = "data:image/svg+xml;base64," + \
            base64.b64encode(holder.getvalue()).decode()

        holder.close()
        return image

    def setPA(self, pa):
        self.current_pa = pa
        # Call the notifying signal
        self.paChanged.emit()

    # PROPERTIES BLOCK
    # Notifying signal - to be used in qml as "onPAChanged"
    paChanged = Signal()

    # BP property to be accessed to and from QML and Python.
    # It is used in the context of showing the PA last results
    # in the main Lifestyle screen.
    pa = Property("QVariantList", getPA, setPA, notify=paChanged)

    # Property to retrieve the plot of the Physical Activity.
    paplot = Property(str, paplot, setPA, notify=paChanged)

