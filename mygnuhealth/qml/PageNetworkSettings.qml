import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import NetworkSettings 0.1


Kirigami.Page
{
id: phrpage
title: qsTr("Network Settings")
    header: Control {
        padding: Kirigami.Units.smallSpacing
        contentItem: Kirigami.InlineMessage {
            id: statusMessage
            visible: false
            text: network_settings.msg
            // type: Kirigami.MessageType.Error
            showCloseButton: true
        }
    }

    NetworkSettings { // Settings object registered at main.py
        id: network_settings
        property var errors: {
            "conntestok": qsTr("Connection test successful!"),
            "wronglogin": qsTr("Invalid Credentials"),
            "connerror": qsTr("Connection Error")
        }
        property var msg: ""

        onSetOK: {
            pageStack.layers.pop() // Return to main PHR page
        }
        
        onInvalidCredentials: {
            msg = errors["wronglogin"]
            statusMessage.visible = true;
            statusMessage.type = Kirigami.MessageType.Warning
        }

        onConnectionOK: {
            msg = errors["conntestok"]
            statusMessage.visible = true;
            statusMessage.type = Kirigami.MessageType.Positive
        }

        onConnectionError: {
            msg = errors["connerror"]
            statusMessage.visible = true;
            statusMessage.type = Kirigami.MessageType.Error
        }
    }
    
    GridLayout {
        columns: 2
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        Item {
            Layout.columnSpan: 2
            Layout.rowSpan: 1
            Layout.alignment: Qt.AlignHCenter || Qt.AlignTop
            Layout.preferredWidth: 300
            Layout.preferredHeight: 100
            Image {
                id: trackerIcon
                anchors.fill: parent
                source: "../images/network_settings-icon.svg"
                fillMode: Image.PreserveAspectFit
            }
        }
        Label {
            text:  qsTr("Protocol")
        }
        TextField {
            id: txtFederationProtocol
            placeholderText: "https"
            text: network_settings.conn.protocol
            horizontalAlignment: TextInput.AlignHCenter
        }

       Label {
            text:  qsTr("Thalamus server")
        }
        
        TextField {
            id: txtFederationServer
            placeholderText: "federation.gnuhealth.org"
            text: network_settings.conn.federation_server
            horizontalAlignment: TextInput.AlignHCenter
        }

       Label {
            text:  qsTr("Thalamus server port")
        }
        TextField {
            id: txtFederationPort
            placeholderText: "8443"
            text: network_settings.conn.federation_port
            horizontalAlignment: TextInput.AlignHCenter
        }

       Label {
            text:  qsTr("Federation Account")
        }
        TextField {
            id: txtFederationAccount
            placeholderText: qsTr("Federation ID")
            horizontalAlignment: TextInput.AlignHCenter
        }

       Label {
            text:  qsTr("Password")
        }
        TextField {
            id: txtFederationAccountPassword
            placeholderText: qsTr("Password")
            horizontalAlignment: TextInput.AlignHCenter
            echoMode: TextInput.Password
        }


        Button {
            id: buttonCheckSettings
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
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

        CheckBox {
            id: enable_sync
            Layout.columnSpan: 2
            checked: network_settings.conn.enable_sync
            text: qsTr("Enable Federation synchronization")
        }

        Button {
            id: updateSettings
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
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
