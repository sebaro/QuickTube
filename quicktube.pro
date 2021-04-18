
TARGET = quicktube
TEMPLATE = app

QT += qml quick widgets

SOURCES += src/main.cpp

HEADERS += src/tools/process.h \
           src/tools/request.h

RESOURCES += src/resources.qrc

# BUILD

CONFIG(release) {
	unix:OBJECTS_DIR = ./build/.obj/unix
	win32:OBJECTS_DIR = ./build/.obj/win32
	mac:OBJECTS_DIR = ./build/.obj/mac
	UI_DIR = ./build/.ui
	MOC_DIR = ./build/.moc
	RCC_DIR = ./build/.rcc
}

# INSTALL

PREFIX = /usr

target.path = $$PREFIX/bin
documentation.path = $$PREFIX/share/$$TARGET/doc
documentation.files = README.md CHANGES LICENSE
iconpng.path = $$PREFIX/share/icons/hicolor/128x128/apps
iconpng.files = $${TARGET}.png
desktop.path = $$PREFIX/share/applications
desktop.files += $${TARGET}.desktop

INSTALLS += target documentation iconpng desktop
