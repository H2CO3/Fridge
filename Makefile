TARGET = Fridge
OBJECTS = $(patsubst %.m, %.o, $(wildcard *.m))
SYSROOT = /Developer/Platforms/iPhoneOS.platform/SDKs/iPhoneOS4.2.sdk
DEST = /Applications/$(TARGET).app

CC = gcc
LD = $(CC)
RM = rm
CP = cp
CODESIGN = ldid -S
CFLAGS = -isysroot $(SYSROOT) -Wall -Os -c
LDFLAGS = -isysroot $(SYSROOT) -w -lobjc -lipodimportclient -framework Foundation -framework UIKit
RMFLAGS = -rf
CPFLAGS = -r

all: $(TARGET)

clean:
	$(RM) $(RMFLAGS) *~ *.o $(TARGET)

install: all
	$(CP) $(CPFLAGS) $(TARGET) $(DEST)/

$(TARGET): $(OBJECTS)
	$(RM) $(RMFLAGS) $(TARGET) /Applications/$(TARGET).app/$(TARGET)
	$(LD) $(LDFLAGS) -o $@ $^
	$(CODESIGN) $@

%.o: %.m
	$(CC) $(CFLAGS) $^

%.o: %.c
	$(CC) $(CFLAGS) $^

.PHONY: all clean install
