import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

Kirigami.FormLayout {
    anchors.left: parent.left
    anchors.right: parent.right

    property alias cfg_refreshInterval: refreshInterval.value
    property alias cfg_full: full.currentIndex


    SpinBox {
        id: refreshInterval
        Kirigami.FormData.label: "刷新间隔 (分钟)"
        from: 1
        to: 120
        stepSize: 1
    }

    ComboBox {
        id: full
        Kirigami.FormData.label: "样式："
        Layout.fillWidth: true
        Layout.minimumWidth: Kirigami.Units.gridUnit * 14
        model: ["便笺", "胡桃"]
    }
}
