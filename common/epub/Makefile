
# Dirs to build
# LW #1 to #28 (English)
# GS #1 to #4
# FW #1
ENGLISH_DIRS := 01fftd 02fotw 03tcok 04tcod 05sots 06tkot 07cd 08tjoh \
	09tcof 10tdot 11tpot 12tmod 13tplor 14tcok 15tdc 16tlov 17tdoi \
	18dotd 19wb 20tcon 21votm 22tbos 23mh 24rw  25totw 26tfobm \
	27v 28thos 29tsoc 01gstw  02tfc  03btng  04wotw 01hh

# LS #1 to #12  (Spanish)
SPANISH_DIRS := 01hdlo 02fsea 03lcdk 04eam 05eddls 06lpdlc 07meec \
	08ljdlh 09ecdm 10lmdt 11pdt 12lsdlo 13lsdlpdr
#
# Unpublished (spanish) books:
# 14lcdk 16eldv

DIRS = $(ENGLISH_DIRS) $(SPANISH_DIRS)

DIRS-install := $(addsuffix -install,$(DIRS))
DIRS-clean := $(addsuffix -clean,$(DIRS))
DIRS-distclean := $(addsuffix -distclean,$(DIRS))

.SUFFIXES:
.PHONY: install publish all clean $(DIRS) $(DIRS-install)

all: $(DIRS)
all-english: $(ENGLISH_DIRS)
all-spanish: $(SPANISH_DIRS)

publish: install
install: $(DIRS-install)
clean: $(DIRS-clean)
distclean: $(DIRS-distclean)

$(DIRS-install):
	$(MAKE) -C $(subst -install,,$@) install

$(DIRS-clean):
	$(MAKE) -C $(subst -clean,,$@) clean

$(DIRS-distclean):
	$(MAKE) -C $(subst -distclean,,$@) distclean

$(DIRS):
	$(MAKE) -C $@
