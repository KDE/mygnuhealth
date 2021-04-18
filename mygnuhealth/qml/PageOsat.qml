import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Osat 0.1

Kirigami.Page
{
id: glucosePage
title: qsTr("Hemoglobin Oxygen Saturation")

    Osat { // Osat object registered at main.py
        id: hb_osat
        onSetOK: {
            pageStack.pop() // Return to main monitor page once values are stored
        }
    }

    ColumnLayout {
        id: content
        spacing: 10
        anchors.centerIn: parent
        TextField {
            id: txtOsat
            placeholderText: qsTr("Osat")
            maximumLength: 2
            font.pointSize: 30
            font.bold: true
            horizontalAlignment: TextInput.AlignHCenter
            background: Rectangle {
                implicitWidth: 40
                implicitHeight: 200
                }
            }

        Button {
            id: buttonSetOsat
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Done")
            flat: false
            onClicked: {
                hb_osat.getvals(txtOsat.text);
            }

        }
    }
}
