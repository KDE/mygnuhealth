import QtQuick 2.7
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.5 as Kirigami
// import org.kde.quickcharts 1.0 as Charts
import GHBio 0.1

Kirigami.Page
{
id: bphist
title: qsTr("Blood Pressure & Heart Rate")
    GHBio { // GHBio object registered at main.py
        id: ghbio
    }

    ColumnLayout {
        spacing: 30
        Layout.fillWidth: true
        Layout.fillHeight: true

        Rectangle {
            id: bphistchart
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 350
            Layout.preferredHeight: 250
            border.width: 2
            border.color: "#108498"

            Image {
                id:bphistplot
                anchors.fill: parent
                source: ghbio.bpplot
                fillMode:Image.PreserveAspectFit
            }
       }


        Rectangle {
            id: hrhistchart
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 340
            Layout.preferredHeight: 240
            border.width: 2
            border.color: "#108498"

            Image {
                id:hrhistplot
                anchors.fill: parent
                source: ghbio.hrplot
                fillMode:Image.PreserveAspectFit
            }
       }

    }
}

