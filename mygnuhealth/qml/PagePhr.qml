import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3


Kirigami.ScrollablePage {
    id: phrpage
    ColumnLayout {
        spacing: Kirigami.Units.gridUnit

        ItemDelegate {
            onClicked: pageStack.push(Qt.resolvedUrl("PageBio.qml"))
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.preferredHeight: 100

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
            onClicked: pageStack.push(Qt.resolvedUrl("PageBol.qml"))
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.preferredHeight: 100

            background: Rectangle {
                color: "#108498"
                radius: Kirigami.Units.largeSpacing

                Image {
                    id: psychoIcon
                    anchors.fill: parent
                    source: "../images/book_of_life-icon.svg"
                    fillMode: Image.PreserveAspectFit
                }
            }
        }

        ItemDelegate {
            //onClicked: pageStack.push(Qt.resolvedUrl("PageDocuments.qml"))
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.preferredHeight: 100

            background: Rectangle {
                color: "#108498"
                radius: Kirigami.Units.largeSpacing

                Image {
                    id: documentsIcon
                    anchors.fill: parent
                    source: "../images/documents-icon.svg"
                    fillMode:Image.PreserveAspectFit
                }
            }
        }

        ItemDelegate {
            //onClicked: pageStack.push(Qt.resolvedUrl("SocialPsycho.qml"))
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.preferredHeight: 100

            background: Rectangle {
                color: "#108498"
                radius: Kirigami.Units.largeSpacing
                Image {
                    id: emergencyIcon
                    anchors.fill: parent
                    source: "../images/emergency-icon.svg"
                    fillMode:Image.PreserveAspectFit
                }
            }
        }

    }
}
