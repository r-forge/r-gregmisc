# Global Config Variables
# Paths
R_PACKAGE_DIR ?= /tmp/gregmisc/
PERL_PREFIX = $(R_PACKAGE_DIR)/perl
BIN_PREFIX  = $(R_PACKAGE_DIR)/bin

PERL_LIB=$(PERL_PREFIX)

# Executables 
INSTALL=$(R_HOME)/bin/mkinstalldirs
CP=install
###

# Names of packages to install, ordered according to dependencies
packages = IO-stringy \
	   Spreadsheet-ParseExcel \
	   OLE-Storage_Lite

TGZ  =	IO-stringy-2.109.tar.gz \
	OLE-Storage_Lite-0.11.tar.gz \
	Spreadsheet-ParseExcel-0.2602.tar.gz

DIRS =  $(subst .tar.gz,,$(TGZ))

PERLVARS =  PERL_PREFIX=$(PERL_PREFIX) \
	    PERLPREFIX=$(PERL_PREFIX) \
	    PERL_LIB=${PERL_LIB} \
	    PERL5LIB=${PERL_LIB} \
	    PREFIX=${R_PACKAGE_DIR} \
	    SITEPREFIX=$(R_PACKAGE_DIR)/perl \
	    SITELIBEXP=${PERL_PREFIX} \
	    SITEARCHEXP=${PERL_PREFIX} \
	    INSTALLBIN=${R_PACKAGE_DIR}/bin \
	    INSTALLSCRIPT=${R_PACKAGE_DIR}/bin \
	    INSTALLPRIVLIB=${PERL_PREFIX} \
	    INSTALLSITELIB=${PERL_PREFIX} \
	    INSTALLMAN1DIR=${PERL_PREFIX}/man \
	    INSTALLMAN3DIR=${PERL_PREFIX}/man/man3

default: install

basedir:
	@mkdir -p $(R_PACKAGE_DIR) 
	@mkdir -p $(PERL_PREFIX)
	@mkdir -p $(BIN_PREFIX)

%:%.tar.gz basedir
	@echo -- Installing PERL module $< --
	tar -xzf $<	
	cd $@ ; \
	perl -I$(PERL_LIB) Makefile.PL $(PERL_VARS)
	${MAKE} -C $@ $(PERLVARS)
	${MAKE} -C $@ $(PERLVARS) test    
	${MAKE} -C $@ $(PERLVARS) install
	rm -rf $@ # clean up after ourselves

test: $(TGZ)
	perl -I$(PERL_LIB) xls2csv.pl iris.xls iris.csv 1
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
	#$(ENV)
	@echo R_PACKAGE_DIR=$(R_PACKAGE_DIR)
	@echo BIN_PREFIX=   $(BIN_PREFIX)
	@echo PERL_PREFIX=  $(PERL_PREFIX)
	@echo INCLUDE DIRS = $(PERL_LIB)
	@echo NMAKE=        $(NMAKE)
	@echo ----------------------------
	@echo END of ENVIRONMENT VARIABLES
	@echo ----------------------------


xls2csv.pl: xls2csv.pl.in Makefile
	# Set explicit path to libaries
	perl -p -e 's|# use lib ".";|use lib "$(PERL_PREFIX)";|' \
            xls2csv.pl.in > xls2csv.pl

xls2csv.bat: xls2csv.bat.in Makefile
	# Set explicit path to perl script
	perl -p -e 's|../perl|$(PERL_PREFIX)|' xls2csv.bat.in > xls2csv.bat

xls2csv: xls2csv.in Makefile
	# Set explicit path to perl script
	perl -p -e 's|../perl|$(PERL_PREFIX)|' xls2csv.in > xls2csv

build: basedir $(DIRS) 

install_bin: xls2csv.pl xls2csv.bat xls2csv
	$(INSTALL) $(BIN_PREFIX)
	$(CP) xls2csv $(BIN_PREFIX)/
	$(CP) xls2csv.pl $(PERL_PREFIX)/

install: show clean build install_bin clean
	touch gregmisc.so
