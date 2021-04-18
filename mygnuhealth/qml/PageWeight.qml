// SPDX-FileCopyrightText: 2020-2021 GNU Solidario <health@gnusolidario.org>
//                         2020-2021 Luis Falcon <falcon@gnuhealth.org>
//                         2021-2021 Carl Schwan <carlschwan@kde.org>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.7
import org.kde.kirigami 2.10 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Weight 0.1

Kirigami.Page {
    id: weightpage
    title: qsTr("Body Weight")

    Weight { // Weight object registered at mygh.py
        id: body_weight
        // Return to main monitor page once values are stored
        onSetOK: pageStack.pop()
    }

    ColumnLayout{
        anchors.centerIn: parent

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Body Weight")
            font.bold: true
        }
        SpinBox {
            id: spinweight
            editable: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: 50
            Layout.preferredWidth: 100

            font.pixelSize: 25

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

        Button {
            text: qsTr("Set")
            Layout.alignment: Qt.AlignHCenter
            icon.name: "list-add"
            onClicked: body_weight.getvals(spinweight.realValue)
        }

    }
}
