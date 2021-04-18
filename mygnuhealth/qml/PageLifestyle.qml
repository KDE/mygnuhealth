import QtQuick 2.7
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.5 as Kirigami
import GHLifestyle 0.1

Kirigami.ScrollablePage
{
    id: lifestylepage
    title: qsTr("GNU Health - Lifestyle")

    GHLifestyle { // GHLifestyle object registered at mygh.py
        id: ghlifestyle
    }

    ColumnLayout {
        spacing: Kirigami.Units.gridUnit

        Kirigami.CardsLayout {

            // Training / physical activity
            Kirigami.Card {
                banner {
                    iconSource: Qt.resolvedUrl("../images/steps-icon.svg")
                    title: qsTr("Physical activity")
                }
                actions: [
                    Kirigami.Action {
                        icon.name: "view-visible"
                        text: qsTr("View Chart")
                        onTriggered: pageStack.push(Qt.resolvedUrl("PageActivityChart.qml"))
                    },
                    Kirigami.Action {
                        icon.name: "document-edit"
                        onTriggered: pageStack.push(Qt.resolvedUrl("PageActivity.qml"))
                        text: qsTr("Add Physical Activity")
                    }
                ]
                contentItem: Column {
                    id: pahist
                    readonly property var painfo: ghlifestyle.pa
                    readonly property var padate: painfo[0]
                    readonly property var paaerobic: painfo[1]
                    readonly property var paanaerobic: painfo[2]
                    readonly property var pasteps: painfo[3]

                    Label {
                        id: txtPadate
                        horizontalAlignment: Text.AlignHCenter
                        text: pahist.padate
                        width: parent.width
                    }

                    Label {
                        text: qsTr("Activity (minutes): %1 aerobic || %2 anaerobic").arg(pahist.paaerobic).arg(pahist.paanaerobic)
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                        font.weight: Font.Bold
                    }

                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("%1 steps").arg(pahist.pasteps)
                        width: parent.width
                    }
                }
            }

            // Nutrition
            Kirigami.Card {
                banner {
                    iconSource: Qt.resolvedUrl("../images/calories-icon.svg")
                    title: qsTr("Nutrition")
                }
                actions: [
                    Kirigami.Action {
                        icon.name: "view-visible"
                        text: qsTr("View Chart")
                        onTriggered: pageStack.push(Qt.resolvedUrl("PageNutritionChart.qml"))
                    },
                    Kirigami.Action {
                        icon.name: "document-edit"
                        onTriggered: pageStack.push(Qt.resolvedUrl("PageNutrition.qml"))
                        text: qsTr("Add Nutrition info")
                    }
                ]
                contentItem: Column {
                    id: nutrihist
                    readonly property var nutrinfo: ghlifestyle.nutrition
                    readonly property var nutridate: nutrinfo[0]
                    readonly property var nutrimorning: nutrinfo[1]
                    readonly property var nutriafternoon: nutrinfo[2]
                    readonly property var nutrievening: nutrinfo[3]
                    readonly property var nutritotal: nutrinfo[4]

                    Label {
                        id: txtNutridate
                        horizontalAlignment: Text.AlignHCenter
                        text: nutrihist.nutridate
                        width: parent.width
                    }

                    Label {
                        text: qsTr("%1 morning | %2 afternoon | %3 evening").arg(nutrihist.nutrimorning).arg(nutrihist.nutriafternoon).arg(nutrihist.nutrievening)
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                        font.weight: Font.Bold
                    }

                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("Total Kcalories %1").arg(nutrihist.nutritotal)
                        width: parent.width
                    }
                }
            }


            // Sleep
            Kirigami.Card {
                banner {
                    iconSource: Qt.resolvedUrl("../images/sleep-icon.svg")
                    title: qsTr("Sleep")
                }
                actions: [
                    Kirigami.Action {
                        icon.name: "view-visible"
                        text: qsTr("View Chart")
                        onTriggered: pageStack.push(Qt.resolvedUrl("PageSleepChart.qml"))
                    },
                    Kirigami.Action {
                        icon.name: "document-edit"
                        onTriggered: pageStack.push(Qt.resolvedUrl("PageSleep.qml"))
                        text: qsTr("Add Sleep info")
                    }
                ]
                contentItem: Column {
                    id: sleephist
                    readonly property var sleepinfo: ghlifestyle.sleep
                    readonly property var sleepdate: sleepinfo[0]
                    readonly property var sleephours: sleepinfo[1]
                    readonly property var sleepquality: sleepinfo[2]

                    Label {
                        id: sleepDate
                        horizontalAlignment: Text.AlignHCenter
                        text: sleephist.sleepdate
                        width: parent.width
                    }

                    Label {
                        text: qsTr("Sleep hours %1").arg(sleephist.sleephours)
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                        font.weight: Font.Bold
                    }

                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("Quality: %1").arg(sleephist.sleepquality)
                        width: parent.width
                    }
                }
            }

            
            
            
            
        }
    }
}
