import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import GHSleep 0.1

Kirigami.Page {

    id: sleepPage
    title: qsTr("Sleep")

    // font.pointSize: Kirigami.Theme.defaultFont.pointSize * 2

    GHSleep { // PhysicalActivity object registered at mygh.py
        id: sleep
        onSetOK: {
            pageStack.pop() // Return to main monitor page once values are stored
        }
    }

    GridLayout {
        anchors.centerIn: parent

        id: sleepgrid
        columns: 1
        Label {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Hours")
        }

        SpinBox {
            id: sleepHours
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 50
            Layout.preferredWidth: 100
            font.pixelSize:25

            editable: true
            from: 0
            to: 24
        }

        ComboBox {
            id: sleepQuality
            textRole: "text"
            valueRole: "value"
            model: [
                { value: "good", text: qsTr("Good") },
                { value: "light", text: qsTr("Light") },
                { value: "poor", text: qsTr("Poor") }
            ]
        }

        TextArea {
            id:information
            Layout.fillWidth: true
            placeholderText: qsTr("Enter details here")
            wrapMode: TextEdit.WordWrap
        }


        Button {
            id: buttonSetSleep
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Set")
            flat: false
            onClicked: {
                sleep.getvals(sleepHours.value, sleepQuality.currentValue,
                                  information.text);
            }
        }      

    }

}

