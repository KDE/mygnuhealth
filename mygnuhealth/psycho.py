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


class GHPsycho(QObject):

    def __init__(self):
        QObject.__init__(self)

        self.current_mood = ""
        self.current_energy = ""

    db = TinyDB(dbfile)

    def read_mood(self):
        # Retrieve the  history
        mood_table = self.db.table('mood')
        moodhist = mood_table.all()
        return moodhist

    def getMood(self):
        # Extracts the latest readings from mood table (both mood and energy)
        moodhist = self.read_mood()
        moodobj = ['', '', '']  # Init to empty string to avoid undefined val
        if moodhist:
            mood = moodhist[-1]  # Get the latest (newest) record

            dateobj = datefromisotz(mood['timestamp'])
            date_repr = dateobj.strftime("%a, %b %d '%y - %H:%M")

            moodobj = [str(date_repr), str(mood['mood']), str(mood['energy'])]

        return moodobj

    def moodplot(self):
        # Retrieves all the history and packages into an array.
        moodhist = self.read_mood()
        mood = []
        energy = []
        mood_date = []
        lastreading = ''
        for element in moodhist:

            dateobj = datefromisotz(element['timestamp'])
            date_repr = dateobj.strftime("%a, %b %d '%y")

            # Only print one value per day to avoid artifacts in plotting.
            #if (lastreading != date_repr):
            mood_date.append(dateobj)
            mood.append(element['mood'])
            energy.append(element['energy'])
            # end block
    
            lastreading = date_repr

        print(f"Info to plot...{mood} {energy} {moodhist}")

        fig, axs = plt.subplots(2)

        # Plot both mood and energy history
        axs[0].plot(mood_date, mood)
        axs[1].plot(mood_date, energy, color='teal')

        axs[0].set_ylabel('Mood', size=13)
        axs[1].set_ylabel('Energy', size=13)

        axs[0].set_ylim([-3, 3])
        axs[1].set_ylim([0, 3])

        fig.autofmt_xdate()
        fig.suptitle("Mood and Energy", size=20)
        holder = io.BytesIO()
        fig.savefig(holder, format="svg")
        image = "data:image/svg+xml;base64," + \
            base64.b64encode(holder.getvalue()).decode()

        holder.close()
        return image

    def setMood(self, mood):
        self.current_mood = mood
        # Call the notifying signal
        self.moodChanged.emit()

    # PROPERTIES BLOCK
    # Notifying signal - to be used in qml as "onMoodChanged"
    moodChanged = Signal()

    # mood property to be accessed to and from QML and Python.
    # It is used in the context of showing the Mood and Energy last results
    # in the main bio screen.
    mood = Property("QVariantList", getMood, setMood, notify=moodChanged)

    # Property to retrieve the plot of the Mood and Energy 
    moodplot = Property(str, moodplot, setMood, notify=moodChanged)

