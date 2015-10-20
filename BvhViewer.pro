TARGET=BvhViewer
OBJECTS_DIR=obj
# as I want to support 4.8 and 5 this will set a flag for some of the mac stuff
# mainly in the types.h file for the setMacVisual which is native in Qt5
isEqual(QT_MAJOR_VERSION, 5) {
	cache()
	DEFINES +=QT5BUILD
}



MOC_DIR=moc
CONFIG-=app_bundle
QT+=gui opengl core
SOURCES+= $$PWD/src/main.cpp \
        $$PWD/src/NGLScene.cpp \
        $$PWD/src/Bvh.cpp \
        $$PWD/src/Scene.cpp

HEADERS+=$$PWD/include/NGLScene.h \
        $$PWD/include/Bvh.h \
        $$PWD/include/Scene.h

INCLUDEPATH +=./include

DESTDIR=./
OTHER_FILES+= shaders/PhongFragment.glsl \
              shaders/PhongVertex.glsl
CONFIG -= app_bundle

# were are going to default to a console app
CONFIG += console
# note each command you add needs a ; as it will be run as a single line
# first check if we are shadow building or not easiest way is to check out against current
!equals(PWD, $${OUT_PWD}){
	copydata.commands = echo "creating destination dirs" ;
	# now make a dir
	copydata.commands += mkdir -p $$OUT_PWD/shaders ;
	copydata.commands += mkdir -p $$OUT_PWD/bvh ;
	copydata.commands += echo "copying files" ;
	# then copy the files
	copydata.commands += $(COPY_DIR) $$PWD/shaders/* $$OUT_PWD/shaders/ ;
	copydata.commands += $(COPY_DIR) $$PWD/bvh/* $$OUT_PWD/bvh/ ;
	# now make sure the first target is built before copy
	first.depends = $(first) copydata
	export(first.depends)
	export(copydata.commands)
	# now add it as an extra target
	QMAKE_EXTRA_TARGETS += first copydata
}
NGLPATH=$$(NGLDIR)
isEmpty(NGLPATH){ # note brace must be here
	message("including $HOME/NGL")
	include($(HOME)/NGL/UseNGL.pri)
}
else{ # note brace must be here
	message("Using custom NGL location")
	include($(NGLDIR)/UseNGL.pri)
}
