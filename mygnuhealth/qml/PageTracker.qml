import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3


Kirigami.ScrollablePage {
    id: trackerpage
    title: qsTr("Tracker")

    ColumnLayout {
        spacing: Kirigami.Units.gridUnit

        ItemDelegate {
            onClicked: pageStack.push(Qt.resolvedUrl("PageBio.qml"))
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.preferredHeight: Kirigami.Units.gridUnit * 5

            background: Rectangle {
                color: "#108498"
                radius: Kirigami.Units.largeSpacing

                Image {
                    id: bioIcon
                    anchors.fill: parent
                    source: "../images/bio-icon.svg"
                    fillMode: Image.PreserveAspectFit
                }
            }
        }

        ItemDelegate {
            onClicked: pageStack.push(Qt.resolvedUrl("PageLifestyle.qml"))
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.preferredHeight: Kirigami.Units.gridUnit * 5

            background: Rectangle {
                color: "#108498"
                radius: Kirigami.Units.largeSpacing

                Image {
                    id: lifestyleIcon
                    anchors.fill: parent
                    source: "../images/lifestyle-icon.svg"
                    fillMode: Image.PreserveAspectFit
                }
            }
        }

        ItemDelegate {
            onClicked: pageStack.push(Qt.resolvedUrl("PagePsycho.qml"))
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.preferredHeight: Kirigami.Units.gridUnit * 5

            background: Rectangle {
                color: "#108498"
                radius: Kirigami.Units.largeSpacing

                Image {
                    id: pyschoIcon
                    anchors.fill: parent
                    source: "../images/psycho-icon.svg"
                    fillMode: Image.PreserveAspectFit
                }
            }
        }



    }
}
