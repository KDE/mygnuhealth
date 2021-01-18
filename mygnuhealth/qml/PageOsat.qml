import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import Osat 0.1

Kirigami.ScrollablePage {
    id: glucosePage
    title: qsTr("Add Hemoglobin Oxygen Saturation Entry")

    Osat { // Osat object registered at main.py
        id: hb_osat
        onSetOK: {
            pageStack.pop() // Return to main monitor page once values are stored
        }
    }

    Kirigami.FormLayout {
        id: content
        SpinBox {
            id: txtOsat
            Kirigami.FormData.label: qsTr("Hemoglobin Oxygen Saturation Entry")
            to: 99
            from: 0
        }

        Button {
            id: buttonSetOsat
            text: qsTr("Add")
            icon.name: "list-add"
            onClicked: hb_osat.getvals(txtOsat.text);
        }
    }
}
