/*
    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
    SPDX-License-Identifier: LGPL-2.1-or-later
*/

import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.genshindaily 1.0

ColumnLayout {
    HttpRequest { id: httpRequest }
    property int $resin_recover_time: 0
    property int $home_coin_recover_time: 0
    Timer{ 
        id: refreshtimer
        interval: plasmoid.configuration.refreshInterval
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            doGet($url, function(responseText){
                let data = JSON.parse(responseText).data;
                refresData(data);
            });
        }
    }
    Timer{ 
        id: countdown
        interval: 1000 * 60
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            $resin_recover_time-=60;
            $home_coin_recover_time-=60;
            if ($resin_recover_time < 0) {
                $resin_recover_time = 0;
            };
            if ($home_coin_recover_time < 0) {
                $home_coin_recover_time = 0;
            };
            repeater.model.setProperty(0,"desc",  $resin_recover_time == 0 ? "原粹树脂已全部恢复！" : `将于${sec2Hour($resin_recover_time)}后全部恢复`);
            repeater.model.setProperty(1,"desc",  $home_coin_recover_time == 0 ? "洞天宝钱已达到上限！" : `预计${sec2Hour($home_coin_recover_time)}后达到储存上限`);

        }
    }

    property variant $url: "https://api-takumi-record.mihoyo.com/game_record/app/genshin/api/dailyNote?role_id=100461712&server=cn_gf01"
    property variant $query: "role_id=" + plasmoid.configuration.uid + "&server=cn_gf01"
    // property variant $cookie: "_MHYUUID=3724b72b-bc15-4f44-8e60-690da9227ea0; ltoken=cD5SwwVO57VtBS4WyMdsXQQkFTNZ300gFG8XUFcg; ltuid=159620788; cookie_token=ki7vCDGpgIMw6Jpe7DcUmzAJoczdQbh4SrLKf0mL; account_id=159620788"


    function doGet(url, cb) {
        console.log(httpRequest.getRequestHeader("Cookie"))
        httpRequest.clear();
        httpRequest.finished.connect(function(){
            httpRequest.finished.disconnect(arguments.callee);
            //console.log(httpRequest.responseText);
            cb(httpRequest.responseText)
        });
        httpRequest.error.connect(function(){
            httpRequest.error.disconnect(arguments.callee);
            console.log(httpRequest.statusText);
        });
        httpRequest.timeout.connect(function(){
            httpRequest.timeout.disconnect(arguments.callee);
            console.log("time out");
        });
        httpRequest.open("GET", url);
        httpRequest.setTimeout(3 * 1000);      // 3 s
        httpRequest.setRequestHeader("x-rpc-app_version", "2.26.1");
        httpRequest.setRequestHeader("x-rpc-client_type", "5");
        httpRequest.setRequestHeader("DS", getDs($query));
        httpRequest.setRequestHeader("Cookie", plasmoid.configuration.cookie);
        console.log(httpRequest.getRequestHeader("Cookie"))
        httpRequest.send();
    }


    function getDs(q) {
        let n = "xV8v4Qu54lUKrEYFZkJhB8cuOh9Asafs";
        let t = Math.round(new Date().getTime() / 1000);
        let r = Math.floor(Math.random() * 900000 + 100000);
        let DS = Qt.md5(`salt=${n}&t=${t}&r=${r}&b=&q=${q}`);
        return `${t},${r},${DS}`;
    }

    function sec2Hour(sec) {
        let hour = Math.floor(sec / 3600);
        let min = Math.floor((sec - hour * 3600) / 60);
        return hour ? `${hour}小时${min}分钟` : `${min}分钟`;
    }

    function refresData(data){
        countdown.stop();
        $resin_recover_time = data.resin_recovery_time;
        repeater.model.setProperty(0, "v", `${data.current_resin}/${data.max_resin}`);
        $home_coin_recover_time = data.home_coin_recovery_time;
        repeater.model.setProperty(1, "v", `${data.current_home_coin}/${data.max_home_coin}`);
        let task_desc = "「每日委托」奖励已领取"
        if (data.total_task_num > data.finished_task_num ){
            task_desc = "今日完成的委托数不足，请继续加油！"
        } else if (!data.is_extra_task_reward_received){
            task_desc = "「每日委托」额外奖励尚未领取！"
        }
        repeater.model.setProperty(2,"desc", task_desc);
        repeater.model.setProperty(2, "v", `${data.finished_task_num}/${data.total_task_num}`);
        repeater.model.setProperty(3,"v", `${data.remain_resin_discount_num}/${data.resin_discount_num_limit}`);
        let transformer_desc = "尚未获得参量质变仪"
        let transformer_v = "未获得"
        if(data.transformer.obtained){
            transformer_v = "已冷却"
            let r = data.transformer.recovery_time;
            if (!r.reached){
                transformer_v = "冷却中";
                transformer_desc = `${ r.Day ? `${r.Day}天` : "" }${ r.Hour ? `${r.Hour}小时` : "" }可再次使用`;
            }
        }
        repeater.model.setProperty(4,"desc", transformer_desc);
        repeater.model.setProperty(4, "v", transformer_v);
        countdown.start();
    }

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
    Layout.preferredWidth: 480 * PlasmaCore.Units.devicePixelRatio
    Layout.preferredHeight: 480 * PlasmaCore.Units.devicePixelRatio

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

    Repeater {
        id: repeater
        model: ListModel {
            ListElement { name: "原粹树脂";image:"../images/resin.png"; desc: ""; v:"" }
            ListElement { name: "洞天财瓮-洞天宝钱";image:"../images/home_coin.png"; desc: ""; v:"" }
            ListElement { name: "每日委托任务";image:"../images/task.png"; desc: ""; v:"" }
            ListElement { name: "值得铭记的强敌";image:"../images/zzbf.png"; desc: "本周消耗的剩余减半次数"; v:"" }
            ListElement { name: "参量质变仪";image:"../images/transformer.png"; desc: ""; v:"" }
        }

        Rectangle {
            color: "#F5F0EA"
            Layout.fillHeight: true
            Layout.fillWidth: true

            Image {
                source: image
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
                    text: name
                    font.pointSize : 8 * PlasmaCore.Units.devicePixelRatio
            }

            PlasmaComponents.Label {
                    anchors.left: parent.left
                    anchors.top: parent.verticalCenter
                    anchors.leftMargin: parent.width/50 + 50 * PlasmaCore.Units.devicePixelRatio
                    text: desc
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
                    text: v
                    font.pointSize : 8 * PlasmaCore.Units.devicePixelRatio
                    horizontalAlignment: Text.AlignHCenter
                    color: "#B2957D"
                }
            }
        }
    }

    Component.onCompleted: refreshtimer.start();
}

