// SPDX-FileCopyrightText: 2021 Carl Schwan <carlschwan@kde.org>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import Weight 0.1

Kirigami.ScrollablePage {
    id: glucosePage
    title: qsTr("Add Body Weight Entry")

    Weight { // Weight object registered at main.py
        id: body_weight
        // Return to main monitor page once values are stored
        onSetOK: pageStack.pop()
    }

    Kirigami.FormLayout {
        SpinBox {
            id: txtWeight
            Kirigami.FormData.label: qsTr("Body Weight")
            textFromValue: function(value) {
                return qsTr("%1 kg", value);
            }
            from: 0
            to: 500
        }

        Button {
            icon.name: "list-add"
            text: qsTr("Add")
            onClicked: body_weight.getvals(txtWeight.text)
        }
    }
}
