/*
    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
    SPDX-License-Identifier: LGPL-2.1-or-later
*/

#ifndef GENSHINDAILYPLUGIN_H
#define GENSHINDAILYPLUGIN_H

#include <QQmlExtensionPlugin>

#include <genshindaily.h>

class genshinDailyPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri) override;
};

#endif // GENSHINDAILYPLUGIN_H
