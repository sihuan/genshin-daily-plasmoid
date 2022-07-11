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

    SpinBox {
        id: refreshInterval
        Kirigami.FormData.label: "刷新间隔 / ms"
        from: 10000
        to: 120 * 60 * 1000
        stepSize: 1000
    }
}
