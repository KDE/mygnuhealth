import QtQuick 2.7
import org.kde.kirigami 2.10 as Kirigami
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import GHLogin 0.1


Kirigami.Page {
    id: loginPage
    title: qsTr("Login")

    header: Control {
        padding: Kirigami.Units.smallSpacing
        contentItem: Kirigami.InlineMessage {
            id: errorMessage
            visible: false
            text: qsTr("An error occured during login")
            type: Kirigami.MessageType.Error
            showCloseButton: true
        }
    }

   GHLogin { // FedLogin object registered at main.py to be used here
        id: ghlogin
        onLoginOK: {
            pageStack.replace(Qt.resolvedUrl("PagePhr.qml"))
            // enable the global drawer menu items
            isLoggedIn = true;
        }
        onErrorOccurred: errorMessage.visible = true
    }

    
    ColumnLayout {
        id: pwdinit
        anchors.centerIn: parent
        spacing: 20
        visible: ghlogin.init_key === "unset"

        Kirigami.Label {
            text: "Welcome! Please initialize for personal Key"
        }
        Image {
            id: lockicon
            Layout.alignment: Qt.AlignHCenter
            source: "../images/padlock-icon.svg"
        }

        Kirigami.PasswordField {
            id: initKey1
            Layout.alignment: Qt.AlignHCenter
            placeholderText: qsTr("Key")
            focus: true
        }
        Kirigami.PasswordField {
            id: initKey2
            Layout.alignment: Qt.AlignHCenter
            placeholderText: qsTr("Repeat")
        }
        Button {
            // Show the "set key" button when the two keys are equal
            id: buttonInit
            visible: initKey1.text && (initKey1.text === initKey2.text)
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Set Key")
            flat: false
            onClicked: {
                ghlogin.getInittKey(initKey1.text);
            }
        }
    }

    ColumnLayout {
        id: content
        visible: ghlogin.init_key === "set"
        anchors.centerIn: parent
        spacing: 20
        Image {
            id: padlockicon
            Layout.alignment: Qt.AlignHCenter
            source: "../images/padlock-icon.svg"
        }

        Kirigami.PasswordField {
            id: txtKey
            Layout.alignment: Qt.AlignHCenter
            placeholderText: qsTr("Key")
            focus: true
            onAccepted: {
                ghlogin.getKey(txtKey.text);
                buttonKey.forceActiveFocus()
            }
        }

        Button {
            id: buttonKey
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Enter")
            flat: false
            onClicked: {
                ghlogin.getKey(txtKey.text);
            }
        }
    }
}
