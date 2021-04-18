import QtQuick 2.7
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.10 as Kirigami

Kirigami.Page {
    title: qsTr("Welcome to MyGNUHealth")

    ColumnLayout {
        anchors.fill: parent
        Image {
            Layout.fillWidth: true
            Layout.fillHeight: true
            fillMode: Image.PreserveAspectFit
            source: "../images/my-gnu-health.png"
            MouseArea {
                anchors.fill: parent
                onClicked: pageStack.replace(Qt.resolvedUrl("PageLocalAccountManager.qml"))
            }
        }

        Button {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Start")
            focus: true
            onClicked: pageStack.replace(Qt.resolvedUrl("PageLocalAccountManager.qml"))
        }
    }
}
