import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.5 as Kirigami
import GHLifestyle 0.1

Kirigami.ScrollablePage
{
    id: biopage
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
        }
    }
}
