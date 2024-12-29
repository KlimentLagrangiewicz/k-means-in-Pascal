TARGET      = based-k-means

PC          = fpc

SRCDIR      = src

CFLAGS      = -O3


.PHONY: all
all: remove $(TARGET) clean

$(TARGET):
	$(PC) $(SRCDIR)/main.pas $(CFLAGS) -o./$(TARGET)

windows: remove build_win clean

build_win:
	$(PC) $(BINDIR)/main.pas -o./$(TARGET).exe

clean:
	rm -f -f ./*.ppu ./*.o
	
remove:
	rm -f ./*.ppu ./*.o $(TARGET) $(TARGET).exe