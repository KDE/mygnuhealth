import QtQuick 2.7
import org.kde.kirigami 2.10 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import LocalAccountManager 0.1


Kirigami.ScrollablePage {
    id: loginPage
    title: qsTr("Welcome!")
    header: Control {
        padding: Kirigami.Units.smallSpacing
        contentItem: Kirigami.InlineMessage {
            id: errorMessage
            visible: false
            text: accountManager.msg
            type: Kirigami.MessageType.Error
            showCloseButton: true
        }
    }

    LocalAccountManager { // Object registered at mygh.py to be used here
        id: accountManager
        property var errors: {
            "wrongdate": qsTr("Wrong date"),
            "wronglogin": qsTr("Invalid credentials")
        }
        property var msg: ""
        
        onLoginSuccess: {
            pageStack.replace(Qt.resolvedUrl("PagePhr.qml"));
            // enable the global drawer menu items
            isLoggedIn = true;
        }

        onWrongDate: {
            msg = errors["wrongdate"]
            errorMessage.visible = true;
        }

        onInvalidCredentials: {
            msg = errors["wronglogin"]
            errorMessage.visible = true;
        }

    }

    // Load the component based on the initialization status
    // If the user has been created, then go directly to the login
    // otherwise, load the initialization component

    Loader { sourceComponent:
        accountManager.accountExist ? componentlogin : componentinit
    }


    Item {
        width:loginPage.width
        id:profileinit
        property var datenow: accountManager.todayDate
        Component {
            // Initialization Component to show on the first startup.
            id:componentinit
            ColumnLayout {
                spacing: 10
                anchors.fill: parent
                Image {
                    source: "../images/gnu_health-logo.svg"
                    fillMode: Image.PreserveAspectFit
                    Layout.preferredHeight: 110
                    Layout.alignment: Qt.AlignHCenter || Qt.AlignTop
                    }

                Kirigami.Separator {
                    Kirigami.FormData.isSection: true
                }

                Text {
                    id: introtext
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: profileinit.width
                    horizontalAlignment: Text.AlignJustify
                    wrapMode: Text.WordWrap
                    text: qsTr("To get the best results out of MyGNUHealth, "
                        + "let's start with some information about yourself. "
                        + "In this page, you will register your sex, birthdate and height.\n"
                        + "You will also set your personal private key that will give "
                        + "you access to the application.")
                    }

                Kirigami.Separator {
                    Kirigami.FormData.isSection: true
                }
                TextField {
                    id:username
                    Layout.preferredWidth: introtext.width
                    placeholderText: qsTr("Enter your name")
                    horizontalAlignment: TextInput.Center
                    focus: true
                }

                Kirigami.Separator {
                    Kirigami.FormData.isSection: true
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    
                    Label {
                        text: qsTr("Sex")
                    }

                    ComboBox {
                        id: sex
                        model: ["Female", "Male"]
                        currentIndex: -1
                    }
                    Label {
                        text: qsTr("Height")
                    }
                    SpinBox {
                        id: heightspin
                        from: 100
                        to: 230
                        stepSize: 1
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter

                    Label {
                        id:labelbirth
                        text: qsTr("Birthdate")
                    }

                    Item {
                        id:rectdate
                        width: 200
                        height: 50

                        SpinBox {
                            id: calday
                            anchors.verticalCenter: rectdate.verticalCenter
                            value: profileinit.datenow[0]
                            from: 1
                            to: 31
                            stepSize: 1
                        }

                        SpinBox {
                            id: calmonth
                            from: 1
                            to: 12
                            anchors.left: calday.right
                            anchors.verticalCenter: rectdate.verticalCenter
                            value: profileinit.datenow[1]
                            stepSize: 1
                        }

                        SpinBox {
                            id: calyear
                            anchors.left: calmonth.right
                            anchors.verticalCenter: rectdate.verticalCenter
                            from: 1910
                            to: profileinit.datenow[2]
                            value: profileinit.datenow[2]
                            stepSize: 1
                            editable: false
                        }
                    }

                }

                Kirigami.Separator {
                    Kirigami.FormData.isSection: true
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    Kirigami.PasswordField {
                        id: initKey1
                        placeholderText: qsTr("Personal Key")
                        onAccepted: initKey2.forceActiveFocus()
                    }
                    Kirigami.PasswordField {
                        id: initKey2
                        placeholderText: qsTr("Repeat")
                        onAccepted: buttonInit.forceActiveFocus()
                    }
                    Button {
                        // Show the "set key" button when:
                        //  * the two keys are equal
                        //  * length of the password > 3
                        //  * heigth > 1m
                        //  * The sex is set
                        id: buttonInit
                        enabled: (initKey1.text.length > 3 && (initKey1.text === initKey2.text)) 
                            && heightspin.value > 100 && sex.currentIndex > -1
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("Initialize")
                        property var birthdate: [calyear.value, calmonth.value, calday.value]
                        onClicked: accountManager.createAccount(initKey1.text.trim(), heightspin.value, username.text, birthdate)
                    }
                }

            }

        }
    }
    // Login page .
    Item {
        id: loginitem

        Component {
            id: componentlogin
            ColumnLayout {
                id: login
                width: loginPage.width
                spacing: 15
                Item {
                    width: 150
                    height: 150
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: loginPage.height / 6
                    Image {
                        id: gnuhealthIcon
                        width: 150
                        height: 150
                        source: "../images/gnu_health-logo.svg"
                        fillMode: Image.PreserveAspectFit
                    }
                }
                Text {
                    id:labelgreetings
                    Layout.alignment: Qt.AlignHCenter
                    property var person: accountManager.person
                    text: qsTr("Welcome back, %1").arg(person)
                    font.pixelSize: 20
                }
                Kirigami.PasswordField {
                    id: txtKey
                    Layout.alignment: Qt.AlignHCenter
                    focus: true
                    horizontalAlignment: TextInput.AlignHCenter
                    onAccepted: accountManager.login(txtKey.text.trim())
                }
                Button {
                    id: buttonKey
                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("Enter")
                    enabled: txtKey.text.trim().length
                    onClicked: accountManager.login(txtKey.text.trim())
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
