import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 3.0 as PlasmaComponents3

Kirigami.FormLayout {
    anchors.left: parent.left
    anchors.right: parent.right

    property alias cfg_proxyEnable: proxy_enable.currentIndex
    property alias cfg_proxyType: proxy_type.currentIndex
    property alias cfg_proxyHost: proxy_host.text
    property alias cfg_proxyPort: proxy_port.value
    property alias cfg_proxyUsername: proxy_username.text
    property alias cfg_proxyPassword: proxy_password.text

    ComboBox {
        id: proxy_enable
        Kirigami.FormData.label: "代理："
        Layout.fillWidth: true
        Layout.minimumWidth: Kirigami.Units.gridUnit * 14
        model: ["不使用代理", "系统代理", "手动代理"]
    }

    PlasmaComponents3.Label {
        text: "不会弄，请 pr，下面应该是从系统获取代理的"
        Layout.fillWidth: true
        Layout.minimumWidth: Kirigami.Units.gridUnit * 14
        visible: proxy_enable.currentIndex == 1
    }

    ComboBox {
        id : proxy_type
        Kirigami.FormData.label: "类型："
        Layout.fillWidth: true
        Layout.minimumWidth: Kirigami.Units.gridUnit * 14
        model: ["HTTP", "SOCKS5"]
        visible: proxy_enable.currentIndex > 0
        enabled: proxy_enable.currentIndex > 1
    }

    TextField {
        id: proxy_host
        Kirigami.FormData.label: "主机："
        Layout.fillWidth: true
        Layout.minimumWidth: Kirigami.Units.gridUnit * 14
        visible: proxy_enable.currentIndex > 0
        enabled: proxy_enable.currentIndex > 1
    }

    SpinBox {
        id: proxy_port
        from: 0
        to: 65535
        Kirigami.FormData.label: "端口："
        Layout.fillWidth: true
        Layout.minimumWidth: Kirigami.Units.gridUnit * 14
        visible: proxy_enable.currentIndex > 0
        enabled: proxy_enable.currentIndex > 1
    }

    TextField {
        id: proxy_username
        Kirigami.FormData.label: "用户名："
        Layout.fillWidth: true
        Layout.minimumWidth: Kirigami.Units.gridUnit * 14
        visible: proxy_enable.currentIndex > 0
        enabled: proxy_enable.currentIndex > 1
    }

    TextField {
        id: proxy_password
        Kirigami.FormData.label: "密码："
        Layout.fillWidth: true
        Layout.minimumWidth: Kirigami.Units.gridUnit * 14
        visible: proxy_enable.currentIndex > 0
        enabled: proxy_enable.currentIndex > 1
    }
}
