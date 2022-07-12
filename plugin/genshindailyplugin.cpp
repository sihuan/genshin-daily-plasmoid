/*
    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
    SPDX-License-Identifier: LGPL-2.1-or-later
*/

#include "genshindailyplugin.h"

// KF
#include <KLocalizedString>
// Qt
#include <QJSEngine>
#include <QQmlEngine>
#include <QQmlContext>

void genshinDailyPlugin::registerTypes(const char* uri)
{
    Q_ASSERT(uri == QLatin1String("org.kde.plasma.private.genshindaily"));
    qmlRegisterType<GenshinDaily>(uri, 1, 0, "GenshinDaily");
}
