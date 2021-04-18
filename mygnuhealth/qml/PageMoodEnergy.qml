import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import MoodEnergy 0.1

Kirigami.Page {
    id: moodPage
    title: qsTr("Today I feel...")
    Kirigami.Theme.backgroundColor: "white"

    MoodEnergy { // MoodEnergy object registered at mygh.py
        id: moodenergy
        onSetOK: {
            pageStack.pop() // Return to main monitor page once values are stored
        }
    }

    GridLayout {
        Layout.fillWidth: true
        anchors.fill: parent
        id: moodgrid

        Slider {
            id: moodLevel
            Layout.alignment: Qt.AlignLeft
            Layout.row: 1
            Layout.column: 1

            property var moodfocus: false
            orientation: Qt.Vertical
            from: -3
            to: 3
            stepSize: 1
            onMoved: moodfocus = true 
        }
        Rectangle {
            Layout.alignment: Qt.AlignRight
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.row: 1
            Layout.column: 2

            Image {
                height: 200
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                source: "../images/" + "mood" + moodLevel.value + ".svg"
            }
        }
        
        Slider {
            id: energyLevel
            Layout.alignment: Qt.AlignLeft
            Layout.row: 2
            Layout.column: 1

            property var energyfocus: false
            orientation: Qt.Vertical
            from: 0
            to: 3
            stepSize: 1
            onMoved: energyfocus = true 

        }


        Rectangle {
            Layout.alignment: Qt.AlignRight
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.row: 2
            Layout.column: 2

            Image {
                height: 200
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                source: "../images/" + "energy" + energyLevel.value + ".svg"
            }
        }


        Button {
            id: buttonSetMood
            Layout.alignment: Qt.AlignCenter
            Layout.row: 3
            Layout.column: 1
            Layout.columnSpan: 2
            
            text: qsTr("Set")
            flat: false
            // Enable only if the user has interacted with the sliders
            // in both the Mood and Energy levels
            enabled: (energyLevel.energyfocus && moodLevel.moodfocus)
            onClicked: moodenergy.getvals(moodLevel.value, energyLevel.value);
        }
    }
 
}

