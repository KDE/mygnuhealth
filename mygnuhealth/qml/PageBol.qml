import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.5 as Kirigami
import GHBol 0.1


Kirigami.Page {
    id: bolpage
    title: qsTr("My Book of Life")

    GHBol {
        // GHBol object registered at mygh.py
        id: ghbol
    }

    header: RowLayout {
        id:poldomains
        height: Kirigami.Units.gridUnit * 3
        width: bolpage.width
        spacing: Kirigami.Units.smallSpcing

        ItemDelegate {
            id: addpageoflife
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: pageStack.push(Qt.resolvedUrl("PageofLife.qml"))
            Image {
                anchors.fill: parent
                source: "../images/new_page_of_life-icon.svg"
                fillMode: Image.PreserveAspectFit
            }
        }
        TextField {
            id: fedkey
            enabled: ghbol.sync_status
            placeholderText: qsTr("Enter Federation key to sync")
            horizontalAlignment: TextInput.AlignHCenter
            echoMode: TextInput.Password
            onAccepted: ghbol.sync_book(fedkey.text)
        }
    }

    ScrollView {
        id: bolscroll
        contentHeight: parent.height * 0.9
        contentWidth: parent.width

        ListView {
            id: bolview
            anchors.fill: parent
            anchors.margins: 5
            clip: true
            model: ghbol.book
            delegate: bookDelegate
            spacing: 3
        }

        Component {
            id: bookDelegate

            RowLayout {
                spacing: 5
                Layout.fillWidth: true
                Column{
                    width: bolscroll.width * 0.25
                    Layout.fillWidth: true

                    Text {
                        text: ghbol.book[index].date
                        color: "steelblue"
                    }
                }
                Column{
                    width: bolscroll.width * 0.25
                    Layout.fillWidth: true
                    Text {
                        text: ghbol.book[index].domain
                    }
                }
                Column {
                    width: bolscroll.width * 0.75
                    Text {
                        text: ghbol.book[index].summary
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
    }
}
