import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.15
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
        Rectangle {
            Layout.preferredWidth: (parent.width)/parent.columns*0.9
            Layout.preferredHeight: 100
            Text {
                text: qsTr("Systolic")
                font.bold: true
                anchors.top: parent.top
            }
            SpinBox {
                id: txtSystolic
                editable: true
                anchors.centerIn: parent
                height: parent.height*0.7
                width: parent.width*0.7
                font.pixelSize:height*0.5
                from: 0
                to: 300
            }
        }
        Rectangle {
            Layout.preferredWidth: (parent.width)/parent.columns*0.9
            Layout.preferredHeight: 100
            Text {
                text: qsTr("Diastolic")
                font.bold: true
                anchors.top: parent.top
            }
            SpinBox {
                id: txtDiastolic
                editable: true
                anchors.centerIn: parent
                height: parent.height*0.7
                width: parent.width*0.7
                font.pixelSize:height*0.5
                from: 0
                to: 250
            }
        }
        Rectangle {
            Layout.preferredWidth: (parent.width)/parent.columns*0.9
            Layout.preferredHeight: 100
            anchors.horizontalCenter: bpgrid.horizontalCenter
            Text {
                text: qsTr("Rate")
                font.bold: true
                anchors.top: parent.top
            }
            SpinBox {
                id: txtRate
                editable: true
                anchors.centerIn: parent
                height: parent.height*0.7
                width: parent.width*0.7
                font.pixelSize:height*0.5     
                from: 0
                to: 350
            }
        }

        Button {
            id: buttonSetBP
            anchors.horizontalCenter: bpgrid.horizontalCenter
            anchors.top: bpgrid.bottom
            text: qsTr("Set")
            flat: false
            onClicked: {
                bloodpressure.getvals(txtSystolic.value, txtDiastolic.value,
                                        txtRate.value);
            }
    }

    }

}

