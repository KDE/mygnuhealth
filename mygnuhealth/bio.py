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


class GHBio(QObject):

    def __init__(self):
        QObject.__init__(self)

        self.current_bp = ""
        self.current_glucose = ""
        self.current_weight = ""
        self.current_osat = ""

    db = TinyDB(dbfile)

    def read_bp(self):
        # Retrieve the BP history
        blood_pressure = self.db.table('bloodpressure')
        bphist = blood_pressure.all()
        return bphist

    def read_hr(self):
        # Retrieve the HR history
        hr = self.db.table('heart_rate')
        hrhist = hr.all()
        return (hrhist)

    def getBP(self):
        # Extracts the latest readings from BP
        bphist = self.read_bp()
        hrhist = self.read_hr()
        bpobj = ['', '', '', '']  # Init to empty string to avoid undefined val
        if bphist and hrhist:
            bp = bphist[-1]  # Get the latest (newest) record
            hr = hrhist[-1]

            # dateobj =  datetime.datetime.fromisoformat(bp['timestamp'])
            dateobj = datefromisotz(bp['timestamp'])
            date_repr = dateobj.strftime("%a, %b %d '%y - %H:%M")

            bpobj = [str(date_repr), str(bp['systolic']), str(bp['diastolic']),
                     str(hr['heart_rate'])]

        return bpobj

    def BPplot(self):
        # Retrieves all the history and packages into an array.
        bphist = self.read_bp()
        bpsys = []
        bpdia = []
        bp_date = []
        lastreading = ''
        for element in bphist:

            dateobj = datefromisotz(element['timestamp'])
            date_repr = dateobj.strftime("%a, %b %d '%y")

            # Only print one value per day to avoid artifacts in plotting.
            # if (lastreading != date_repr):
            bp_date.append(dateobj)
            bpsys.append(element['systolic'])
            bpdia.append(element['diastolic'])
            # end block

            lastreading = date_repr

        fig, axs = plt.subplots(2)

        # Plot both systolic and diastolic history
        axs[0].plot(bp_date, bpsys)
        axs[1].plot(bp_date, bpdia, color='teal')

        axs[0].set_ylabel('Systolic', size=13)
        axs[1].set_ylabel('Diastolic', size=13)

        fig.autofmt_xdate()
        fig.suptitle("Blood Pressure (mm Hg)", size=20)
        holder = io.BytesIO()
        fig.savefig(holder, format="svg")
        image = "data:image/svg+xml;base64," + \
            base64.b64encode(holder.getvalue()).decode()

        holder.close()
        return image

    def HRplot(self):
        # Retrieves all the history and packages into an array.
        hrhist = self.read_hr()
        hr = []
        hr_date = []
        lastreading = ''
        for element in hrhist:
            dateobj = datefromisotz(element['timestamp'])
            date_repr = dateobj.strftime("%a, %b %d '%y")
            # Only print one value per day to avoid artifacts in plotting.
            # if (lastreading != date_repr):
            hr_date.append(dateobj)
            hr.append(element['heart_rate'])
            # End block
            
            lastreading = date_repr

        fig = plt.figure()
        ax = fig.add_subplot(1, 1, 1)

        ax.plot(hr_date, hr, color="orange")

        ax.set_ylabel('Frequency', size=13)
        fig.autofmt_xdate()
        fig.suptitle("Heart Rate (bpm)", size=20)

        holder = io.BytesIO()
        fig.savefig(holder, format="svg")
        image = "data:image/svg+xml;base64," + \
            base64.b64encode(holder.getvalue()).decode()

        holder.close()
        return image

    def setBP(self, bp):
        self.current_bp = bp
        # Call the notifying signal
        self.bpChanged.emit()

    # GLUCOSE
    def setGlucose(self, glucose):
        self.current_glucose = glucose
        # Call the notifying signal
        self.glucoseChanged.emit()

    def read_glucose(self):
        # Retrieve the blood glucose levels history
        glucose = self.db.table('glucose')
        glucosehist = glucose.all()
        return glucosehist

    def getGlucose(self):
        # Extracts the latest readings from Glucose
        glucosehist = self.read_glucose()
        glucoseobj = ['', '']
        if (glucosehist):  # Enter this block if there is a history
            glucose = glucosehist[-1]  # Get the latest (newest) record
            dateobj = datefromisotz(glucose['timestamp'])
            date_repr = dateobj.strftime("%a, %b %d '%y - %H:%M")

            glucoseobj = [str(date_repr), str(glucose['glucose'])]
        return glucoseobj

    def Glucoseplot(self):
        # Retrieves all the history and packages into an array.
        glucosehist = self.read_glucose()
        glucose = []
        glucose_date = []
        lastreading = ''
        for element in glucosehist:
            dateobj = datefromisotz(element['timestamp'])
            date_repr = dateobj.strftime("%a, %b %d '%y")
            # Only print one value per day to avoid artifacts in plotting.
            # if (lastreading != date_repr):
            glucose_date.append(dateobj)
            glucose.append(element['glucose'])

        fig = plt.figure()
        ax = fig.add_subplot(1, 1, 1)

        ax.plot(glucose_date, glucose, color="red")

        ax.set_ylabel('mg/dl', size=13)
        fig.autofmt_xdate()
        fig.suptitle("Glucose level (mg/dl)", size=20)

        holder = io.BytesIO()
        fig.savefig(holder, format="svg")
        image = "data:image/svg+xml;base64," + \
            base64.b64encode(holder.getvalue()).decode()

        holder.close()
        return image

    # WEIGHT
    def setWeight(self, weight):
        self.current_weight = weight
        # Call the notifying signal
        self.weightChanged.emit()

    def read_weight(self):
        # Retrieve the weight levels history
        weighttable = self.db.table('weight')
        weighthist = weighttable.all()
        return (weighthist)

    def getWeight(self):
        # Extracts the latest readings from Weight
        weighthist = self.read_weight()
        weightobj = ['', '']
        if (weighthist):
            weight = weighthist[-1]  # Get the latest (newest) record

            # dateobj =  datetime.datetime.fromisoformat(weight['timestamp'])
            dateobj = datefromisotz(weight['timestamp'])
            date_repr = dateobj.strftime("%a, %b %d '%y - %H:%M")

            weightobj = [str(date_repr), str(weight['weight'])]
        return weightobj

    def Weightplot(self):
        # Retrieves all the history and packages into an array.
        weighthist = self.read_weight()
        weight = []
        weight_date = []
        bmi = []
        lastreading = ''
        for element in weighthist:
            # dateobj = datetime.datetime.fromisoformat(element['timestamp'])
            dateobj = datefromisotz(element['timestamp'])
            date_repr = dateobj.strftime("%a, %b %d '%y")
            # Only print one value per day to avoid artifacts in plotting.
            # if (lastreading != date_repr):
            weight_date.append(dateobj)
            weight.append(element['weight'])
            if ('bmi' in element.keys()):
                # BMI depends on the height, so it will be present
                # only if the user has set the height on her profile
                bmi.append(element['bmi'])
            else:
                # Use numpy NaN for null values
                bmi.append(np.NaN)

        fig, axes = plt.subplots(nrows=2, ncols=1, figsize=(6, 8))

        axes[0].plot(weight_date, weight, color="blue")
        axes[1].plot(weight_date, bmi, color="teal")

        axes[0].set_ylabel('kg', size=13)
        axes[1].set_ylabel('kg/m2', size=13)
        fig.autofmt_xdate()
        fig.suptitle("Weight & Body Mass Index", size=20)

        holder = io.BytesIO()
        fig.savefig(holder, format="svg")
        image = "data:image/svg+xml;base64," + \
            base64.b64encode(holder.getvalue()).decode()

        holder.close()
        return (image)

    # OSAT
    def setOsat(self, osat):
        self.current_osat = osat
        # Call the notifying signal
        self.osatChanged.emit()

    def read_osat(self):
        # Retrieve the blood osat levels history
        osat = self.db.table('osat')
        osathist = osat.all()
        return osathist

    def getOsat(self):
        # Extracts the latest readings from Osat
        osathist = self.read_osat()
        osatobj = ['', '']
        if (osathist):
            osat = osathist[-1]  # Get the latest (newest) record

            # dateobj =  datetime.datetime.fromisoformat(osat['timestamp'])
            dateobj = datefromisotz(osat['timestamp'])
            date_repr = dateobj.strftime("%a, %b %d '%y - %H:%M")
            osatobj = [str(date_repr), str(osat['osat'])]
        return osatobj

    def Osatplot(self):
        # Retrieves all the history and packages into an array.
        osathist = self.read_osat()
        osat = []
        osat_date = []
        lastreading = ''
        for element in osathist:
            dateobj = datefromisotz(element['timestamp'])
            date_repr = dateobj.strftime("%a, %b %d '%y")
            osat_date.append(dateobj)
            osat.append(element['osat'])

        fig = plt.figure()
        ax = fig.add_subplot(1, 1, 1)

        ax.plot(osat_date, osat, color="red")

        ax.set_ylabel('%', size=13)
        fig.autofmt_xdate()
        fig.suptitle("Osat (%)", size=20)

        holder = io.BytesIO()
        fig.savefig(holder, format="svg")
        image = "data:image/svg+xml;base64," + \
            base64.b64encode(holder.getvalue()).decode()

        holder.close()
        return (image)

    # PROPERTIES BLOCK
    # Notifying signal - to be used in qml as "onBPChanged"
    bpChanged = Signal()

    # BP property to be accessed to and from QML and Python.
    # It is used in the context of showing the BP last results
    # in the main bio screen.
    bp = Property("QVariantList", getBP, setBP, notify=bpChanged)

    # Property to retrieve the plot of the Blood pressure.
    bpplot = Property(str, BPplot, setBP, notify=bpChanged)

    # Retrieve the heart rate history.
    # I made a different plot because the dates can differ from those of the 
    # Blood pressure monitor readings.
    hrplot = Property(str, HRplot, setBP, notify=bpChanged)

    # Notifying signal - to be used in qml as "onGlucoseChanged"
    glucoseChanged = Signal()

    # Glucose property to be accessed to and from QML and Python.
    # It is used in the context of showing the BP last results
    # in the main bio screen.
    glucose = Property("QVariantList", getGlucose, setGlucose,
                       notify=glucoseChanged)

    # Property to retrieve the plot of the blood glucose level.
    glucoseplot = Property(str, Glucoseplot, setGlucose, notify=bpChanged)

    # Notifying signal - to be used in qml as "onWeightChanged"
    weightChanged = Signal()

    # Weight property to be accessed to and from QML and Python.
    # It is used in the context of showing the BP last results
    # in the main bio screen.
    weight = Property("QVariantList", getWeight, setWeight,
                      notify=weightChanged)

    # Property to retrieve the plot of the blood weight level.
    weightplot = Property(str, Weightplot, setWeight, notify=bpChanged)

    # Notifying signal - to be used in qml as "onOsatChanged"
    osatChanged = Signal()

    # Osat property to be accessed to and from QML and Python.
    # It is used in the context of showing the BP last results
    # in the main bio screen.
    osat = Property("QVariantList", getOsat, setOsat, notify=osatChanged)

    # Property to retrieve the plot of the blood osat level.
    osatplot = Property(str, Osatplot, setOsat, notify=bpChanged)
