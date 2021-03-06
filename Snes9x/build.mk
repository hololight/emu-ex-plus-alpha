ifndef inc_main
inc_main := 1

ifneq ($(ENV), linux)
 # -O3 is faster with Snes9x
 CFLAGS_OPTIMIZE_LEVEL_RELEASE_DEFAULT = -O3
endif

include $(IMAGINE_PATH)/make/imagineAppBase.mk

snes9xPath := snes9x
CPPFLAGS += \
-I$(projectPath)/src \
-I$(projectPath)/src/snes9x \
-I$(projectPath)/src/snes9x/apu/bapu \
-DHAVE_STRINGS_H \
-DHAVE_STDINT_H \
-DRIGHTSHIFT_IS_SAR \
-DZLIB \
-DUSE_OPENGL \
-DPIXEL_FORMAT=RGB565
#-DHAVE_MKSTEMP -DUSE_THREADS

snes9xSrc := \
bsx.cpp \
c4.cpp \
c4emu.cpp \
cheats.cpp \
cheats2.cpp \
clip.cpp \
controls.cpp \
cpu.cpp \
cpuexec.cpp \
cpuops.cpp \
dma.cpp \
dsp.cpp \
dsp1.cpp \
dsp2.cpp \
dsp3.cpp \
dsp4.cpp \
fxemu.cpp \
fxinst.cpp \
gfx.cpp \
globals.cpp \
loadzip.cpp \
memmap.cpp \
msu1.cpp \
movie.cpp \
obc1.cpp \
ppu.cpp \
stream.cpp \
sa1.cpp \
sa1cpu.cpp \
sdd1.cpp \
sdd1emu.cpp \
seta.cpp \
seta010.cpp \
seta011.cpp \
seta018.cpp \
snapshot.cpp \
spc7110.cpp \
srtc.cpp \
tile.cpp \
apu/apu.cpp \
apu/bapu/dsp/sdsp.cpp \
apu/bapu/dsp/SPC_DSP.cpp \
apu/bapu/smp/smp.cpp \
apu/bapu/smp/smp_state.cpp
# conffile.cpp crosshairs.cpp logger.cpp screenshot.cpp snes9x.cpp

SRC += \
main/Main.cc \
main/input.cc \
main/options.cc \
main/S9XApi.cc \
main/EmuControls.cc \
main/EmuMenuViews.cc \
main/Cheats.cc \
$(addprefix $(snes9xPath)/,$(snes9xSrc))

ifdef RELEASE
# TODO: On Android, strong symbols will not override weak
# ones in EmuFramework when Snes9x is not compiled with
# LTO and Emuframework is. Possible linker bug?
$(objDir)/main/Main.o $(objDir)/main/S9XApi.o $(objDir)/main/Cheats.o $(objDir)/main/EmuControls.o $(objDir)/main/EmuMenuViews.o : CXXFLAGS += -flto
endif

include $(EMUFRAMEWORK_PATH)/package/emuframework.mk
include $(IMAGINE_PATH)/make/package/zlib.mk

include $(IMAGINE_PATH)/make/imagineAppTarget.mk

endif
