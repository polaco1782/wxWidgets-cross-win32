# Should be equivalent to your list of C files, if you don't build selectively

CXX = i686-w64-mingw32-g++
CC = i686-w64-mingw32-gcc
WINDRES = i686-w64-mingw32-windres
STRIP = i686-w64-mingw32-strip

# if you dont want a static binary, remove this flag.
# NOTE: you will need each dependency DLL included with the executable.
LDFLAGS = -static
CXXFLAGS = -O3 -s

CXXFLAGS += -I./lib/wx/include/i686-w64-mingw32-msw-unicode-static-3.1 \
            -I./include/wx-3.1 -I./include -D_FILE_OFFSET_BITS=64 -D__WXMSW__ -mthreads

LDFLAGS += -L./lib -Wl,--subsystem,windows -mwindows \
             ./lib/libwx_mswu-3.1-i686-w64-mingw32.a \
             -lwxtiff-3.1-i686-w64-mingw32 \
             -lwxjpeg-3.1-i686-w64-mingw32 \
             -lwxpng-3.1-i686-w64-mingw32 \
             -lwxregexu-3.1-i686-w64-mingw32 \
             -lwxscintilla-3.1-i686-w64-mingw32 \
             -lwxexpat-3.1-i686-w64-mingw32 \
             -lwxzlib-3.1-i686-w64-mingw32 \
             -lrpcrt4 \
             -loleaut32 \
             -lole32 \
             -luuid \
             -luxtheme \
             -lwinspool \
             -lwinmm \
             -lshell32 \
             -lshlwapi \
             -lcomctl32 \
             -lcomdlg32 \
             -ladvapi32 \
             -lversion \
             -lwsock32 \
             -lgdi32 \
             -loleacc \
             -lsqlite3

SRC = $(wildcard *.cpp)
OBJ = $(patsubst %.cpp,obj/%.o,$(wildcard *.cpp))
OBJ += $(patsubst %.c,obj/%.o,$(wildcard *.c))
OBJ += $(patsubst %.rc,obj/%.o,$(wildcard *.rc))

obj/%.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS)

obj/%.o: %.c
	$(CC) -c -o $@ $< $(CXXFLAGS)

obj/%.o : %.rc
	$(WINDRES) -O coff -o $@ $< -I./include/wx-3.1

Example.exe: $(OBJ)
	$(CXX) -o $@ $^ $(CXXFLAGS) $(LDFLAGS)

.PHONY: clean test compress

compress:
	upx -9 Example.exe

clean:
	rm -f obj/*.o Example.exe

test:
	wine Example.exe
