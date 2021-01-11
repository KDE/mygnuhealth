import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.5 as Kirigami
import Qt.labs.qmlmodels 1.0
import GHBol 0.1


Kirigami.ScrollablePage {
    id: bolpage
    title: qsTr("My Book of Life")

    header: RowLayout {
        id:poldomains
        height: Kirigami.Units.gridUnit * 3
        width: bolpage.width
        spacing: Kirigami.Units.smallSpcing
        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Image {
                anchors.fill: parent
                source: "../images/medical-square-icon.svg"
                fillMode: Image.PreserveAspectFit
            }
        }

        Item {
            id:rectpsycho
            Layout.fillHeight: true
            Layout.fillWidth: true
            Image {
                anchors.fill: parent
                source: "../images/psycho-square-icon.svg"
                fillMode: Image.PreserveAspectFit
            }
        }

        Item {
            id:rectsocial
            Layout.fillHeight: true
            Layout.fillWidth: true
            Image {
                anchors.fill: parent
                source: "../images/social-square-icon.svg"
                fillMode: Image.PreserveAspectFit
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Image {
                anchors.fill: parent
                source: "../images/activity-square-icon.svg"
                fillMode: Image.PreserveAspectFit
            }
        }
    }

    TableView {
        id: bolview
        columnSpacing: 1
        rowSpacing: 1
        boundsBehavior: Flickable.StopAtBounds

        GHBol {
            // GHBol object registered at mygh.py
            id: ghbol
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
