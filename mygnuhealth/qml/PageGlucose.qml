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

    GridLayout {
        id: content
        columns: 1
        Rectangle {
            id: glucoseRect
            Layout.preferredWidth: (parent.width)/2
            Layout.preferredHeight: 100
            anchors.horizontalCenter: content.horizontalCenter
            Layout.alignment: Qt.AlignHCenter
            Text {
                text: qsTr("Blood glucose level")
                font.bold: true
                anchors.top: parent.top
            }

            SpinBox {
                id: txtGlucose
                editable: true
                anchors.centerIn: parent
                height: parent.height*0.7
                width: parent.width*0.7
                font.pixelSize:height*0.5     
                from: 0
                to: 700
            }
        }

        Button {
            id: buttonSetGlucose
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Set")
            icon.name: "list-add"
            onClicked: blood_glucose.getvals(txtGlucose.value);
        }
    }
}
