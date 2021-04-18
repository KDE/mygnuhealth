import QtQuick 2.7
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.5 as Kirigami
import GHBio 0.1

Kirigami.ScrollablePage
{
    id: biopage
    title: qsTr("GNU Health - BIO")

    GHBio { // GHBio object registered at main.py
        id: ghbio
    }

    ColumnLayout {
        spacing: Kirigami.Units.gridUnit

        Kirigami.CardsLayout {

            // Blood pressure / Heart Rate
            Kirigami.Card {
                banner {
                    iconSource: Qt.resolvedUrl("../images/bp-icon.svg")
                    title: qsTr("Blood pressure / Heart Rate")
                }
                actions: [
                    Kirigami.Action {
                        icon.name: "view-visible"
                        text: qsTr("View Chart")
                        onTriggered: pageStack.push(Qt.resolvedUrl("PageBioBPChart.qml"))
                    },
                    Kirigami.Action {
                        icon.name: "document-edit"
                        onTriggered: pageStack.push(Qt.resolvedUrl("PageBloodpressure.qml"))
                        text: qsTr("Add Blood Pressure Entry")
                    }
                ]
                contentItem: Column {
                    id: bphist
                    readonly property var bpinfo: ghbio.bp
                    readonly property var bpdate: bpinfo[0]
                    readonly property var bpsystolic: bpinfo[1]
                    readonly property var bpdiastolic: bpinfo[2]
                    readonly property var heartrate: qsTr("%1 bpm").arg(bpinfo[3])

                    Label {
                        id: txtBpdate
                        horizontalAlignment: Text.AlignHCenter
                        text: bphist.bpdate
                        width: parent.width
                    }

                    Label {
                        text: qsTr("%1 / %2 mmHg").arg(bphist.bpsystolic).arg(bphist.bpdiastolic)
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                        font.weight: Font.Bold
                    }

                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: bphist.heartrate
                        width: parent.width
                    }
                }
            }

            // GLUCOSE
            Kirigami.Card {
                banner {
                    iconSource: Qt.resolvedUrl("../images/glucose-icon.svg")
                    title: qsTr("Glucose")
                }

                actions: [
                    Kirigami.Action {
                        icon.name: "view-visible"
                        text: qsTr("View Chart")
                        onTriggered: pageStack.push(Qt.resolvedUrl("PageBioGlucoseChart.qml"))
                    },
                    Kirigami.Action {
                        onTriggered: pageStack.push(Qt.resolvedUrl("PageGlucose.qml"))
                        icon.name: "document-edit"
                        text: qsTr("Add Glucose Entry")
                    }
                ]

                contentItem: Column {
                    id: glucosehist
                    readonly property var glucoseinfo: ghbio.glucose
                    readonly property var glucosedate: glucoseinfo[0]
                    readonly property var glucose: glucoseinfo[1]

                    Label {
                        text: glucosehist.glucosedate
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                    }

                    Label {
                        text: qsTr("%1 mg/dl").arg(glucosehist.glucose)
                        font.weight: Font.Bold
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                    }
                }
            }

            // WEIGHT
            Kirigami.Card {
                banner {
                    iconSource: Qt.resolvedUrl("../images/weight-icon.svg")
                    title: qsTr("Weight")
                }

                actions: [
                    Kirigami.Action {
                        icon.name: "view-visible"
                        text: qsTr("View Chart")
                        onTriggered: pageStack.push(Qt.resolvedUrl("PageBioWeightChart.qml"))
                    },
                    Kirigami.Action {
                        onTriggered: pageStack.push(Qt.resolvedUrl("PageWeight.qml"))
                        icon.name: "document-edit"
                        text: qsTr("Add Weight Entry")
                    }
                ]

                contentItem: Column {
                    id: weighthist
                    readonly property var weightinfo: ghbio.weight
                    readonly property var weightdate: weightinfo[0]
                    readonly property var weight: weightinfo[1]

                    Label {
                        text: weighthist.weightdate
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                    }

                    Label {
                        text: qsTr("%1 kg").arg(weighthist.weight)
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                        font.weight: Font.Bold
                    }
                }
            }

            // Oxygen  Saturation (Hb)
            Kirigami.Card {
                banner {
                    iconSource: Qt.resolvedUrl("../images/osat-icon.svg")
                    title: qsTr("Oxygen Saturation (Hb)")
                }

                actions: [
                    Kirigami.Action {
                        icon.name: "view-visible"
                        text: qsTr("View Chart")
                        onTriggered: pageStack.push(Qt.resolvedUrl("PageBioOsatChart.qml"))
                    },
                    Kirigami.Action {
                        onTriggered: pageStack.push(Qt.resolvedUrl("PageOsat.qml"))
                        icon.name: "document-edit"
                        text: qsTr("Add Oxygen Saturation Entry")
                    }
                ]

                contentItem: Column {
                    id: osathist
                    property var osatinfo: ghbio.osat
                    property var osatdate: osatinfo[0]
                    property var osat: osatinfo[1]

                    Label {
                        text: osathist.osatdate
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                    }

                    Text {
                        text: qsTr("%1 %").arg(osathist.osat)
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                        font.weight: Font.Bold
                    }
                }
            }
        }
    }
}
