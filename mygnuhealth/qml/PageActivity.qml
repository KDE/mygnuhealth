import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import GHPhysicalActivity 0.1

Kirigami.ScrollablePage {

    id: physicalactivityPage
    title: qsTr("Physical Activity")

    // font.pointSize: Kirigami.Theme.defaultFont.pointSize * 2

    GHPhysicalActivity { // PhysicalActivity object registered at mygh.py
        id: physicalactivity
        onSetOK: {
            pageStack.pop() // Return to main monitor page once values are stored
        }
    }

    GridLayout {
        id: pagrid
        Layout.fillWidth: true
        columns: 2
        Rectangle {
            Layout.preferredWidth: (parent.width)/parent.columns*0.9
            Layout.preferredHeight: 100
            Text {
                text: qsTr("Aerobic")
                font.bold: true
                anchors.top: parent.top
            }
            SpinBox {
                id: paAerobic
                editable: true
                anchors.centerIn: parent
                height: parent.height*0.7
                width: parent.width*0.7
                font.pixelSize:height*0.5
                from: 0
                to: 600
            }
        }
        Rectangle {
            Layout.preferredWidth: (parent.width)/parent.columns*0.9
            Layout.preferredHeight: 100
            Text {
                text: qsTr("Anaerobic")
                font.bold: true
                anchors.top: parent.top
            }
            SpinBox {
                id: paAnaerobic
                editable: true
                anchors.centerIn: parent
                height: parent.height*0.7
                width: parent.width*0.7
                font.pixelSize:height*0.5
                from: 0
                to: 600
            }
        }
        Rectangle {
            Layout.preferredWidth: (parent.width)/parent.columns*0.9
            Layout.preferredHeight: 100
            anchors.horizontalCenter: pagrid.horizontalCenter
            TextField {
                id: paSteps
                placeholderText: qsTr("Steps")
                font.bold: true
            }
        }

        Button {
            id: buttonSetPA
            anchors.horizontalCenter: pagrid.horizontalCenter
            anchors.top: pagrid.bottom
            text: qsTr("Set")
            flat: false
            onClicked: {
                physicalactivity.getvals(paAerobic.value, paAnaerobic.value,
                                        paSteps.text);
            }
    }

    }

}

