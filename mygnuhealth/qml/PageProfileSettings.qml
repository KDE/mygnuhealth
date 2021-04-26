import QtQuick 2.7
import org.kde.kirigami 2.10 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import ProfileSettings 0.1

Kirigami.Page {
    id: phrpage
    title: qsTr("MyGNUHealth Profile Settings")

    header: Control {
        padding: Kirigami.Units.smallSpacing
        contentItem: Kirigami.InlineMessage {
            id: errorMessage
            visible: false
            text: qsTr("Error on password change")
            type: Kirigami.MessageType.Error
            showCloseButton: true
        }
    }

    ProfileSettings { // ProfileSettings object registered at mygh.py
        id: profile_settings
        onSetOK: pageStack.layers.pop() // Return to main PHR page
        onErrorPassword: errorMessage.visible = true
    }


    ColumnLayout {
        spacing: 20
 
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Image {
                id: profileIcon
                Layout.preferredWidth: 250
                source: "../images/profile-icon.svg"
                fillMode: Image.PreserveAspectFit
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter

            Label {
                text: qsTr("Height (cm)")
            }
            SpinBox {
                id: heightspin
                from: 40
                // Use initial value of 1.60 mts if profile is initialized
                // It won't be saved until the user presses "set"
                value: profile_settings.height ? profile_settings.height:160
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

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Label {
                text: qsTr("Fed Acct")
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

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
               
            TextField {
                id: userPassword
                Layout.alignment: Qt.AlignHCenter
                placeholderText: qsTr("Current Personal Key")
                horizontalAlignment: TextInput.AlignHCenter
                echoMode: TextInput.Password
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter

                TextField {
                    id: newPassword1
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 100
                    placeholderText: qsTr("New key")
                    horizontalAlignment: TextInput.AlignHCenter
                    echoMode: TextInput.Password
                }
                TextField {
                    id: newPassword2
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 100
                    placeholderText: qsTr("Repeat")
                    horizontalAlignment: TextInput.AlignHCenter
                    echoMode: TextInput.Password
                }

            }
            Button {
                id: buttonSetSettings
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Update Key")
                flat: false
                onClicked: {
                    profile_settings.get_personalkey(userPassword.text,newPassword1.text,
                                            newPassword2.text);
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
