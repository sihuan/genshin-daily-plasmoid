import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.genshindaily 1.0

import "../code/utils.js" as Utils
 
Item{
    id: fullRoot
    Layout.preferredWidth: 380 * PlasmaCore.Units.devicePixelRatio
    Layout.preferredHeight: 480 * PlasmaCore.Units.devicePixelRatio

    property int resin_recovery_time
    property int current_resin
    property int current_home_coin
    property int max_home_coin
    property int home_coin_recovery_time
    property int finished_task_num
    property bool is_extra_task_reward_received
    property int remain_resin_discount_num
    property bool transformer_obtained
    property int transformer_recovery_time

    ColumnLayout {
        anchors.fill: parent

        Rectangle {
            color: "#00000000" // 透明
            height: 40
            Layout.fillWidth: true
            PlasmaComponents.Label {
                anchors.fill: parent
                text: "实时便笺"
                font.pointSize : 8 * PlasmaCore.Units.devicePixelRatio
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Loader {
            id: resin
            sourceComponent: justaComponent
            Layout.fillHeight: true
            Layout.fillWidth: true            
            onLoaded: {
                item.imageSource = "../images/resin.png"
                item.title = "原粹树脂"
            }
            Binding {
                target: resin.item
                property: "v"
                value: `${current_resin}/160`
                when: resin.status == Loader.Ready
            }
            Binding {
                target: resin.item
                property: "desc"
                value: resin_recovery_time == 0 ? "原粹树脂已全部恢复！" : `将于${Utils.sec2Day(resin_recovery_time)}后全部恢复`
                when: resin.status == Loader.Ready
            }
        }

        Loader {
            id: home_coin
            sourceComponent: justaComponent
            Layout.fillHeight: true
            Layout.fillWidth: true            
            onLoaded: {
                item.imageSource = "../images/home_coin.png"
                item.title = "洞天财瓮-洞天宝钱"
            }
            Binding {
                target: home_coin.item
                property: "v"
                value: `${current_home_coin}/${max_home_coin}`
                when: home_coin.status == Loader.Ready
            }
            Binding {
                target: home_coin.item
                property: "desc"
                value: home_coin_recovery_time == 0 ? "洞天宝钱已达到上限！" : `预计${Utils.sec2Day(home_coin_recovery_time)}后达到储存上限`
                when: home_coin.status == Loader.Ready
            }
        }

        Loader {
            id: task
            sourceComponent: justaComponent
            Layout.fillHeight: true
            Layout.fillWidth: true            
            onLoaded: {
                item.imageSource = "../images/task.png"
                item.title = "每日委托任务"
            }
            Binding {
                target: task.item
                property: "v"
                value: `${finished_task_num}/4`
                when: task.status == Loader.Ready
            }
            Binding {
                target: task.item
                property: "desc"
                value: is_extra_task_reward_received ? "「每日委托」奖励已领取" :(
                    finished_task_num == 4 ? "尚未领取额外奖励！" : "今日完成委托数量不足！"
                )
                when: task.status == Loader.Ready
            }
        }

        Loader {
            id: weekily_boss
            sourceComponent: justaComponent
            Layout.fillHeight: true
            Layout.fillWidth: true            
            onLoaded: {
                item.imageSource = "../images/zzbf.png"
                item.title = "值得铭记的强敌"
                item.desc = "本周剩余消耗减半次数"
            }
            Binding {
                target: weekily_boss.item
                property: "v"
                value: `${remain_resin_discount_num}/3`
                when: weekily_boss.status == Loader.Ready
            }
        }

        Loader {
            id: transformer
            sourceComponent: justaComponent
            Layout.fillHeight: true
            Layout.fillWidth: true            
            onLoaded: {
                item.imageSource = "../images/transformer.png"
                item.title = "参量质变仪"
            }
            Binding {
                target: transformer.item
                property: "v"
                value: !transformer_obtained ? "未获得" : (
                    transformer_recovery_time[4] == 1 ? "已冷却" : "冷却中"
                )
                when: transformer.status == Loader.Ready
            }
            Binding {
                target: transformer.item
                property: "desc"
                value: !transformer_obtained ? "未获得" : (
                    transformer_recovery_time[4] == 1 ? "已冷却" : `${Utils.sec2Day(transformer_recovery_time)}后可再次使用`
                )
                when: transformer.status == Loader.Ready
            }
        }
    }

    Component {
        id: justaComponent
        Rectangle {
            id: componentRoot
            property string imageSource
            property string title
            property string desc
            property string v

            color: "#F5F0EA"

            Image {
                source: componentRoot.imageSource
                fillMode: Image.Pad
                anchors.left: parent.left
                anchors.top : parent.top
                anchors.leftMargin: parent.width/50
                anchors.verticalCenter: parent.verticalCenter

            }

            PlasmaComponents.Label {
                    anchors.left: parent.left
                    anchors.bottom: parent.verticalCenter
                    anchors.leftMargin: parent.width/50 + 50 * PlasmaCore.Units.devicePixelRatio
                    text: componentRoot.title
                    font.pointSize : 8 * PlasmaCore.Units.devicePixelRatio
            }

            PlasmaComponents.Label {
                    anchors.left: parent.left
                    anchors.top: parent.verticalCenter
                    anchors.leftMargin: parent.width/50 + 50 * PlasmaCore.Units.devicePixelRatio
                    text: componentRoot.desc
                    font.pointSize : 6 * PlasmaCore.Units.devicePixelRatio
                    color: "#BEB0A5"

            }
            Rectangle {
                color: "#EDE1D4"
                width: parent.width / 4
                height: parent.height
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                PlasmaComponents.Label {
                    anchors.fill: parent
                    text: componentRoot.v
                    font.pointSize : 8 * PlasmaCore.Units.devicePixelRatio
                    horizontalAlignment: Text.AlignHCenter
                    color: "#B2957D"
                }
            }
        }
    }

}