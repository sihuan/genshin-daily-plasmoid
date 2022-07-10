add_definitions(-DTRANSLATION_DOMAIN=\"plasma_applet_org.kde.plasma.genshindaily\")

add_library(genshindailyplugin SHARED genshindailyplugin.cpp)

target_link_libraries(genshindailyplugin
    KF5::I18n
    Qt5::Gui
    Qt5::Qml
)
install(TARGETS genshindailyplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/plasma/private/genshindaily)
install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/plasma/private/genshindaily)
