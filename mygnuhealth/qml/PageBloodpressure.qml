import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import BloodPressure 0.1

Kirigami.ScrollablePage {

    id: bloodpressurePage
    title: qsTr("Blood Pressure")

    // font.pointSize: Kirigami.Theme.defaultFont.pointSize * 2

    BloodPressure { // BloodPressure object registered at mygh.py
        id: bloodpressure
        onSetOK: {
            pageStack.pop() // Return to main monitor page once values are stored
        }
    }

    GridLayout {
        id: bpgrid
        Layout.fillWidth: true
        columns: 2
        Label {
            text: qsTr("Systolic")
            Layout.alignment: Qt.AlignHCenter
            font.bold: true
        }
        Label {
            text: qsTr("Diastolic")
            Layout.alignment: Qt.AlignHCenter
            font.bold: true
        }
        SpinBox {
            id: txtSystolic
            editable: true
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 50
            Layout.preferredWidth: 100
            font.pixelSize:25
            from: 0
            to: 300
        }
        SpinBox {
            id: txtDiastolic
            editable: true
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 50
            Layout.preferredWidth: 100
            font.pixelSize:25
            from: 0
            to: 250
        }
        Text {
            text: qsTr("Rate")
            Layout.alignment: Qt.AlignHCenter
            Layout.columnSpan: 2
            font.bold: true
        }
        SpinBox {
            id: txtRate
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 50
            Layout.preferredWidth: 100
            font.pixelSize:25
            editable: true
            from: 0
            to: 350
        }

        Button {
            id: buttonSetBP
            Layout.alignment: Qt.AlignHCenter
            Layout.columnSpan: 2
            text: qsTr("Set")
            flat: false
            onClicked: {
                bloodpressure.getvals(txtSystolic.value, txtDiastolic.value,
                                        txtRate.value);
            }
        }
    }

}

