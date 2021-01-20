// SPDX-FileCopyrightText: 2021 Carl Schwan <carlschwan@kde.org>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import Glucose 0.1

Kirigami.ScrollablePage {
    id: glucosePage
    title: qsTr("Add Blood Glucose Level")

    Glucose { // Glucose object registered at main.py
        id: blood_glucose
        onSetOK: pageStack.pop() // Return to main monitor page once values are stored
    }

    Kirigami.FormLayout {
        id: content
        SpinBox {
            id: txtGlucose
            height: 200
            font.pixelSize:height*0.9
        }

        Button {
            id: buttonSetGlucose
            text: qsTr("Add")
            icon.name: "list-add"
            onClicked: blood_glucose.getvals(txtGlucose.value);
        }
    }
}
