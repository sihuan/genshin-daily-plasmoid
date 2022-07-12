import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.genshindaily 1.0

Item{
    id: iconRoot
    property string current_resin

    Layout.minimumWidth: PlasmaCore.Units.gridUnit * 2

    Rectangle {
        color: "transparent"
			height:parent.height
            anchors.fill: parent
			PlasmaComponents.Label {
				anchors.centerIn: parent
				text: `${current_resin}/160`
			}
	}
    MouseArea {
		anchors.fill: parent
		onClicked: plasmoid.expanded = !plasmoid.expanded
	}
    
}