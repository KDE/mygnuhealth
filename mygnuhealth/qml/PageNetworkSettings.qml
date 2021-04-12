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
            placeholderText: "https"
            text: network_settings.conn.protocol
            horizontalAlignment: TextInput.AlignHCenter
            Kirigami.FormData.label: qsTr("Protocol")
         }

        TextField {
            id: txtFederationServer
            placeholderText: "federation.gnuhealth.org"
            text: network_settings.conn.federation_server
            horizontalAlignment: TextInput.AlignHCenter
            Kirigami.FormData.label: qsTr("Host")
         }

        TextField {
            id: txtFederationPort
            placeholderText: "8443"
            text: network_settings.conn.federation_port
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
            checked: network_settings.conn.enable_sync
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
            text: qsTr("Update")
            flat: false
            onClicked: {
                network_settings.getvals(txtFederationProtocol.text,
                    txtFederationServer.text,
                    txtFederationPort.text,
                    enable_sync.checked);
            }

        }
    }

}
