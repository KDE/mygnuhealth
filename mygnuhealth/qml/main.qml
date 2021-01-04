/***********************************************************************
 * MyGNUHealth 
 * 
 * Copyright 2008-2021 Luis Falcon <falcon@gnuhealth.org>
 * Copyright 2008-2021 GNU Solidario <health@gnusolidario.org>
 * 
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 **********************************************************************/

import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.5 as Kirigami

Kirigami.ApplicationWindow {
    id: root

    property bool isLoggedIn: false

    visible: true
    title: qsTr("MyGNUHealth")

    width: app.initialGeometry.width>=10 ? app.initialGeometry.width : Kirigami.Units.gridUnit * 45
    height: app.initialGeometry.height>=10 ? app.initialGeometry.height : Kirigami.Units.gridUnit * 30
    minimumWidth: 400
    minimumHeight: 600
    pageStack.initialPage: PageInitial {}

    globalDrawer: GHDrawer {
        isLoggedIn: root.isLoggedIn
        onLogout: {
            // Clear the stack and go to the initial page
            pageStack.clear()
            pageStack.push(Qt.resolvedUrl("PageInitial.qml"))
            root.isLoggedIn = false;
        }
    }
}
