import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import NetworkSettings 0.1


Kirigami.Page
{
id: phrpage
title: qsTr("Network Settings")
    NetworkSettings { // Settings object registered at main.py
        id: network_settings
        onSetOK: {
            pageStack.layers.pop() // Return to main PHR page
        }
    }

    Kirigami.FormLayout {
        id: content
        anchors.fill: parent

        TextField {
            id: txtFederationProtocol
            placeholderText: qsTr("https")
            text: qsTr("https")
            horizontalAlignment: TextInput.AlignHCenter
            Kirigami.FormData.label: qsTr("Protocol")
         }

        TextField {
            id: txtFederationServer
            placeholderText: qsTr("federation.gnuhealth.org")
            text: qsTr("federation.gnuhealth.org")
            horizontalAlignment: TextInput.AlignHCenter
            Kirigami.FormData.label: qsTr("Host")
         }

        TextField {
            id: txtFederationPort
            placeholderText: qsTr("8443")
            text: qsTr("8443")
            horizontalAlignment: TextInput.AlignHCenter
            Kirigami.FormData.label: qsTr("Port")
         }

        TextField {
           id: txtFederationAccount
            placeholderText: qsTr("Federation ID")
            horizontalAlignment: TextInput.AlignHCenter
            Kirigami.FormData.label: qsTr("Fed. Acct")
        }

        TextField {
           id: txtFederationAccountPassword
            placeholderText: qsTr("Password")
            horizontalAlignment: TextInput.AlignHCenter
            echoMode: TextInput.Password
            Kirigami.FormData.label: qsTr("Password")
        }

        CheckBox {
            id: enable_sync
            checked: false
            Kirigami.FormData.label: qsTr("Sync")
        }

        Button {
            id: buttonCheckSettings
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Test Connection")
            flat: false
            onClicked: {
                network_settings.test_connection(txtFederationProtocol.text,
                                                 txtFederationServer.text,
                                                 txtFederationPort.text,
                                                 txtFederationAccount.text,
                                                 txtFederationAccountPassword.text
                                                 );
            }

        }


        Button {
            id: buttonSetSettings
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Done")
            flat: false
            onClicked: {
                network_settings.getvals(txtFederationProtocol.text,
                    txtFederationServer.text,
                    txtFederationPort.text,
                    txtFederationAccount.text,
                    enable_sync);
            }

        }
    }

}
