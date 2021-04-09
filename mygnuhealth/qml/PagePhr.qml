import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3


Kirigami.ScrollablePage {
    id: phrpage
    title: qsTr("Home")

    ColumnLayout {
        spacing: Kirigami.Units.gridUnit * 3
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignVCenter


        ItemDelegate {
            onClicked: pageStack.push(Qt.resolvedUrl("PageTracker.qml"))
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: Kirigami.Units.gridUnit * 9
            Image {
                id: trackerIcon
                anchors.fill: parent
                source: "../images/health_tracker-button.svg"
                fillMode: Image.PreserveAspectFit
            }
            Label {
                text: qsTr("Health Tracker")
                font.pixelSize: 22
                color: "#60b6c2"
                anchors.horizontalCenter: trackerIcon.horizontalCenter
                anchors.top: trackerIcon.bottom
            }
        }

        ItemDelegate {
            onClicked: pageStack.push(Qt.resolvedUrl("PageBol.qml"))
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: Kirigami.Units.gridUnit * 9
            Layout.preferredWidth: Kirigami.Units.gridUnit * 9


            Image {
                id: bolIcon
                anchors.fill: parent
                source: "../images/book_of_life-button.svg"
                fillMode: Image.PreserveAspectFit
            }

           Label {
                text: qsTr("Book of Life")
                font.pixelSize: 22
                color: "#60b6c2"
                anchors.horizontalCenter: bolIcon.horizontalCenter
                anchors.top: bolIcon.bottom
            }
 
        }
    }
   footer: Rectangle{
            id: rectfooter
            width: 160
            height: 40
            Image {
                id: myghIcon
                anchors.centerIn: rectfooter
                source: "../images/myGH-horizontal-icon.svg"
                width: 160
                fillMode: Image.PreserveAspectFit
            }
        }
}
