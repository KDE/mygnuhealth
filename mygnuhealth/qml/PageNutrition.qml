import QtQuick 2.7
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import GHNutrition 0.1

Kirigami.Page {

    id: nutritionPage
    title: qsTr("Nutrition")

    // font.pointSize: Kirigami.Theme.defaultFont.pointSize * 2

    GHNutrition { // PhysicalActivity object registered at mygh.py
        id: nutrition
        onSetOK: {
            pageStack.pop() // Return to main monitor page once values are stored
        }
    }

    GridLayout {
        anchors.centerIn: parent

        id: nutrigrid
        columns: 3
        Label {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Morning")
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Afternoon")
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Evening")
        }

        SpinBox {
            id: nutriMorning
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 50
            Layout.preferredWidth: 100
            font.pixelSize:25

            editable: true
            from: 0
            to: 5000
        }
        SpinBox {
            id: nutriAfternoon
            editable: true
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 50
            Layout.preferredWidth: 100
            font.pixelSize:25
            from: 0
            to: 5000
        }

        SpinBox {
            id: nutriEvening
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 50
            Layout.preferredWidth: 100
            font.pixelSize:25
            editable: true
            from: 0
            to: 5000
        }

        TextField {
            id: nutriTotal
            readOnly: true
            Layout.columnSpan: 3
            horizontalAlignment: TextInput.AlignHCenter
            text: nutriMorning.value + nutriAfternoon.value + nutriEvening.value
        }

        TextArea {
            id:information
            Layout.columnSpan: 3
            Layout.fillWidth: true
            placeholderText: qsTr("Enter details here")
            wrapMode: TextEdit.WordWrap
        }


        Button {
            id: buttonSetNutrition
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Set")
            flat: false
            onClicked: {
                nutrition.getvals(nutriMorning.value, nutriAfternoon.value,
                                         nutriEvening.value, nutriTotal.text,
                                         information.text);
            }
        }      

    }

}

