import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import FedLogin 0.1

Kirigami.Page
{
id: loginPage
title: qsTr("Login")

    FedLogin { // FedLogin object registered at main.py to be used here
        id: fedlogin

        onLoginOK: {
            pageStack.push(Qt.resolvedUrl("PagePhr.qml"))
        }
    }

    Item {
        id: logininfo
        property var accountinfo: ({"account":'',"password":''})
    }

    Kirigami.FormLayout {
        id: content
        anchors.fill: parent

        TextField {
            id: txtFedacct
            placeholderText: qsTr("GH Federation Account")
            Kirigami.FormData.label: qsTr("Acct")
        }

        TextField {
            id: txtPassword
            placeholderText: qsTr("Password")
            Kirigami.FormData.label: qsTr("Password")
            echoMode: TextInput.Password
            onAccepted: {
                logininfo.accountinfo.account = txtFedacct.text
                logininfo.accountinfo.password = txtPassword.text

                fedlogin.getCredentials(logininfo.accountinfo.account,
                    logininfo.accountinfo.password);
            }
        }

        Button {
            text: qsTr("Login")
            flat: false
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                logininfo.accountinfo.account = txtFedacct.text
                logininfo.accountinfo.password = txtPassword.text

                fedlogin.getCredentials(logininfo.accountinfo.account,
                    logininfo.accountinfo.password);
            }
        }
    }

}
