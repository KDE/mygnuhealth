import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import GHPsycho 0.1

Kirigami.Page {

    id: moodPage
    title: qsTr("Mood and Energy")

    GHPsycho { // Psycho object registered at mygh.py
        id: ghpsycho
    }

    ColumnLayout {
        spacing: Kirigami.Units.gridUnit

        Kirigami.CardsLayout {

            // Mood and Energy
            Kirigami.Card {
                banner {
                    iconSource: Qt.resolvedUrl("../images/psycho-square-icon.svg")
                    title: qsTr("Mood and Energy")
                }
                actions: [
                    Kirigami.Action {
                        icon.name: "view-visible"
                        text: qsTr("View Chart")
                        onTriggered: pageStack.push(Qt.resolvedUrl("PageMoodEnergyChart.qml"))
                    },
                    Kirigami.Action {
                        icon.name: "document-edit"
                        onTriggered: pageStack.push(Qt.resolvedUrl("PageMoodEnergy.qml"))
                        text: qsTr("New entry")
                    }
                ]
                contentItem: Column {
                    id: moodhist
                    readonly property var moodinfo: ghpsycho.mood
                    readonly property var mooddate: moodinfo[0]
                    readonly property var mood: moodinfo[1]
                    readonly property var energy: moodinfo[2]

                    Label {
                        id: txtmooddate
                        horizontalAlignment: Text.AlignHCenter
                        text: moodhist.mooddate
                        width: parent.width
                    }

                    Label {
                        text: qsTr("Mood : %1").arg(moodhist.mood)
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                        font.weight: Font.Bold
                    }

                    Label {
                        text: qsTr("Energy : %1").arg(moodhist.energy)
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                    }
                }
            }
        }
    }
}
