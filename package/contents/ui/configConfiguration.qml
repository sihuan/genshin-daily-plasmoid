// configGeneral.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    width: childrenRect.width
    height: childrenRect.height

    property alias cfg_uid: uid.text
    property alias cfg_server: server.currentIndex
    property alias cfg_cookie: cookie.text

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        TextField {
            Kirigami.FormData.label: "UID："
            id: uid
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        ComboBox {
            id: server
            Kirigami.FormData.label: "服务器："
            Layout.fillWidth: true
            Layout.minimumWidth: Kirigami.Units.gridUnit * 14
            model: ["天空岛", "世界树","Asia","America","Europe","TW,HK,MO"]
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        TextField {
            id: cookie
            Kirigami.FormData.label: "Cookie："
            Layout.maximumWidth: Kirigami.Units.gridUnit * 14
            height: Kirigami.Units.gridUnit * 6
            // passwordCharacter: "*"
            // echoMode: TextField.Password
            wrapMode: Text.WordWrap 
        }


    }

}

