import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import MoodEnergy 0.1

Kirigami.Page {

    id: moodPage
    title: qsTr("Today I feel...")

    // font.pointSize: Kirigami.Theme.defaultFont.pointSize * 2

    MoodEnergy { // MoodEnergy object registered at mygh.py
        id: moodenergy
        onSetOK: {
            pageStack.pop() // Return to main monitor page once values are stored
        }
    }

    Rectangle{
        id:mainarea
        color: "white"
        height: 500
        width: 350
        GridLayout {
            anchors.horizontalCenter: mainarea.horizontalCenter
            id: moodgrid
            columns: 2
            Slider {
                id: moodLevel
                Layout.alignment: Qt.AlignLeft
                property var moodfocus: false
                orientation: Qt.Vertical
                from: -3
                to: 3
                stepSize: 1
                onMoved: moodfocus = true 
            }
            Rectangle {
                width: 200
                height: 200
                Image {
                    height: 200
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    source: "../images/" + "mood" + moodLevel.value + ".svg"
                }
            }
            Slider {
                id: energyLevel
                property var energyfocus: false
                orientation: Qt.Vertical
                from: 0
                to: 3
                stepSize: 1
                onMoved: energyfocus = true 

            }
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 200
                height: 200
                Image {
                    height: 200
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    source: "../images/" + "energy" + energyLevel.value + ".svg"
                }
            }
        }
        Button {
            id: buttonSetMood
            anchors.horizontalCenter: mainarea.horizontalCenter
            anchors.bottom: mainarea.bottom

            text: qsTr("Set")
            flat: false
            // Enable only if the user has interacted with the sliders
            // in both the Mood and Energy levels
            enabled: (energyLevel.energyfocus && moodLevel.moodfocus)
            onClicked: moodenergy.getvals(moodLevel.value, energyLevel.value);
        }
    }

}

