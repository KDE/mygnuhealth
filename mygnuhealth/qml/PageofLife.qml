import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.5 as Kirigami
import PoL 0.1

Kirigami.Page {
    id: pageoflife
    title: qsTr("New Page of Life")

    header: Control {
        padding: Kirigami.Units.smallSpacing
        contentItem: Kirigami.InlineMessage {
            id: errorMessage
            visible: false
            text: pol.msg
            type: Kirigami.MessageType.Error
            showCloseButton: true
        }
    }

    PoL { // Object registered at mygh.py to be used here
        id: pol
        property var errors: {
            "wrongdate": qsTr("Wrong date"),
            "successcreate": qsTr("OK!"),
        }
        property var msg: ""
        
        onWrongDate: {
            msg = errors["wrongdate"]
            errorMessage.visible = true;
        }

        onCreateSuccess: {
            msg = errors["successcreate"]
            errorMessage.visible = true;
        }

    }

    ColumnLayout {
        
        RowLayout {

            Label {
                id:pagedate
                text: qsTr("Date")
            }

            Item {
                id:dateitem
                width: 300
                height: 50
                property var datenow: pol.todayDate

                SpinBox {
                    id: calday
                    anchors.verticalCenter: dateitem.verticalCenter
                    value: dateitem.datenow[0]
                    from: 1
                    to: 31
                    stepSize: 1
                }

                SpinBox {
                    id: calmonth
                    from: 1
                    to: 12
                    anchors.left: calday.right
                    anchors.verticalCenter: dateitem.verticalCenter
                    value: dateitem.datenow[1]
                    stepSize: 1
                }

                SpinBox {
                    id: calyear
                    anchors.left: calmonth.right
                    anchors.verticalCenter: dateitem.verticalCenter
                    from: 1910
                    to: dateitem.datenow[2]
                    value: dateitem.datenow[2]
                    stepSize: 1
                }
                Label {
                    id:pagetime
                    anchors.left: calyear.right
                    anchors.verticalCenter: calyear.verticalCenter
                    text: qsTr("Time")
                }


                SpinBox {
                    id: calhour
                    from: 0
                    to: 23
                    anchors.left: pagetime.right
                    anchors.verticalCenter: dateitem.verticalCenter
                    value: dateitem.datenow[3]
                    stepSize: 1
                }
                SpinBox {
                    id: calminute
                    from: 0
                    to: 59
                    anchors.left: calhour.right
                    anchors.verticalCenter: dateitem.verticalCenter
                    value: dateitem.datenow[4]
                    stepSize: 1
                }
                
            }

        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
        }

        ComboBox {
            id: domainid
            width: 200
            model: pol.poldomain
            textRole: "text"
            valueRole: "value"
        }
        
        Button {
            id: buttonKey
            property var page_date: [calyear.value, calmonth.value, calday.value, calhour.value, calminute.value]
            onClicked: pol.createPage(page_date, domainid.currentValue)
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Create")
        }
    }

}
