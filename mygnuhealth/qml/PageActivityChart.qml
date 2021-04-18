import QtQuick 2.7
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.5 as Kirigami
import GHLifestyle 0.1
Kirigami.Page
{
id: pahist
title: qsTr("Physical Activity")
    GHLifestyle { // GHBio object registered at mygh.py
        id: ghpa
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
                source: ghpa.paplot
                fillMode:Image.PreserveAspectFit
            }
       }

    }
}

