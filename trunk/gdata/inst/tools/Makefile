 # Global Config Variables
R_PACKAGE_DIR ?= $(PWD)/../inst
PERL_PREFIX = $(R_PACKAGE_DIR)/perl
BIN_PREFIX  = $(R_PACKAGE_DIR)/bin

# Names of packages to install, ordered according to dependencies
packages = IO-stringy \
	   Spreadsheet-ParseExcel \
	   OLE-Storage_Lite

TGZ  = $(foreach file,$(packages), $(wildcard $(file)*.tar.gz))
DIRS =  $(subst .tar.gz,,$(TGZ))
PERLVER  = $(strip $(word 2, $(subst ;, ,$(subst =, ,$(shell perl -V:version)))))
PERLMAJOR = $(strip $(word 2, $(subst ;, ,$(subst =, ,$(shell perl -V:revision)))))
REL_PERL_LIB = lib/perl$(PERLMAJOR)/site_perl/$(PERLVER)
PERL_LIB = $(PERL_PREFIX)/$(REL_PERL_LIB)


default: install

basedir:
	@mkdir -p $(PERL_LIB) 

%:%.tar.gz basedir
	@echo -- Installing PERL module $< --
	@echo INCLUDE DIRS = $(PERL_LIB)
	tar -xzf $<	
	cd $@ ; \
	perl -I $(PERL_LIB) Makefile.PL PREFIX=${PERL_PREFIX}
	@${MAKE} -C $@ PERL_LIB=$(PERL_LIB)
	@${MAKE} -C $@ PERL_LIB=$(PERL_LIB) test
	@${MAKE} -C $@ PERL_LIB=$(PERL_LIB) install

test: $(TGZ)
	perl -I $(PERL_LIB) xls2csv.pl iris.xls iris.csv 1
	diff -bBw iris.csv.save iris.csv

cleanup:
	@echo -- Removing local sources --
	-rm -rf $(DIRS)
	-rm -f iris.csv
	-rm xls2csv

clean: cleanup
	-rm -rf $(PERL_PREFIX)
	-rm -rf $(BIN_PREFIX)

xls2csv: xls2csv.in
	sed -e 's|@REL_PERL_LIB@|$(REL_PERL_LIB)|' xls2csv.in  > xls2csv

show:	
	@echo R_PACKAGE_DIR=$(R_PACKAGE_DIR)
	@echo PERL_PREFIX=$(R_PACKAGE_DIR)/perl
	@echo BIN_PREFIX=$(BIN_PREFIX)
	@echo PERLVER=$(PERLVER)
	@echo PERLMAJOR=$(PERLMAJOR)
	@echo PERL_LIB=$(PERL_LIB)


build: basedir $(DIRS) 

install_bin: xls2csv 
	mkdir -p $(BIN_PREFIX)
	install xls2csv $(BIN_PREFIX)/
	install xls2csv.pl $(PERL_PREFIX)/

install: build cleanup install_bin cleanup show
	touch gregmisc.so
