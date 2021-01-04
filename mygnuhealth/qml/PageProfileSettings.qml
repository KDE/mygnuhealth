import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import ProfileSettings 0.1

Kirigami.Page {
    id: phrpage
    title: qsTr("MyGNUHealth Profile Settings")

    ProfileSettings { // ProfileSettings object registered at main.py
        id: profile_settings
        onSetOK: {
            pageStack.layers.pop() // Return to main PHR page
        }
    }

    Kirigami.FormLayout {
        id: content
        anchors.fill: parent


        TextField {
            id: userFedacct
            Layout.alignment: Qt.AlignHCenter
            placeholderText: qsTr("Fed Acct")
            horizontalAlignment: TextInput.AlignHCenter
            Kirigami.FormData.label: qsTr("Federation Acct")
        }

        Button {
            id: fedAcctsetbutton
            Layout.alignment: Qt.AlignHCenter

            text: qsTr("Set")
            onClicked: {
                profile_settings.get_fedacct(userFedacct.text);
            }

        }

        TextField {
            id: userPassword
            Layout.alignment: Qt.AlignHCenter
            placeholderText: qsTr("Current Key")
            horizontalAlignment: TextInput.AlignHCenter
            echoMode: TextInput.Password
            Kirigami.FormData.label: qsTr("Current key")
        }

        TextField {
            id: newPassword1
            Layout.alignment: Qt.AlignHCenter
            placeholderText: qsTr("New Password")
            horizontalAlignment: TextInput.AlignHCenter
            echoMode: TextInput.Password
            Kirigami.FormData.label: qsTr("New password")
            focus: true
        }

        TextField {
            id: newPassword2
            Layout.alignment: Qt.AlignHCenter
            placeholderText: qsTr("Repeat")
            horizontalAlignment: TextInput.AlignHCenter
            echoMode: TextInput.Password
            Kirigami.FormData.label: qsTr("Repeat")
            focus: true
        }


        Button {
            id: buttonSetSettings
            Layout.alignment: Qt.AlignHCenter

            text: qsTr("Update")
            flat: false
            onClicked: {
                profile_settings.getvals(userPassword.text,newPassword1.text,
                                         newPassword2.text);
            }

        }

    }

}
