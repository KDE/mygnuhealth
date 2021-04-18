// SPDX-FileCopyrightText: 2021 Carl Schwan <carlschwan@kde.org>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Glucose 0.1

Kirigami.Page {
    id: glucosePage
    title: qsTr("Blood Glucose Level")

    Glucose { // Glucose object registered at main.py
        id: blood_glucose
        onSetOK: pageStack.pop() // Return to main monitor page once values are stored
    }

    GridLayout {
        id: content
        anchors.centerIn: parent
        columns: 1
        Label {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Blood glucose level")
            font.bold: true
        }

        SpinBox {
            id: txtGlucose
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 50
            Layout.preferredWidth: 100
            font.pixelSize:25
            editable: true
            from: 0
            to: 700
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
