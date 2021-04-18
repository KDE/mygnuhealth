import QtQuick 2.7
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.5 as Kirigami
import GHBio 0.1

Kirigami.Page
{
id: weighthist
title: qsTr("Body Weight")
    GHBio { // GHBio object registered at main.py
        id: ghbio
    }

    ColumnLayout {
        spacing: 30
        Layout.fillWidth: true
        Layout.fillHeight: true

        Rectangle {
            id: weighthistchart
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 350
            Layout.preferredHeight: 450
            border.width: 2
            border.color: "#108498"

            Image {
                id:weighthistplot
                anchors.fill: parent
                source: ghbio.weightplot
                fillMode:Image.PreserveAspectFit
            }
       }
    }
}

