import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import BloodPressure 0.1

Kirigami.ScrollablePage {

    id: bloodpressurePage
    title: qsTr("Add Blood Pressure Entry")

    font.pointSize: Kirigami.Theme.defaultFont.pointSize * 2

    BloodPressure { // BloodPressure object registered at main.py
        id: bloodpressure
        onSetOK: {
            pageStack.pop() // Return to main monitor page once values are stored
        }
    }

    Kirigami.FormLayout {
        id: content

        SpinBox {
            id: txtSystolic
            Kirigami.FormData.label: qsTr("Systolic")
            from: 0
            to: 999
        }

        SpinBox {
            id: txtDiastolic
            Kirigami.FormData.label: qsTr("Diastolic")
            from: 0
            to: 999
        }

        SpinBox {
            id: txtRate
            Kirigami.FormData.label: qsTr("Rate")
            from: 0
            to: 999
        }

        Button {
            id: buttonSetBP
            text: qsTr("Add")
            icon.name: "list-add"
            onClicked: bloodpressure.getvals(txtSystolic.text, txtDiastolic.text, txtRate.text);
        }
    }
}
