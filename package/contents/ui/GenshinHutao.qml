import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.genshindaily 1.0

import "../code/utils.js" as Utils
 
Item{
    id: hutaoRoot
    Layout.preferredWidth: 280 * PlasmaCore.Units.devicePixelRatio
    Layout.preferredHeight: 425 * PlasmaCore.Units.devicePixelRatio

    property int update_time
    property int resin_recovery_time
    property int current_resin
    property int current_home_coin
    property int max_home_coin
    property int home_coin_recovery_time
    property int finished_task_num
    property bool is_extra_task_reward_received
    property int remain_resin_discount_num
    property int current_expedition_num
    property int max_expedition_num
    property var expeditions
    property bool transformer_obtained
    property int transformer_recovery_time

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 0
        anchors.leftMargin: 8 * PlasmaCore.Units.devicePixelRatio
        anchors.rightMargin: 8 * PlasmaCore.Units.devicePixelRatio

        Rectangle {
            id: title
            color: "#00000000" // 透明
            height: 20 * PlasmaCore.Units.devicePixelRatio
            Layout.fillWidth: true
            PlasmaComponents.Label {
                anchors.fill: parent
                text: `Update: ${Utils.sTime(update_time * 1000,true,true)}`
                font.pointSize : 5 * PlasmaCore.Units.devicePixelRatio
                horizontalAlignment: Text.AlignHCenter
                opacity: 0.5
            }
        }

        Rectangle {
            id: resinTitle
            color: "#00000000" // 透明
            height:  25 * PlasmaCore.Units.devicePixelRatio
            Layout.fillWidth: true
            Image {
                id: resinImage
                source: "../images/resin.png"
                fillMode: Image.Stretch
                height: 18 * PlasmaCore.Units.devicePixelRatio
                width:  18 * PlasmaCore.Units.devicePixelRatio
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }
            PlasmaComponents.Label {
                anchors.left: resinImage.right
                anchors.leftMargin: 8 * PlasmaCore.Units.devicePixelRatio
                height:parent.height
                text: "Current Resin"
                font.pointSize : 7 * PlasmaCore.Units.devicePixelRatio
                horizontalAlignment: Text.left
                opacity: 0.5
            }
        }

        Rectangle {
            color: "#00000000" // 透明
            height: 30 * PlasmaCore.Units.devicePixelRatio
            Layout.fillWidth: true

            PlasmaComponents.Label {
                anchors.fill: parent
                text: `${current_resin}/160`
                font.pointSize : 14 * PlasmaCore.Units.devicePixelRatio
                font.italic: true
                font.bold: true
                horizontalAlignment: Text.left
            }
        }

        Rectangle {
            color: "#00000000" // 透明
            height: 18 * PlasmaCore.Units.devicePixelRatio
            Layout.fillWidth: true
            
            PlasmaCore.IconItem {
                id: resinFullIcon
                source: "games-solve"
                height: 18 * PlasmaCore.Units.devicePixelRatio
                width:  18 * PlasmaCore.Units.devicePixelRatio
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            
            }

            PlasmaComponents.Label {
                anchors.left: resinFullIcon.right
                height: parent.height
                anchors.leftMargin: 8 * PlasmaCore.Units.devicePixelRatio
                text: "Fully replenenished"
                font.pointSize : 7 * PlasmaCore.Units.devicePixelRatio
                horizontalAlignment: Text.left
            }

            PlasmaComponents.Label {
                anchors.right: parent.right
                height: parent.height
                text: Utils.sec2Day(resin_recovery_time,true)
                font.pointSize : 7 * PlasmaCore.Units.devicePixelRatio
                font.italic: true
                font.bold: true
                horizontalAlignment: Text.right
            }

        }
        Rectangle {
            color: "#00000000" // 透明
            height: 18 * PlasmaCore.Units.devicePixelRatio
            Layout.fillWidth: true
            
            PlasmaCore.IconItem {
                id: resinETAIcon
                source: "appointment-new-symbolic"
                height: 18 * PlasmaCore.Units.devicePixelRatio
                width:  18 * PlasmaCore.Units.devicePixelRatio
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            
            }

            PlasmaComponents.Label {
                anchors.left: resinETAIcon.right
                height: parent.height
                anchors.leftMargin: 8 * PlasmaCore.Units.devicePixelRatio
                text: "ETA"
                font.pointSize : 7 * PlasmaCore.Units.devicePixelRatio
                horizontalAlignment: Text.left
            }

            PlasmaComponents.Label {
                anchors.right: parent.right
                height: parent.height
                text: Utils.maxTime(resin_recovery_time,true)
                font.pointSize : 7 * PlasmaCore.Units.devicePixelRatio
                font.italic: true
                font.bold: true
                horizontalAlignment: Text.right
            }

        }

        Rectangle {
            color: "#00000000"
            height: 10 * PlasmaCore.Units.devicePixelRatio
            Layout.fillWidth: true
            Rectangle {
                color: "black"
                opacity:0.1
                width: parent.width
                height: 1 * PlasmaCore.Units.devicePixelRatio
                anchors.verticalCenter : parent.verticalCenter
            }
        }

        Rectangle {
            id: expeditionTitle
            color: "#00000000" // 透明
            height:  25 * PlasmaCore.Units.devicePixelRatio
            Layout.fillWidth: true

            PlasmaComponents.Label {
                anchors.left: parent.left
                height:parent.height
                text: `Expeditions ${current_expedition_num}/${max_expedition_num}`
                font.pointSize : 7 * PlasmaCore.Units.devicePixelRatio
                horizontalAlignment: Text.left
                opacity: 0.5
            }

            Image {
                source: "../images/expedition.png"
                fillMode: Image.Stretch
                height: 14 * PlasmaCore.Units.devicePixelRatio
                width:  14 * PlasmaCore.Units.devicePixelRatio
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Repeater {
            model: expeditions
            Rectangle {
                color: "#00000000" // 透明
                height: 24 * PlasmaCore.Units.devicePixelRatio
                Layout.fillWidth: true

                Rectangle{
                    border.color: "gray"
                    color: "#00000000" // 透明
                    border.width: 1 * PlasmaCore.Units.devicePixelRatio
                    height: 18 * PlasmaCore.Units.devicePixelRatio
                    width:  18 * PlasmaCore.Units.devicePixelRatio
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 100;
                    clip: true; 
                    Image {
                        source: modelData.avatar_side_icon
                        fillMode: Image.Stretch
                        anchors.fill: parent
                    }
                }

                PlasmaComponents.Label {
                    anchors.left: parent.left
                    height: parent.height
                    anchors.leftMargin: (8 + 18) * PlasmaCore.Units.devicePixelRatio
                    text: Utils.expeditionStatus(modelData.status,true)
                    font.pointSize : 7 * PlasmaCore.Units.devicePixelRatio
                    horizontalAlignment: Text.left
                }

                PlasmaComponents.Label {
                    anchors.right: parent.right
                    height: parent.height
                    text: Utils.sec2Day(modelData.remained_time,true)
                    font.pointSize : 7 * PlasmaCore.Units.devicePixelRatio
                    font.italic: true
                    font.bold: true
                    horizontalAlignment: Text.right
                }

            }
        }

        Rectangle {
            color: "#00000000"
            height: 10 * PlasmaCore.Units.devicePixelRatio
            Layout.fillWidth: true
            Rectangle {
                color: "black"
                opacity:0.1
                width: parent.width
                height: 1 * PlasmaCore.Units.devicePixelRatio
                anchors.verticalCenter : parent.verticalCenter
            }
        }

        Repeater {
            id: repeater1
            model: ListModel {
                id: model1
                property alias v1: hutaoRoot.finished_task_num
                property alias v2: hutaoRoot.remain_resin_discount_num
                property alias v3: hutaoRoot.current_home_coin
                property alias v4: hutaoRoot.max_home_coin
                property alias v5: hutaoRoot.transformer_recovery_time

                property bool completed: false
                Component.onCompleted: {
                    model1.append({ images:"../images/task.png",desc:"Daily commissions",v:`${4-v1} left` });
                    model1.append({ images:"../images/zzbf.png",desc:"Weekly bosses",v:`${v2} left` });
                    model1.append({ images:"../images/home_coin.png",desc:"Home coin",v:`${v3}/${v4}` });
                    model1.append({ images:"../images/transformer.png",desc:"Parametric transformer",v:`${Utils.sec2Day(v5,true)}` });
                    completed = true;
                }
                onV1Changed:{
                     if(completed) setProperty(0, "v", `${4-v1} left`);
                }
                onV2Changed:{
                     if(completed) setProperty(1, "v", `${v2} left`);
                }
                onV3Changed:{
                     if(completed) setProperty(2, "v", `${v3}/${v4}`);
                }
                onV4Changed:{
                     if(completed) setProperty(2, "v", `${v3}/${v4}`);
                }
                onV5Changed:{
                     if(completed) setProperty(3, "v", `${Utils.sec2Day(v5,true)}`);
                }
            }
            Rectangle {
                color: "#00000000" // 透明
                height: 24 * PlasmaCore.Units.devicePixelRatio
                Layout.fillWidth: true

                Image{
                    height: 18 * PlasmaCore.Units.devicePixelRatio
                    width:  18 * PlasmaCore.Units.devicePixelRatio
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    source: images
                    fillMode: Image.Stretch
                }

                PlasmaComponents.Label {
                    anchors.left: parent.left
                    height: parent.height
                    anchors.leftMargin: (8 + 18) * PlasmaCore.Units.devicePixelRatio
                    text: desc
                    font.pointSize : 7 * PlasmaCore.Units.devicePixelRatio
                    horizontalAlignment: Text.left
                }

                PlasmaComponents.Label {
                    anchors.right: parent.right
                    height: parent.height
                    text: v
                    font.pointSize : 7 * PlasmaCore.Units.devicePixelRatio
                    font.italic: true
                    font.bold: true
                    horizontalAlignment: Text.right
                }

            }
        }

        Rectangle {
            color: "#00000000"
            height: 10 * PlasmaCore.Units.devicePixelRatio
            Layout.fillWidth: true
            Rectangle {
                color: "black"
                opacity:0.1
                width: parent.width
                height: 1 * PlasmaCore.Units.devicePixelRatio
                anchors.verticalCenter : parent.verticalCenter
            }
        }

        Rectangle {
            color: "#00000000" // 透明
            height:  25 * PlasmaCore.Units.devicePixelRatio
            Layout.fillWidth: true
            PlasmaComponents.Label {
                anchors.left: parent.left
                height:parent.height
                text: "Refresh"
                font.pointSize : 7 * PlasmaCore.Units.devicePixelRatio
                horizontalAlignment: Text.left
                font.bold: true
            }
            PlasmaComponents.Label {
                anchors.right: parent.right
                height:parent.height
                text: "CTRL+R"
                font.pointSize : 7 * PlasmaCore.Units.devicePixelRatio
                horizontalAlignment: Text.right
                opacity: 0.5
            }
        }

        
    }
}
