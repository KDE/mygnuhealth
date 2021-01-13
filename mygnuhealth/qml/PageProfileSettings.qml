import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import ProfileSettings 0.1

Kirigami.Page {
    id: phrpage
    title: qsTr("MyGNUHealth Profile Settings")

    ProfileSettings { // ProfileSettings object registered at mygh.py
        id: profile_settings
        onSetOK: {
            pageStack.layers.pop() // Return to main PHR page
        }
    }

    Kirigami.FormLayout {
        id: content
        anchors.fill: parent

        RowLayout {
            Label {
                text: "Height"
            }
            SpinBox {
                property var ht: profile_settings.height
                id: heightspin
                from: 40
                value: ht
                to: 230
                stepSize: 1
            }
            Button {
                id: profilebutton
                Layout.alignment: Qt.AlignHCenter

                text: qsTr("Update")
                onClicked: {
                    profile_settings.get_profile(heightspin.value);
                }

            }
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
        }
        RowLayout {
            Label {
                text: "Fed Acct"
            }
            TextField {
                id: userFedacct
                property var fedacct: profile_settings.fedacct
                Layout.alignment: Qt.AlignHCenter
                placeholderText: qsTr("Fed Acct")
                text: fedacct
                horizontalAlignment: TextInput.AlignHCenter
            }
            Button {
                id: fedAcctsetbutton
                Layout.alignment: Qt.AlignHCenter

                text: qsTr("Set")
                onClicked: {
                    profile_settings.get_fedacct(userFedacct.text);
                }
            }
        }
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
        }

        TextField {
            id: userPassword
            Layout.alignment: Qt.AlignHCenter
            placeholderText: qsTr("Current Key")
            horizontalAlignment: TextInput.AlignHCenter
            echoMode: TextInput.Password
            Kirigami.FormData.label: qsTr("Personal key")
        }

        RowLayout {
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
        }
        Button {
            id: buttonSetSettings
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Update")
            flat: false
            onClicked: {
                profile_settings.get_personalkey(userPassword.text,newPassword1.text,
                                        newPassword2.text);
            }
        }
    }
}
