import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.5 as Kirigami
import GHBio 0.1

Kirigami.Page
{
id: osathist
title: qsTr("Hb Oxygen Saturation")
    GHBio { // GHBio object registered at mygh.py
        id: ghbio
    }

    ColumnLayout {
        spacing: 30
        Layout.fillWidth: true
        Layout.fillHeight: true

        Rectangle {
            id: osathistchart
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 350
            Layout.preferredHeight: 250
            border.width: 2
            border.color: "#108498"

            Image {
                id:osathistplot
                anchors.fill: parent
                source: ghbio.osatplot
                fillMode:Image.PreserveAspectFit
            }
       }
    }
}

