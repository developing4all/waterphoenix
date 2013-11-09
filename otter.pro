#-------------------------------------------------
#
# Project created by QtCreator 2013-06-06T21:40:25
#
#-------------------------------------------------

QT += core network gui widgets webkitwidgets

TARGET = otter
TEMPLATE = app

SOURCES += src/main.cpp\
    src/ui/MainWindow.cpp \
    src/ui/CookiesDialog.cpp \
    src/ui/PreferencesDialog.cpp \
    src/ui/TabWidget.cpp \
    src/core/SettingsManager.cpp \
    src/core/Application.cpp

HEADERS += src/ui/MainWindow.h \
    src/ui/CookiesDialog.h \
    src/ui/PreferencesDialog.h \
    src/ui/TabWidget.h \
    src/core/SettingsManager.h \
    src/core/Application.h

FORMS += src/ui/MainWindow.ui \
    src/ui/CookiesDialog.ui \
    src/ui/PreferencesDialog.ui \
    src/ui/TabWidget.ui
