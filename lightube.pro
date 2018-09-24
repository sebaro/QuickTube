
TARGET = lightube
TEMPLATE = app

QT += qml quick widgets

SOURCES += src/main.cpp

HEADERS += src/process.h \
	   src/request.h

RESOURCES += src/resources.qrc

CONFIG(release) {
  unix:OBJECTS_DIR = ./build/.obj/unix
  win32:OBJECTS_DIR = ./build/.obj/win32
  mac:OBJECTS_DIR = ./build/.obj/mac
  UI_DIR = ./build/.ui
  MOC_DIR = ./build/.moc
  RCC_DIR = ./build/.rcc
}
