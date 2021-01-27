import QtQuick 2.7
import org.kde.kirigami 2.10 as Kirigami
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import LocalAccountManager 0.1


Kirigami.Page {
    id: loginPage
    title: qsTr("Login")

    header: Control {
        padding: Kirigami.Units.smallSpacing
        contentItem: Kirigami.InlineMessage {
            id: errorMessage
            visible: false
            text: accountManager.accountExist ? qsTr("An error occured during the creation of the account")
                                              : qsTr("An error occured during login")
            type: Kirigami.MessageType.Error
            showCloseButton: true
        }
    }

   LocalAccountManager { // FedLogin object registered at main.py to be used here
        id: accountManager
        onLoginSuccess: {
            pageStack.replace(Qt.resolvedUrl("PagePhr.qml"));
            // enable the global drawer menu items
            isLoggedIn = true;
        }
        onErrorOccurred: errorMessage.visible = true
    }

    ColumnLayout {
        id: pwdinit
        anchors.centerIn: parent
        visible: accountManager.accountExist === false
        Item {
            Kirigami.FormData.label: qsTr("Welcome! Please initialize for personal Key")
            Kirigami.FormData.isSection: true
        }

        Image {
            id: lockicon
            Layout.alignment: Qt.AlignHCenter
            source: "../images/padlock-icon.svg"
        }

        Kirigami.FormLayout {
            Kirigami.PasswordField {
                id: initKey1
                Kirigami.FormData.label: qsTr("Key")
                onAccepted: initKey2.forceActiveFocus()
                focus: true
            }
            Kirigami.PasswordField {
                id: initKey2
                Kirigami.FormData.label: qsTr("Confrm Key")
                onAccepted: buttonInit.forceActiveFocus()
            }
            Button {
                // Show the "set key" button when the two keys are equal
                // and length of the password > 3
                id: buttonInit
                enabled: initKey1.text.length > 3 && (initKey1.text === initKey2.text)
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Set Key")
                onClicked: accountManager.createAccount(initKey1.text.trim())
            }
        }
    }

    ColumnLayout {
        id: login
        anchors.centerIn: parent
        visible: accountManager.accountExist === true

        Image {
            id: padlockicon
            Layout.alignment: Qt.AlignHCenter
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
