import QtQuick 2.7
import org.kde.kirigami 2.10 as Kirigami
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import org.kde.mygnuhealth 1.0


Kirigami.ScrollablePage {
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
        visible: accountManager.accountExist

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
                id: buttonInit
                enabled: initKey1.text.length > 0 && (initKey1.text === initKey2.text)
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Set Key")
                onClicked: accountManager.createAccount(initKey1.text.trim())
            }
        }
    }

    ColumnLayout {
        id: content
        visible: !accountManager.accountExist
        Image {
            id: padlockicon
            Layout.alignment: Qt.AlignHCenter
            source: "../images/padlock-icon.svg"
        }

        Kirigami.FormLayout {
            Kirigami.PasswordField {
                id: txtKey
                Kirigami.FormData.label: qsTr("Key")
                focus: true
                onAccepted: accountManager.login(txtKey.text.trim())
            }

            Button {
                id: buttonKey
                text: qsTr("Enter")
                enabled: txtKey.trim().length
                onClicked: accountManager.login(txtKey.text.trim())
            }
        }
    }
}
