import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import GHPhysicalActivity 0.1

Kirigami.Page {

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
        anchors.centerIn: parent

        id: pagrid
        columns: 2
        Label {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Aerobic")
            font.bold: true
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Anaerobic")
            font.bold: true
        }
        SpinBox {
            id: paAerobic
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 50
            Layout.preferredWidth: 100
            font.pixelSize:25

            editable: true
            from: 0
            to: 600
        }
        SpinBox {
            id: paAnaerobic
            editable: true
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 50
            Layout.preferredWidth: 100
            font.pixelSize:25
            from: 0
            to: 600
        }
        TextField {
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignHCenter
            id: paSteps
            placeholderText: qsTr("Steps")
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
        }

        Button {
            id: buttonSetPA
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Set")
            flat: false
            onClicked: {
                physicalactivity.getvals(paAerobic.value, paAnaerobic.value,
                                        paSteps.text);
            }
        }      

    }

}

