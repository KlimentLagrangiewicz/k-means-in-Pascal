TARGET      = based-k-means

PC          = fpc

SRCDIR      = src
BINDIR      = bin

CFLAGS      = -O4 -Xs


.PHONY: all
all: remove $(TARGET) clean

$(TARGET): $(BINDIR)
	$(PC) $(SRCDIR)/main.pas $(CFLAGS) -o./$(BINDIR)/$(TARGET)

windows: remove build_win clean

build_win: $(BINDIR)
	$(PC) $(SRCDIR)/main.pas -o./$(BINDIR)/$(TARGET).exe

$(BINDIR):
	mkdir -p $@

clean:
	$(RM) -rf $(BINDIR)/*.ppu $(BINDIR)/*.o

remove:
	$(RM) -rf $(BINDIR)/*.ppu $(BINDIR)/*.o $(BINDIR)/$(TARGET) $(BINDIR)/$(TARGET).exe $(BINDIR)