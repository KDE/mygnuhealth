import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.5 as Kirigami
import Qt.labs.qmlmodels 1.0
import GHBol 0.1


Kirigami.ScrollablePage {
    id: bolpage
    title: qsTr("My Book of Life")

    TableView {
        id: bolview
        columnSpacing: 1
        rowSpacing: 1
        boundsBehavior: Flickable.StopAtBounds

        GHBol {
            // GHBol object registered at mygh.py
            id: ghbol
        }

        header: RowLayout {
            id:poldomains
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.preferredHeight: Kirigami.Units.gridUnit * 4
            Rectangle {
                id:rectbio
                Layout.fillHeight: true
                Layout.preferredWidth: 85
                Image {
                    id:bioIcon
                    Layout.preferredWidth: 85
                    anchors.fill: parent
                    source: "../images/medical-square-icon.svg"
                }
            }

            Rectangle {
                id:rectpsycho
                Layout.fillHeight: true
                Layout.preferredWidth: 85
                Image {
                    id: psychoIcon
                    source: "../images/psycho-square-icon.svg"
                    Layout.preferredWidth: 85
                    anchors.fill: parent
                    fillMode:Image.PreserveAspectFit
                }
            }

            Rectangle {
                id:rectsocial
                Layout.fillHeight: true
                Layout.preferredWidth: 85
                Image {
                    id: socialIcon
                    source: "../images/social-square-icon.svg"
                    anchors.fill: parent
                }
            }

            Rectangle {
                id:rectday
                Layout.fillHeight: true
                Layout.preferredWidth: 85
                Image {
                    id: dayIcon
                    source: "../images/activity-square-icon.svg"
                    fillMode:Image.PreserveAspectFit
                    anchors.fill: parent
                }
            }
        }

        model: TableModel {
            TableModelColumn { display: "date" }
            TableModelColumn { display: "domain" }
            TableModelColumn { display: "summary" }

            // Add rows as per each page of life
            rows: ghbol.book
        }

        delegate: Rectangle {
            implicitWidth: 160
            implicitHeight: 40
            Label {
                text: model.display
            }
        }
    }
}
