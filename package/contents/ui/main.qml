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

import "../code/utils.js" as Utils

Item {
	id: plasmoidRoot

    // Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    GenshinDaily {
        id: genshin
        uid: plasmoid.configuration.uid
        cookie: plasmoid.configuration.cookie
        server: plasmoid.configuration.server

        onUidChanged: {
            refresh()
        }

        onCookieChanged: {
            refresh()
        }

        onServerChanged: {
            refresh()
        }


    }

    Timer {
        id: timer1
		interval: plasmoid.configuration.refreshInterval * 1000 * 60
		repeat: true
		onTriggered: genshin.refresh()
        triggeredOnStart: true
		onIntervalChanged: {
			restart()
		}
	}

    Plasmoid.fullRepresentation: GenshinHutao {
        update_time: genshin.updateTime
        resin_recovery_time: genshin.resinRecoveryTime
        current_resin: genshin.currentResin
        current_home_coin: genshin.currentHomeCoin
        max_home_coin: genshin.maxHomeCoin
        home_coin_recovery_time: genshin.homeCoinRecoveryTime
        finished_task_num: genshin.finishedTaskNum
        is_extra_task_reward_received: genshin.isExtraTaskRewardReceived
        remain_resin_discount_num: genshin.remainResinDiscountNum
        current_expedition_num: genshin.currentExpeditionNum
        max_expedition_num: genshin.maxExpeditionNum
        expeditions: genshin.expeditions
        transformer_obtained: genshin.transformerObtained
        transformer_recovery_time: genshin.transformerRecoveryTime
    }

    Plasmoid.compactRepresentation: GenshinIcon {
        current_resin: genshin.currentResin
        refresh: genshin.refresh
    }

    Plasmoid.toolTipMainText: `完全恢复：${Utils.maxTime(genshin.resinRecoveryTime)}`
    Plasmoid.toolTipSubText: `剩余时间：${Utils.sec2Day(genshin.resinRecoveryTime)}`


    Component.onCompleted: timer1.start();

}

