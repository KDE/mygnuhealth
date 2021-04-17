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

    # PHYSICAL ACTIVITY
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

    def paplot(self):
        # Retrieves all the history and packages into an array.
        pahist = self.read_physical_activity()
        pa_aerobic = []
        pa_anaerobic = []
        pa_steps = []
        pa_date = []
        lastreading = ''
        for element in pahist:

            dateobj = datefromisotz(element['timestamp'])
            date_repr = dateobj.strftime("%a, %b %d '%y")

            # Only print one value per day to avoid artifacts in plotting.
            # if (lastreading != date_repr):
            pa_date.append(dateobj)
            pa_aerobic.append(element['aerobic'])
            pa_anaerobic.append(element['anaerobic'])
            pa_steps.append(element['steps'])

            lastreading = date_repr

        fig, axs = plt.subplots(3)

        # Plot aerobic, anaerobic and steps
        axs[0].plot(pa_date, pa_aerobic)
        axs[1].plot(pa_date, pa_anaerobic, color='teal')
        axs[2].plot(pa_date, pa_steps)

        axs[0].set_ylabel('Aerobic', size=13)
        axs[1].set_ylabel('Anaerobic', size=13)
        axs[2].set_ylabel('Steps', size=13)

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

    paChanged = Signal()

    # NUTRITION
    def read_nutrition(self):
        # Retrieve the nutrition history
        nutrition = self.db.table('nutrition')
        nutrihist = nutrition.all()
        return nutrihist

    def getNutrition(self):
        # Extracts the latest readings from Physical Activity table
        nutrihist = self.read_nutrition()
        # Init to empty string to avoid undefined val
        nutriobj = ['', '', '', '', '']
        if nutrihist:
            nutri = nutrihist[-1]  # Get the latest (newest) record

            dateobj = datefromisotz(nutri['timestamp'])
            date_repr = dateobj.strftime("%a, %b %d '%y - %H:%M")

            nutriobj = [str(date_repr), str(nutri['calmorning']),
                        str(nutri['calafternoon']),
                        str(nutri['calevening']),
                        str(nutri['caltotal'])
                        ]

        return nutriobj

    def nutriplot(self):
        # Retrieves all the history and packages into an array.
        nutrihist = self.read_nutrition()
        nutri_calmorning = []
        nutri_calafternoon = []
        nutri_calevening = []
        nutri_caltotal = []
        nutri_date = []
        lastreading = ''
        for element in nutrihist:

            dateobj = datefromisotz(element['timestamp'])
            date_repr = dateobj.strftime("%a, %b %d '%y")

            # Only print one value per day to avoid artifacts in plotting.
            # if (lastreading != date_repr):
            nutri_date.append(dateobj)
            nutri_calmorning.append(element['calmorning'])
            nutri_calafternoon.append(element['calafternoon'])
            nutri_calevening.append(element['calevening'])
            nutri_caltotal.append(element['caltotal'])
            # End of block
            
            lastreading = date_repr

        fig, axs = plt.subplots(4)

        # Plot aerobic, anaerobic and steps
        axs[0].plot(nutri_date, nutri_calmorning)
        axs[1].plot(nutri_date, nutri_calafternoon, color='teal')
        axs[2].plot(nutri_date, nutri_calevening)
        axs[3].plot(nutri_date, nutri_caltotal)

        axs[0].set_ylabel('Morning', size=13)
        axs[1].set_ylabel('Afternoon', size=13)
        axs[2].set_ylabel('Evening', size=13)
        axs[3].set_ylabel('Total', size=13)

        fig.autofmt_xdate()
        fig.suptitle("Calories", size=20)
        holder = io.BytesIO()
        fig.savefig(holder, format="svg")
        image = "data:image/svg+xml;base64," + \
            base64.b64encode(holder.getvalue()).decode()

        holder.close()
        return image

    def setNutrition(self, nutrition):
        self.current_nutrition = nutrition
        # Call the notifying signal
        self.nutritionChanged.emit()



    # SLEEP
    def read_sleep(self):
        # Retrieve the sleep history
        sleep = self.db.table('sleep')
        sleephist = sleep.all()
        return sleephist

    def getSleep(self):
        # Extracts the latest readings from Sleep table
        sleephist = self.read_sleep()
        # Init to empty string to avoid undefined val
        sleepobj = ['', '', '', '']
        if sleephist:
            sleep = sleephist[-1]  # Get the latest (newest) record

            dateobj = datefromisotz(sleep['timestamp'])
            date_repr = dateobj.strftime("%a, %b %d '%y - %H:%M")

            sleepobj = [str(date_repr), str(sleep['sleeptime']),
                        str(sleep['sleepquality'])]

        return sleepobj

    def sleepplot(self):
        # Retrieves all the history and packages into an array.
        sleephist = self.read_sleep()
        sleep_time = []
        sleep_date = []
        lastreading = ''
        for element in sleephist:

            dateobj = datefromisotz(element['timestamp'])
            date_repr = dateobj.strftime("%a, %b %d '%y")

            # Only print one value per day to avoid artifacts in plotting.
            # if (lastreading != date_repr):
            sleep_date.append(dateobj)
            sleep_time.append(element['sleeptime'])
            # End of block

            lastreading = date_repr

        fig = plt.figure()
        ax = fig.add_subplot(1, 1, 1)

        ax.plot(sleep_date, sleep_time, color="blue")

        ax.set_ylabel('Hours', size=13)
        fig.autofmt_xdate()
        fig.suptitle("Sleep hours", size=20)

        holder = io.BytesIO()
        fig.savefig(holder, format="svg")
        image = "data:image/svg+xml;base64," + \
            base64.b64encode(holder.getvalue()).decode()

        holder.close()
        return image

    def setSleep(self, sleep):
        self.current_sleep = sleep
        # Call the notifying signal
        self.sleepChanged.emit()

    # PROPERTIES BLOCK
    # BP property to be accessed to and from QML and Python.
    # It is used in the context of showing the PA last results
    # in the main Lifestyle screen.
    pa = Property("QVariantList", getPA, setPA, notify=paChanged)

    # Property to retrieve the plot of the Physical Activity.
    paplot = Property(str, paplot, setPA, notify=paChanged)

    # Notifying signal - to be used in qml as "onPAChanged"
    nutritionChanged = Signal()

    # Nutrition property to be accessed to and from QML and Python.
    # It is used in the context of showing the Nutrition last results
    # in the main Lifestyle screen.
    nutrition = Property("QVariantList", getNutrition,
                         setNutrition, notify=nutritionChanged)

    # Property to retrieve the plot of the Physical Activity.
    nutritionplot = Property(str, nutriplot, setNutrition,
                             notify=nutritionChanged)

    # Notifying signal - to be used in qml as "onSleepChanged"
    sleepChanged = Signal()

    # Nutrition property to be accessed to and from QML and Python.
    # It is used in the context of showing the Nutrition last results
    # in the main Lifestyle screen.
    sleep = Property("QVariantList", getSleep,
                     setSleep, notify=sleepChanged)

    # Property to retrieve the plot of the Physical Activity.
    sleepplot = Property(str, sleepplot, setSleep,
                         notify=sleepChanged)
