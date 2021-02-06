import QtQuick 2.7
import org.kde.kirigami 2.10 as Kirigami
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import LocalAccountManager 0.1


Kirigami.Page {
    id: loginPage
    title: qsTr("Welcome!")
    Kirigami.Theme.backgroundColor: "white"

    LocalAccountManager { // FedLogin object registered at mygh.py to be used here
        id: accountManager
        property var errors: {
            "wrongdate": "Wrong date",
            "wronglogin": "Invalid credentials"
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



    GridLayout {
        id: profileinit
        columns: 5
        rowSpacing: 10
        visible: accountManager.accountExist === false
        property var datenow: accountManager.todayDate
        
        // Initialization Page (Grid) to show on the first startup.
        Image {
            Layout.row: 1
            Layout.column: 1
            source: "../images/mygnuhealthicon.svg"
            Layout.maximumWidth: 150
            Layout.maximumHeight: 150
            Layout.columnSpan: 4
            fillMode: Image.PreserveAspectFit
            Layout.alignment: Qt.AlignHCenter
            visible: accountManager.accountExist === false
        }
        Text {
            Layout.row: 2
            Layout.column: 1
            Layout.columnSpan: 4
            Layout.maximumWidth: 350
            horizontalAlignment: Text.AlignJustify
            text: qsTr("Welcome! To get the best results out of MyGNUHealth, let's start with some information about yourself.\nIn this screen, you will register your sex, birthdate and height.\nYou will also set your personal private key that will give you access to the application.")
            wrapMode: Text.WordWrap
        }

        TextField {
            id:username
            Layout.row: 3
            Layout.column: 2
            Layout.alignment: Qt.AlignHCenter
            placeholderText: qsTr("Your Name")
            focus: accountManager.accountExist === false
        }
        
        Label {
            Layout.row: 4
            Layout.column: 1
            text: qsTr("Sex")
        }

        ComboBox {
            id: sex
            Layout.row: 4
            Layout.column: 2
            model: ["Female", "Male"]
            currentIndex: -1
        }
        Label {
            Layout.row: 4
            Layout.column: 3
            text: qsTr("Height")
        }
        SpinBox {
            id: heightspin
            Layout.row: 4
            Layout.column: 4
            from: 100
            to: 230
            stepSize: 1
        }

        Label {
            id:labelbirth
            Layout.row: 5
            Layout.column: 1
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Birthdate")
        }

        Rectangle {
            id:rectdate
            Layout.row: 5
            Layout.column: 2
            Layout.alignment: Qt.AlignHCenter
            Layout.columnSpan: 4

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
            }
        }
        
        Rectangle{
            id: rectkey
            Layout.row: 6
            Layout.column: 1
            Layout.columnSpan: 4
            Layout.alignment: Qt.AlignHCenter

            width: 250
            height: 70

            Kirigami.PasswordField {
                id: initKey1
                anchors.horizontalCenter: rectkey.horizontalCenter
                anchors.top: rectkey.top
                placeholderText: qsTr("Personal Key")
                onAccepted: initKey2.forceActiveFocus()
            }
            Kirigami.PasswordField {
                id: initKey2
                anchors.bottom: rectkey.bottom
                anchors.horizontalCenter: initKey1.horizontalCenter
                placeholderText: qsTr("Repeat")
                onAccepted: buttonInit.forceActiveFocus()
            }
            Image {
                id:lockimg
                anchors.centerIn: rectkey
                fillMode: Image.PreserveAspectFit
                source: "../images/lock-icon.svg"
                }

        }
    
        Button {
            // Show the "set key" button when:
            //  * the two keys are equal
            //  * length of the password > 3
            //  * heigth > 1m
            //  * The sex is set
            id: buttonInit
            enabled: (initKey1.text.length > 3 && (initKey1.text === initKey2.text)) && heightspin.value > 100 && sex.currentIndex > -1
            Layout.alignment: Qt.AlignHCenter
            Layout.row: 8
            Layout.column: 1
            Layout.columnSpan: 4
            text: qsTr("Initialize")
            property var birthdate: [calyear.value, calmonth.value, calday.value]
            onClicked: accountManager.createAccount(initKey1.text.trim(), heightspin.value, username.text, birthdate)
        }

    }
        
    
    // Login page .
    ColumnLayout {
        id: greetter
        visible: accountManager.accountExist === true
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        Label {
            id:labelgreetings
            anchors.top: parent.top
            property var person: accountManager.person
            text: qsTr("Welcome back, " + person + "!")
            font.pixelSize: 20
        }
    }

    ColumnLayout {
        id: login
        visible: accountManager.accountExist === true
        anchors.centerIn: parent
        
        Image {
            id: padlockicon
            Layout.alignment: Qt.AlignVCenter
            source: "../images/padlock-icon.svg"
        }

        Kirigami.FormLayout {
            Kirigami.PasswordField {
                id: txtKey
                focus: true
                onAccepted: accountManager.login(txtKey.text.trim())
            }
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
