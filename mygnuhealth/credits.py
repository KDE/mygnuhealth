#!/usr/bin/env python3
####################################################################
#   Copyright (C) 2020-2021 Luis Falcon <falcon@gnuhealth.org>
#   Copyright (C) 2020-2021 GNU Solidario <health@gnusolidario.org>
#   License: GPL v3+
#   Please read the COPYRIGHT and LICENSE files of the package
####################################################################

from mygnuhealth import about
from PySide2.QtCore import QObject, Signal, Property


class GHAbout(QObject):

    def aboutmygh(self):
        version = about.__version__
        author = about.__author__
        homepage = about.__homepage__
        copyright = about.__copyright__
        license = about.__license__
        info_email = about.__email__
        thanks = about.__thanks__

        credits = {'version': version, 'author': author,
                   'homepage': homepage, 'copyright': copyright,
                   'license': license, 'info_email': info_email,
                   'thanks': thanks}

        return credits

    # Expose the aboubt / credits dictionary to QML
    credits = Property("QVariant", aboutmygh, constant=True)
