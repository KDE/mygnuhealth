#!/usr/bin/env python3
##############################################################################
#
#    MyGNUHealth : Mobile and Desktop PHR node for GNU Health
#
#           MyGNUHealth is part of the GNU Health project
#
##############################################################################
#
#    GNU Health: The Libre Digital Health Ecosystem
#    Copyright (C) 2008-2021 Luis Falcon <falcon@gnuhealth.org>
#    Copyright (C) 2011-2021 GNU Solidario <health@gnusolidario.org>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################

import sys
import os
import dateutil.parser
from PySide2.QtWidgets import QApplication
from PySide2.QtCore import QObject, QUrl, Signal, Slot
from PySide2.QtQml import QQmlApplicationEngine, qmlRegisterType

from mygnuhealth.myghconf import verify_installation_status


# Common methods
# Use this method to be compatible with Python 3.6
# datetime fromisoformat is not present until Python 3.7
def datefromisotz(isotz):
    if isotz:
        return dateutil.parser.parse(isotz)


def main():
    # Initial installation check
    if (verify_installation_status()):
        from mygnuhealth.profile_settings import ProfileSettings
        from mygnuhealth.network_settings import NetworkSettings
        from mygnuhealth.local_account_manager import LocalAccountManager
        from mygnuhealth.bio import GHBio

        from mygnuhealth.bloodpressure import BloodPressure
        from mygnuhealth.glucose import Glucose
        from mygnuhealth.weight import Weight
        from mygnuhealth.osat import Osat
        from mygnuhealth.bol import GHBol

        from mygnuhealth.psycho import GHPsycho
        from mygnuhealth.moodenergy import MoodEnergy
        from mygnuhealth.page_of_life import PoL

        from mygnuhealth.lifestyle import GHLifestyle
        from mygnuhealth.physical_activity import GHPhysicalActivity
        from mygnuhealth.nutrition import GHNutrition
        from mygnuhealth.sleep import GHSleep

        from mygnuhealth.credits import GHAbout

    app = QApplication(sys.argv)

    # Register ProfileSettings to use in QML
    qmlRegisterType(ProfileSettings, "ProfileSettings", 0, 1,
                    "ProfileSettings")

    # Register NetworkSettings to use in QML
    qmlRegisterType(NetworkSettings, "NetworkSettings", 0, 1,
                    "NetworkSettings")

    # Register BloodPressure to use in QML
    qmlRegisterType(BloodPressure, "BloodPressure", 0, 1,
                    "BloodPressure")

    # Register Glucose to use in QML
    qmlRegisterType(Glucose, "Glucose", 0, 1,
                    "Glucose")

    # Register Weight to use in QML
    qmlRegisterType(Weight, "Weight", 0, 1,
                    "Weight")

    # Register Osat to use in QML
    qmlRegisterType(Osat, "Osat", 0, 1,
                    "Osat")

    # Register LocalAccountManager to use in QML
    qmlRegisterType(LocalAccountManager, "LocalAccountManager", 0, 1,
                    "LocalAccountManager")

    # Register GHBio to use in QML
    qmlRegisterType(GHBio, "GHBio", 0, 1,
                    "GHBio")

    # Register GHBol to use in QML
    qmlRegisterType(GHBol, "GHBol", 0, 1,
                    "GHBol")

    # Register Psycho to use in QML
    qmlRegisterType(GHPsycho, "GHPsycho", 0, 1,
                    "GHPsycho")

    # Register MoodEnergy to use in QML
    qmlRegisterType(MoodEnergy, "MoodEnergy", 0, 1,
                    "MoodEnergy")

    # Register GHLifestyle to use in QML
    qmlRegisterType(GHLifestyle, "GHLifestyle", 0, 1,
                    "GHLifestyle")

    # Register GHLifestyle to use in QML
    qmlRegisterType(GHPhysicalActivity, "GHPhysicalActivity", 0, 1,
                    "GHPhysicalActivity")

    # Register GHLifestyle to use in QML
    qmlRegisterType(GHNutrition, "GHNutrition", 0, 1,
                    "GHNutrition")

    # Register GHSleep to use in QML
    qmlRegisterType(GHSleep, "GHSleep", 0, 1,
                    "GHSleep")

    # Register PoL (Page of Life) to use in QML
    qmlRegisterType(PoL, "PoL", 0, 1,
                    "PoL")

    # Register About to use in QML
    qmlRegisterType(GHAbout, "GHAbout", 0, 1,
                    "GHAbout")

    engine = QQmlApplicationEngine()

    base_path = os.path.abspath(os.path.dirname(__file__))
    url = QUrl(f'file://{base_path}/qml/main.qml')
    engine.load(url)

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())


if __name__ == "__main__":
    main()
