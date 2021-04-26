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
        anchors.margins: 10
        Rectangle {
            color: "transparent"
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 300
            Layout.preferredHeight: 50
            Image {
                id: newpolicon
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height * 0.9
                fillMode: Image.PreserveAspectFit
                source: "../images/new_page_of_life-icon.svg"
                MouseArea {
                    anchors.fill: parent
                    onClicked: pageStack.push(Qt.resolvedUrl("PageofLife.qml"))
                }
            }

            TextField {
                id: fedkey
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                enabled: ghbol.sync_status
                placeholderText: qsTr("Enter Federation key to sync")
                horizontalAlignment: TextInput.AlignHCenter
                echoMode: TextInput.Password
                onAccepted: ghbol.sync_book(fedkey.text)
            }
        }
    }

    ScrollView {
        id: bolscroll
        contentHeight: parent.height
        contentWidth: parent.width
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        ListView {
            id: bolview
            spacing: 6
            clip: true
            model: ghbol.book
            delegate: bookDelegate
        }

        Component {
            id: bookDelegate

            ColumnLayout {
                Rectangle {
                    Layout.preferredWidth: bolpage.width
                    Layout.preferredHeight: 1
                    color: "#b9dadf"
                }

                RowLayout {
                    id: pageoflifeRow
                    Layout.preferredWidth: bolpage.width * 0.2
                    Rectangle {
                        Layout.preferredWidth: 120
                        Layout.preferredHeight: pageDescription.height
                        color: "transparent"
                        Text {
                            // Date of the page of life
                            text: ghbol.book[index].date
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#60b6c2"
                            font.pointSize: 10
                            font.bold: true
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: bolpage.width * 0.8
                        Layout.preferredHeight: pageDescription.height
                        Layout.minimumHeight: 75
                        color: "#d9e7ea"
                        Text {
                            id: pageDescription
                            color: "#108599"
                            leftPadding: 10
                            topPadding: 10
                            textFormat: TextEdit.RichText
                            property var header: "<b>%1</b><br/>".arg(ghbol.book[index].domain)
                            width: 200
                            text: header + ghbol.book[index].summary
                            wrapMode: Text.WordWrap
                        }
                    }
                }
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
