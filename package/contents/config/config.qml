import QtQuick 2.0
import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
        name: "通用"
        icon: "configure"
        source: "configPreferences.qml"
    }
    ConfigCategory {
        name: "配置"
        icon: "configure"
        source: "configConfiguration.qml"
    }
}