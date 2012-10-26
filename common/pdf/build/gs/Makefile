
# Dirs to build
# GS #1 to #18 (English)
ENGLISH_DIRS := 01gstw 02tfc 03btng 04wotw

# No translations yet:
#SPANISH_DIRS := 

DIRS = $(ENGLISH_DIRS) 

DIRS-install := $(addsuffix -install,$(DIRS))
DIRS-clean := $(addsuffix -clean,$(DIRS))
DIRS-distclean := $(addsuffix -distclean,$(DIRS))

.SUFFIXES:
.PHONY: install all clean $(DIRS) $(DIRS-install)

all: $(DIRS)
all-english: $(ENGLISH_DIRS)
#all-spanish: $(SPANISH_DIRS)

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
