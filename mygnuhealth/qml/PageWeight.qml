// SPDX-FileCopyrightText: 2020-2021 GNU Solidario <health@gnusolidario.org>
//                         2020-2021 Luis Falcon <falcon@gnuhealth.org>
//                         2021-2021 Carl Schwan <carlschwan@kde.org>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.7
import org.kde.kirigami 2.10 as Kirigami
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import Weight 0.1

Kirigami.Page {
    id: weightpage
    title: qsTr("Add Body Weight Entry")

    Weight { // Weight object registered at main.py
        id: body_weight
        // Return to main monitor page once values are stored
        onSetOK: pageStack.pop()
    }

    ColumnLayout{
        anchors.centerIn: parent

        Rectangle {
            id: weightcont
            Layout.preferredWidth: 200
            Layout.preferredHeight: 200
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true

            Text {
                text: qsTr("Body Weight")
                font.bold: true
                anchors.top: parent.top
            }
            SpinBox {
                id: spinweight
                editable: true
                anchors.centerIn: parent

                Layout.preferredHeight: parent.height*0.7
                Layout.preferredWidth: parent.width*0.9
                font.pixelSize: 45

                property real factor: 10
                from: 0 * factor
                to: 500 * factor
                stepSize: factor / 10

                value: body_weight.last_weight * factor

                property int decimals: 1
                property real realValue: value / factor

                validator: DoubleValidator {
                    bottom: Math.min(spinweight.from, spinweight.to)
                    top:  Math.max(spinweight.from, spinweight.to)
                }

                textFromValue: function(value, locale) {
                    return Number(value / factor).toLocaleString(locale, 'f', spinweight.decimals)
                }

                valueFromText: function(text, locale) {
                    return Number.fromLocaleString(locale, text) * factor
                }
            }
        }

        Button {
            text: qsTr("Set")
            Layout.alignment: Qt.AlignHCenter
            onClicked: body_weight.getvals(spinweight.realValue)
        }

    }
}
