# Global Config Variables
# Paths
ifeq ($(OS),Windows_NT)
  # Windows wants the buid to take place in the source dir
  TARGET_DIR  = $(shell pwd)/../inst
else
  # *nix wants it to take place in the target dir
  R_PACKAGE_DIR ?= $(shell pwd)/../inst
  TARGET_DIR  = $(R_PACKAGE_DIR)/
endif

PERL_PREFIX = $(TARGET_DIR)/perl
BIN_PREFIX  = $(TARGET_DIR)/bin
PERL_LIB    = $(PERL_PREFIX)


# Executables 
ifeq ($(OS),Windows_NT)
  INSTALL=mkdir -p
  CP=cp
  MAKE=MAKEFLAGS='' NMAKE
  ENV=set
else
  INSTALL=$(R_HOME)/bin/mkinstalldirs
  CP=install
  ENV=env
endif

# Names of packages to install, ordered according to dependencies
packages = IO-stringy \
	   Spreadsheet-ParseExcel \
	   OLE-Storage_Lite

TGZ  =	IO-stringy-2.109.tar.gz \
	OLE-Storage_Lite-0.11.tar.gz \
	Spreadsheet-ParseExcel-0.2602.tar.gz

DIRS =  $(subst .tar.gz,,$(TGZ))

PERLDIRS =  PERL_PREFIX='$(PERL_PREFIX)' \
	    PERLPREFIX='$(PERL_PREFIX)' \
	    PERL_LIB='$(PERL_LIB)' \
	    PERL5LIB='$(PERL_LIB)' \
	    PREFIX='$(TARGET_DIR)' \
	    SITEPREFIX='$(TARGET_DIR)/perl' \
	    SITELIBEXP='$(PERL_PREFIX)' \
	    SITEARCHEXP='$(PERL_PREFIX)' \
	    INSTALLBIN='$(TARGET_DIR)/bin' \
	    INSTALLSCRIPT='$(TARGET_DIR)/bin' \
	    INSTALLPRIVLIB='$(PERL_PREFIX)' \
	    INSTALLSITELIB='$(PERL_PREFIX)' \
	    INSTALLMAN1DIR='$(PERL_PREFIX)/man' \
	    INSTALLMAN3DIR='$(PERL_PREFIX)/man/man3'

ifeq ($(OS),Windows_NT)
  # Calls to Windows code needs the Windows form of paths
  PERLVARS = $(subst /,\, $(subst /cygdrive/c,C:\,$(PERLDIRS)))	
  PERL_INC = $(subst /,\, $(subst /cygdrive/c,C:\,$(PERL_LIB)))
else
  PERLVARS = $(PERLDIRS)
  PERL_INC=$(PERL_LIB)
endif


default: install

basedir:
	@mkdir -p '$(TARGET_DIR)' 
	@mkdir -p '$(PERL_PREFIX)'
	@mkdir -p '$(BIN_PREFIX)'

%:%.tar.gz basedir
	@echo -- Installing PERL module $< --
	tar -xzf $<	
	cd $@ ;	perl -I'$(PERL_INC)' Makefile.PL 
	cd $@ ; $(MAKE)              $(PERLVARS)
	cd $@ ; $(MAKE) test         $(PERLVARS)
	cd $@ ; $(MAKE) install_site $(PERLVARS)
	rm -rf $@ # clean up after ourselves

test: $(TGZ)
	perl -I'$(PERL_INC)' xls2csv.pl iris.xls iris.csv 1
	diff -bBw iris.csv.save iris.csv

clean:
	-rm -rf $(PERL_PREFIX)
	-rm -rf $(BIN_PREFIX)
	-rm -rf $(DIRS)
	-rm -f gregmisc.dll gregmisc.so
	-rm -f xls2csv xls2csv.bat xls2csv.pl
	-rm -f *~ 
	-rm -f *.csv

show:	
	@echo ------------------------------
	@echo START of ENVIRONMENT VARIABLES
	@echo ------------------------------
	$(ENV)
	@echo ------------------------------
	@echo TARGET_DIR=$(TARGET_DIR)
	@echo BIN_PREFIX=$(BIN_PREFIX)
	@echo PERL_PREFIX=$(PERL_PREFIX)
	@echo PERL_LIB=$(PERL_LIB)
	@echo MAKE=$(NMAKE)
	@echo ------------------------------
	@echo PERLVARS=$(PERLVARS)
	@echo ----------------------------
	@echo END of ENVIRONMENT VARIABLES
	@echo ----------------------------


xls2csv.pl: xls2csv.pl.in
	$(CP) xls2csv.pl.in xls2csv.pl

xls2csv.bat: xls2csv.bat.in
	$(CP) xls2csv.bat.in xls2csv.bat

xls2csv: xls2csv.in
	$(CP) xls2csv.in xls2csv

build: basedir $(DIRS) 

install_bin: xls2csv.pl xls2csv.bat xls2csv
	$(INSTALL) '$(BIN_PREFIX)'
ifeq ($(OS),Windows_NT)
	$(CP) xls2csv.bat '$(BIN_PREFIX)/'
else
	$(CP) xls2csv '$(BIN_PREFIX)/'
endif
	$(CP) xls2csv.pl '$(PERL_PREFIX)/'

install: clean build install_bin
	touch gregmisc.so
