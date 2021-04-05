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
           pageStack.pop() // Return to Book of Life
        }

    }

    ColumnLayout {
        
        // Date and Time widget
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

        // Title of the Page of Life (summary)
        RowLayout {
            id: titleform
            Layout.fillWidth: true
            Label {
                id:pagetitle
                text: qsTr("Title")
            }
            TextField {
                id:summary
                placeholderText: qsTr("Summary")
                focus: true
            }
        }


        // Health domain and context
        RowLayout {
            id: domainrow
            // Layout.fillWidth: true
        
            ComboBox {
                id: domainid
                model: pol.poldomain
                textRole: "text"
                valueRole: "value"
                onActivated: pol.update_context(domainid.currentValue)
            }
            ComboBox {
                id: contextid
                model: pol.polcontext
                textRole: "text"
                valueRole: "value"
            }
        }
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
        }
        
        // Item reserved for genetic infomation
        // It will be shown only when the medical domain context is Genetics 
        ColumnLayout {
            visible: contextid.currentValue === 'genetics'
            GridLayout {
                columns: 3
                TextField {
                    id:rsid
                    Layout.preferredWidth: parent.width*0.2
                    placeholderText: qsTr("RefSNP")
                    horizontalAlignment: TextInput.Center
                    onEditingFinished:pol.checkSNP(rsid.text)
                }
                TextField {
                    id:geneid
                    Layout.preferredWidth: parent.width*0.2
                    placeholderText: qsTr("Gene")
                    horizontalAlignment: TextInput.Center
                }
                TextField {
                    id:aachange
                    placeholderText: qsTr("AA change")
                    horizontalAlignment: TextInput.Center
                }
                TextField {
                    id:variantid
                    Layout.preferredWidth: parent.width*0.2
                    placeholderText: qsTr("Variant")
                    horizontalAlignment: TextInput.Center
                }
                TextField {
                    id:proteinid
                    Layout.preferredWidth: parent.width*0.2
                    placeholderText: qsTr("Protein ID")
                    horizontalAlignment: TextInput.Center
                }
                TextField {
                    id:significance
                    placeholderText: qsTr("Significance")
                    horizontalAlignment: TextInput.Center
                }
                TextField {
                    id:disease
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    placeholderText: qsTr("Disease")
                    horizontalAlignment: TextInput.Center
                }
            }
        }
        TextArea {
            id:information
            Layout.fillWidth: true
            placeholderText: qsTr("Enter details here")
            wrapMode: TextEdit.WordWrap
        }
        
        Button {
            id: buttonKey
            property var page_date: [calyear.value, calmonth.value, calday.value, calhour.value, calminute.value]
            property var genetic_info: [rsid.text, geneid.text, aachange.text,  variantid.text, proteinid.text, significance.text, disease.text]
            onClicked: pol.createPage(page_date, domainid.currentValue, contextid.currentValue, genetic_info, summary.text, information.text)
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Create")
        }
    }

}
