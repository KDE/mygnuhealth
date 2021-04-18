import QtQuick 2.7
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.10 as Kirigami
import GHAbout 0.1


Kirigami.Page {
    title: qsTr("About MyGNUHealth")

    GHAbout { // GHAbout object registered at main.py
        id: ghabout
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10

        Label {
            Layout.alignment: Qt.AlignCenter
            text: qsTr("The GNU Health Personal health Record")
        }
        Label {
            Layout.alignment: Qt.AlignCenter
            text: qsTr("Version %1").arg(ghabout.credits.version)
            font.bold: true
        }
        
        Image {
            Layout.preferredHeight: Kirigami.Units.gridUnit * 10
            // Layout.fillHeight: true
            fillMode: Image.PreserveAspectFit
            source: "../images/gnu_health-logo.svg"
        }
        Label {
            Layout.alignment: Qt.AlignCenter
            text:qsTr("<b>Author:</b> %1").arg(ghabout.credits.author)
        }
        Label {
            Layout.alignment: Qt.AlignCenter
            text: qsTr("MyGNUHealth is part of the GNU Health project")
            font.bold: true
        }
        Label {
            Layout.alignment: Qt.AlignCenter
            text: ghabout.credits.copyright  + " (" + ghabout.credits.license + ")"
        }
        Label {
            Layout.alignment: Qt.AlignCenter 
            text: "<a href='"+ghabout.credits.homepage+"'>"+ghabout.credits.homepage+"</a>"
            onLinkActivated: Qt.openUrlExternally(ghabout.credits.homepage)
        }
        Label {
            Layout.alignment: Qt.AlignCenter
            text: qsTr("Thank you to all contributors!")
        }
        ScrollView {
            contentHeight: 120
            contentWidth: 190
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn
            Layout.alignment: Qt.AlignCenter
            TextArea {
                Layout.alignment: Qt.AlignCenter
                readOnly: true
                wrapMode: TextEdit.WordWrap
                text: ghabout.credits.thanks
            }
        }
        Label {
            Layout.alignment: Qt.AlignCenter
            text: qsTr("The medical genetics section uses the <b>UniProt</b> human natural variants")
        }
    }
}
