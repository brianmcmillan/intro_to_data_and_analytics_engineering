# ~/projects/sales/makefile
# Execute the data pipeline for a project.
#
# make all                  Executes the default make task.
# make info                 Generates the informational files.
# make check                Executes all test suites.
# make installcheck         Run the project test suite.
# make install              Builds the database and application structure.
# make uninstall            Uninstalls the project.
# make run                  Executes the data pipelines.
# make help                 List of all makefile tasks.
# make documentation        Builds the documentation files for the build. (e.g. schema docs, data flow diagrams)
# make uninstalldirs        Removes the project directories. "make uninstall"
# make installcheck         Run the installation test suite.
#
##############################################################
# Program locations (which <utility>)
SHELL := /bin/bash
SQLITE3 := /usr/local/bin/sqlite3
SPLIT := /usr/local/bin/gsplit
TREE := /usr/local/bin/tree
GRAPHVIZDOT := /usr/local/bin/dot
GCLOUD := /Users/brianmcmillan/google-cloud-sdk/bin/gcloud
PYENVDIR := /Users/brianmcmillan/.pyenv/shims
PYTHON3 := $(PYENVDIR)/python
PIP := $(PYENVDIR)/pip
IN2CSV := $(PYENVDIR)/in2csv
SQL2CSV := $(PYENVDIR)/sql2csv
CSVSTACK := $(PYENVDIR)/csvstack
CSVSQL := $(PYENVDIR)/csvsql
SQLITEUTILS := $(PYENVDIR)/sqlite-utils
NODEGRAPH := $(PYENVDIR)/makefile2dot
DATASETTE := $(PYENVDIR)/datasette
ERALCHEMY := $(PYENVDIR)/eralchemy

# Project directory paths
ROOTDIR := "$(shell pwd)"
PROJECTDIR := $(ROOTDIR)
PROJECTNAME := $(notdir $(ROOTDIR))
# /etc
SYSCONFIGDIR := $(PROJECTDIR)/etc
APPCONFIGDIR := $(PROJECTDIR)/etc/app
SCHEDULECONFIGDIR := $(PROJECTDIR)/etc/cron
SERVERCONFIGDIR := $(PROJECTDIR)/etc/server
SQLDIR := $(PROJECTDIR)/etc/sql
TESTSDIR := $(PROJECTDIR)/etc/test
# /opt
OPTIONALPKGDIR := $(PROJECTDIR)/opt
LOCALDEPLOYMENTDIR := $(PROJECTDIR)/opt/local
PYTHONSCRIPTS := $(PROJECTDIR)/opt/python
LOCALSQLITE3 := $(PROJECTDIR)/opt/sqlite3
# /src
SOURCEDIR := $(PROJECTDIR)/src
SQLITESRCDIR := $(PROJECTDIR)/src/sqlite3
# /srv
SERVICEDIR := $(PROJECTDIR)/svc
CUSTOMERFILEDIR := $(PROJECTDIR)/svc/source
LOADFILEDIR := $(PROJECTDIR)/svc/load
STATICFILEDIR := $(PROJECTDIR)/svc/static
DOCUMENTATIONDIR := $(PROJECTDIR)/svc/doc
DATABASEDIR := $(PROJECTDIR)/svc/db
# /tmp /var
TEMPSTATEDIR := $(PROJECTDIR)/tmp
LOCALSTATEDIR := $(PROJECTDIR)/var
PROJECTLOGDIR := $(LOCALSTATEDIR)/log
# Project files
DBNAME := $(PROJECTNAME).db
DBFILE := $(DATABASEDIR)/$(PROJECTNAME).db
LOGFILE := $(PROJECTLOGDIR)/$(PROJECTNAME).log

# Utility variables
DTS = $(shell date +%Y-%m-%dT%H:%M:%S-%Z)
LIST_CSV = $(shell find $(dir $@) -type f -name '*.csv' -not -name 'load.csv')

# Deployment variables
LOCAL_ADDRESS := $(shell /usr/sbin/ipconfig getifaddr en0) #192.168.1.251
LOCAL_PORT := 8001
GCLOUD_URL := https://sales-5keoceam4q-uc.a.run.app #UNKNOWN until first run.

# Macros
define test_dir
	# tests the directory in the <first dependency>
	if ! test -d $<; \
	then echo $(DTS)    [FAIL] - $< does not exist; \
	else true; fi
endef

define test_file
	# tests the file in the <first dependency>
	if ! test -s $@; \
	then echo $(DTS)    [FAIL] - $@ does not exist; \
	else true; fi
endef

define test_dependent_file
	# tests the file in the <first dependency>
	if ! test -s $<; \
	then echo $(DTS)    [FAIL] - $< does not exist; \
	else true; fi
endef

define test_table
	@#test_table/<table_name>(colon)
	@if ! test $(@F) = $(shell $(SQLITE3) $(DBFILE) ".tables $(@F)" ".quit"); \
	then echo [FAIL] - $(@F) table does not exist; \
	else true; fi
endef

define test_database
	@#test/<database name.db>(colon)(space)<path/to/database.db>
	@echo $(DTS)    [INFO] - DB $(shell $(SQLITE3) $< ".databases")
endef

define file_compare
	@#<target>(colon)(space)<file_1> <file_2>
	@cmp -s $(word 1,$^) $(word 2,$^) || \
	echo $(DTS)    [FAIL] - $(word 2,$^) not equal to $(word 1,$^).
endef

define record_count_csv
	@#metrics/<csv_file.csv>(colon)(space)PATH = "<path/to/file.csv>"
	@#metrics/<csv_file.csv>(colon)(space)
	@echo $(DTS)     [INFO] - record count = $(shell wc -l < $(PATH)) $(PATH)
endef

define record_count_table
	@#record_count/<table name>(colon)(space)
	@echo $(DTS)     [INFO] - record count = $(shell $(SQLITE3) $(DBFILE) \
	"SELECT COUNT(*) || ' records in $(@F).$(notdir $(DBFILE))' FROM [$(@F)]" ".quit")
endef

define update_file_modified_date
	@#touch_src/<generalized_file_identifier>(colon)(space)<path/to/file.xyz>
	@touch $^ && echo [INFO] - Manually updating [$^] file date.
endef

define extract_csv_from_excel
	@#<path/to/csv_file.csv>(colon)(space)TABNAME = "<name of XLS worksheet>"
	@#<path/to/csv_file.csv>(colon)(space)<path/to/source/excel_file.xlsx>
	@echo $(DTS)     [INFO] - Extracting data from $< [$(TABNAME)] into $@
	@$(IN2CSV) -f xlsx --sheet $(TABNAME) $< > $@
	@$(CSVSTACK) -n load_dts -g $(DTS) $@ > $(TEMPSTATEDIR)/$(@F)_1.tmp
	@$(CSVSTACK) -n provider_code -g $@ $(TEMPSTATEDIR)/$(@F)_1.tmp > $(TEMPSTATEDIR)/$(@F)_2.tmp
	@mv $(TEMPSTATEDIR)/$(@F)_2.tmp $@
	@rm $(TEMPSTATEDIR)/$(@F)_1.tmp
	@$(test_file)
endef

define execute_sql_export_csv
	@#<path/to/export_file.csv>(colon)(space)<path/to/query.sql>
	@echo $(DTS)     [INFO] - Executing $< and exporting to $@
	@$(SQL2CSV) --db sqlite:///$(DBFILE) $< > $@
endef

define load_csv_into_database
	@#load_csv/SRC_<csv_file_name>_001(colon)(space)<path/to/csv_file.csv>
	@echo $(DTS)     [INFO] - Loading data from $< into $(@F).$(DBNAME)
	@$(CSVSQL) \
	--db sqlite:///$(DBFILE) \
	--create-if-not-exists --overwrite \
	--no-inference --no-constraints \
	--chunk-size 10000 \
	--tables $(@F) \
	--insert $<
endef

define create_table
	@#<table_name>(colon)(space)<path/to/<table_name>_create.sql>
	@echo $(DTS)    [INFO] - Creating table $@
	@$(SQLITE3) $(DBFILE) ".read $<" ".quit"
endef

define execute_sql
	@#<table_name>(colon)(space) <path/to/sql_file.sql> [<dependent_table_name(s)>]
	@echo $(DTS)    [INFO] - Executing $<
	@$(SQLITE3) $(DBFILE) ".read $<" ".quit"
endef

define vega_report_from_api
	@#<path/to/export_file.html>(colon)(space)VIZTITLE=<report title>
	@#<path/to/export_file.html>(colon)(space)VIZTEMPLATE=<path/to/viz_template.vega>
	@#<path/to/export_file.html>(colon)(space)VIZURL=<path/to/viz_url.json?_shape=array>
	@#<path/to/export_file.html>(colon)(space)<source_table_name>
	@echo $(DTS)     [INFO] - Executing $@
	@cat etc/app/vega_embed_header.viz > $@
	@echo "\"data\":{\"url\":\"$(VIZURL)\"}, " >> $@
	@echo "\"title\":\"$(VIZTITLE)\"," >> $@
	@cat $(VIZTEMPLATE) >> $@
	@cat etc/app/vega_embed_footer.viz >> $@
endef

define vega_report_from_file
	@#<path/to/export_file.html>(colon)(space)VIZTITLE=<report title>
	@#<path/to/export_file.html>(colon)(space)VIZTEMPLATE=<path/to/viz_template.vega>
	@#<path/to/export_file.html>(colon)(space)<source_file_name>
	@echo $(DTS)     [INFO] - Executing $@
	@cat etc/app/vega_embed_header.viz > $@
	@echo "\"data\":{ \"values\":" >> $@
	@cat $< >> $@ && echo "}, " >> $@
	@echo "\"title\":\"$(VIZTITLE)\"," >> $@
	@cat $(VIZTEMPLATE) >> $@
	@cat etc/app/vega_embed_footer.viz >> $@
endef

###############################################################################
all: run documentation ## Executes the default make task.
info: help info/variables test/dirs test/solution_files documentation ## Generates the informational files.
check: test/outputs test/tables test/db metrics ## Executes all test suites.
installcheck: test/dirs test/inputs test/solution_files test/db ## Run the project test suite.
install: test/db test/tables ## Builds the database and application structure.
uninstall: uninstalldirs ## Uninstalls the project.
run: test/inputs extract transform test/tables test/outputs metrics compact_database ## Executes the data pipelines.

.PHONY: help documentation uninstalldirs installcheck .FORCE log_rotate compact_database

.FORCE:

help: ## List of all makefile tasks.
	@echo $(DTS)    [INFO] - Executing $@.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "};\
	{printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

documentation: run META_TABLES_001 ## Builds the documentation files for the build. (e.g. schema docs, data flow diagrams)
	@echo $(DTS)    [INFO] - Executing $@.
	@$(TREE) --prune > $(DOCUMENTATIONDIR)/directory_listing.txt
	@$(NODEGRAPH) --direction LR | $(GRAPHVIZDOT) -Tpng > $(DOCUMENTATIONDIR)/makefile_graph.png

META_TABLES_001:
	@$(SQLITE3) $(DBFILE) "DROP TABLE IF EXISTS '_analyze_tables_';" ".quit"
	@$(SQLITE3) $(DBFILE) "DROP TABLE IF EXISTS 'META_TABLES_001';" ".quit"
	@$(SQLITEUTILS) analyze-tables $(DBFILE) --save
	@$(SQLITE3) $(DBFILE) "ALTER TABLE '_analyze_tables_' RENAME TO 'META_TABLES_001';" ".quit"

er_diagrams: svc/doc/raw_tables.pdf svc/doc/information_tables.pdf svc/doc/business_tables.pdf svc/doc/meta_tables.pdf
	@echo $(DTS)    [INFO] - Executing $<
	@$(ERALCHEMY) -i sqlite:///$(DBFILE) -o etc/app/er_tables.er

svc/doc/raw_tables.pdf:
	@$(ERALCHEMY) -i sqlite:///$(DBFILE) -o $@ --include-tables \
	SRC_online_retail_II_-_Year_2010-2011_002 \
	RAW_ONLINE_RETAIL_II_YEAR_2010_2011_001 \
	SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001

svc/doc/information_tables.pdf:
	@$(ERALCHEMY) -i sqlite:///$(DBFILE) -o $@ --include-tables \
	INFO_WEEKLY_TOP_SALES_RANK_002

svc/doc/meta_tables.pdf:
	@$(ERALCHEMY) -i sqlite:///$(DBFILE) -o $@ --include-tables \
	META_TABLES_001

svc/doc/business_tables.pdf: tmp/er_business.er
	@$(ERALCHEMY) -i $< -o $@
	@rm -f $^

tmp/er_business.er: tmp/er_business_tables.er etc/app/er_business_relationships.txt
		@cat $^ > $@

etc/app/er_business_relationships.txt:
	@$(test_file)

tmp/er_business_tables.er:
	@$(ERALCHEMY) -i sqlite:///$(DBFILE) -o $@ --include-tables \
	BHUB_INVOICE_CODES_001 \
	BHUB_STOCK_CODES_001 \
	BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001 \
	BSAT_INVOICES_001

uninstalldirs: uninstall/online_retail_II uninstall/local uninstall/gcloud ## Removes the project directories. "make uninstall"
	@echo $(DTS)    [INFO] - Executing $@.
	@rm -f svc/db/*
	@rm -f svc/doc/*
	@rm -f svc/load/*
	@rm -f svc/static/*

installcheck: ## Run the installation test suite.
	@echo $(DTS)    [INFO] - Executing $@.

log_rotate:
	@echo $(DTS)    [INFO] - Executing $@
	@mv $(PROJECTLOGDIR)/cron_log.txt $(PROJECTLOGDIR)/cron_log_$(shell date +%Y-%m-%d).txt

compact_database:
	@$(SQLITE3) $(DBFILE) "PRAGMA optimize;" && echo $(DTS)    [INFO] - Optimizing database
	@$(SQLITE3) $(DBFILE) "PRAGMA vacuum;" && echo $(DTS)    [INFO] - Vacuuming database
	@$(SQLITE3) $(DBFILE) "PRAGMA integrity_check;" && echo $(DTS)    [INFO] - Performing integrity check

.PHONY: template/src_from_csv
template/src_from_csv: ## Create source table from CSV template.
	@#make template/src_from_csv CSVPATH=<path/to/file.csv>
	@echo $(DTS)    [INFO] - Creating script for SRC_$(notdir $(basename $(CSVPATH)))_###_create from $(CSVPATH)
	@if test -s $(CSVPATH); then echo [PASS] - $(CSVPATH) file exists; \
	else echo [FAIL] - $(CSVPATH) file does not exist; fi
	@$(SQLITE3) tmp/temp.db ".import --csv $(CSVPATH) SRC_$(notdir $(basename $(CSVPATH)))_###"
	@$(SQLITE3) tmp/temp.db ".schema SRC_$(notdir $(basename $(CSVPATH)))_###"
	@echo "--etc/sql/SRC_$(notdir $(basename $(CSVPATH)))_###_create.sql" \
	> etc/sql/SRC_$(notdir $(basename $(CSVPATH)))_###_create.sql
	@echo "-------------------------------------------------------------------------------" \
	>> etc/sql/SRC_$(notdir $(basename $(CSVPATH)))_###_create.sql
	@$(SQLITE3) tmp/temp.db ".schema SRC_$(notdir $(basename $(CSVPATH)))_###" \
	>> etc/sql/SRC_$(notdir $(basename $(CSVPATH)))_###_create.sql
	@rm tmp/temp.db

.PHONY: info/variables
info/variables: ## List the variables in the makefile.
	@echo $(DTS)    [INFO] - Executing $@.
	@echo "-- Program paths ----------------------------------------------------"
	@echo SHELL = $(SHELL)
	@echo SQLITE3 = $(SQLITE3)
	@echo GRAPHVIZDOT = $(GRAPHVIZDOT)
	@echo SPLIT = $(SPLIT)
	@echo TREE = $(TREE)
	@echo GCLOUD = $(GCLOUD)
	@echo PYENVDIR = $(PYENVDIR)
	@echo PYTHON3 = $(PYTHON3)
	@echo PIP = $(PIP)
	@echo IN2CSV = $(IN2CSV)
	@echo CSVSTACK = $(CSVSTACK)
	@echo CSVSQL = $(CSVSQL)
	@echo SQLITEUTILS = $(SQLITEUTILS)
	@echo DATASETTE = $(DATASETTE)
	@echo NODEGRAPH = $(NODEGRAPH)
	@echo ERALCHEMY = $(ERALCHEMY)
	@echo "-- Configuration paths (/etc) ---------------------------------------"
	@echo SYSCONFIGDIR = $(SYSCONFIGDIR)
	@echo APPCONFIGDIR = $(APPCONFIGDIR)
	@echo SCHEDULECONFIGDIR = $(SCHEDULECONFIGDIR)
	@echo SERVERCONFIGDIR = $(SERVERCONFIGDIR)
	@echo SQLDIR = $(SQLDIR)
	@echo TESTSDIR = $(TESTSDIR)
	@echo "-- Optional packages / deployment paths (/opt) ----------------------"
	@echo OPTIONALPKGDIR = $(OPTIONALPKGDIR)
	@echo LOCALDEPLOYMENTDIR = $(LOCALDEPLOYMENTDIR)
	@echo PYTHONSCRIPTS = $(PYTHONSCRIPTS)
	@echo LOCALSQLITE3 = $(LOCALSQLITE3)
	@echo "-- Source code paths (/src) -----------------------------------------"
	@echo SOURCEDIR = $(SOURCEDIR)
	@echo SQLITESRCDIR = $(SQLITESRCDIR)
	@echo "-- Services paths (/svc) --------------------------------------------"
	@echo SERVICEDIR = $(SERVICEDIR)
	@echo CUSTOMERFILEDIR = $(CUSTOMERFILEDIR)
	@echo LOADFILEDIR = $(LOADFILEDIR)
	@echo STATICFILEDIR = $(STATICFILEDIR)
	@echo DOCUMENTATIONDIR = $(DOCUMENTATIONDIR)
	@echo DATABASEDIR = $(DATABASEDIR)
	@echo "-- Temporary storage paths (/tmp /var) ------------------------------"
	@echo TEMPSTATEDIR = $(TEMPSTATEDIR)
	@echo LOCALSTATEDIR = $(LOCALSTATEDIR)
	@echo PROJECTLOGDIR = $(PROJECTLOGDIR)
	@echo "-- Project directory paths ------------------------------------------"
	@echo ROOTDIR = $(ROOTDIR)
	@echo PROJECTDIR = $(PROJECTDIR)
	@echo PROJECTNAME= $(PROJECTNAME)
	@echo DBNAME= $(DBNAME)
	@echo DBFILE= $(DBFILE)
	@#echo LOGFILE= $(LOGFILE)
	@echo "---------------------------------------------------------------------"

.PHONY: test/dirs ROOTDIR PROJECTDIR PROJECTNAME SYSCONFIGDIR APPCONFIGDIR \
SCHEDULECONFIGDIR SERVERCONFIGDIR SQLDIR TESTSDIR OPTIONALPKGDIR \
LOCALDEPLOYMENTDIR PYTHONSCRIPTS LOCALSQLITE3 SOURCEDIR SQLITESRCDIR SERVICEDIR \
CUSTOMERFILEDIR LOADFILEDIR STATICFILEDIR DOCUMENTATIONDIR DATABASEDIR \
TEMPSTATEDIR LOCALSTATEDIR PROJECTLOGDIR

test/dirs: ROOTDIR PROJECTDIR PROJECTNAME SYSCONFIGDIR APPCONFIGDIR \
SCHEDULECONFIGDIR SERVERCONFIGDIR SQLDIR TESTSDIR OPTIONALPKGDIR \
LOCALDEPLOYMENTDIR PYTHONSCRIPTS LOCALSQLITE3 SOURCEDIR SQLITESRCDIR SERVICEDIR \
CUSTOMERFILEDIR LOADFILEDIR STATICFILEDIR DOCUMENTATIONDIR DATABASEDIR \
TEMPSTATEDIR LOCALSTATEDIR PROJECTLOGDIR
	@echo $(DTS)    [INFO] - Executing $@.

ROOTDIR: $(ROOTDIR)
	@$(test_dir)
PROJECTDIR: $(PROJECTDIR)
	@$(test_dir)
SYSCONFIGDIR: $(SYSCONFIGDIR)
	@$(test_dir)
APPCONFIGDIR: $(APPCONFIGDIR)
	@$(test_dir)
SCHEDULECONFIGDIR: $(SCHEDULECONFIGDIR)
	@$(test_dir)
SERVERCONFIGDIR: $(SERVERCONFIGDIR)
	@$(test_dir)
SQLDIR: $(SQLDIR)
	@$(test_dir)
TESTSDIR: $(TESTSDIR)
	@$(test_dir)
OPTIONALPKGDIR: $(OPTIONALPKGDIR)
	@$(test_dir)
LOCALDEPLOYMENTDIR: $(LOCALDEPLOYMENTDIR)
	@$(test_dir)
PYTHONSCRIPTS: $(PYTHONSCRIPTS)
	@$(test_dir)
LOCALSQLITE3: $(LOCALSQLITE3)
	@$(test_dir)
SOURCEDIR: $(SOURCEDIR)
	@$(test_dir)
SQLITESRCDIR: $(SQLITESRCDIR)
	@$(test_dir)
SERVICEDIR: $(SERVICEDIR)
	@$(test_dir)
CUSTOMERFILEDIR: $(CUSTOMERFILEDIR)
	@$(test_dir)
LOADFILEDIR: $(LOADFILEDIR)
	@$(test_dir)
STATICFILEDIR: $(STATICFILEDIR)
	@$(test_dir)
DOCUMENTATIONDIR: $(DOCUMENTATIONDIR)
	@$(test_dir)
DATABASEDIR: $(DATABASEDIR)
	@$(test_dir)
TEMPSTATEDIR: $(TEMPSTATEDIR)
	@$(test_dir)
LOCALSTATEDIR: $(LOCALSTATEDIR)
	@$(test_dir)
PROJECTLOGDIR: $(PROJECTLOGDIR)
	@$(test_dir)

test/solution_files: SHELL PYTHON3 PIP SQLITE3 IN2CSV CSVSTACK SQLITEUTILS \
SPLIT TREE GRAPHVIZDOT NODEGRAPH
	@echo $(DTS)    [INFO] - Executing $@.

SHELL: $(SHELL)
	@$(test_dependent_file)
PYTHON3: $(PYTHON3)
	@$(test_dependent_file)
PIP: $(PIP)
	@$(test_dependent_file)
SQLITE3: $(SQLITE3)
	@$(test_dependent_file)
IN2CSV: $(IN2CSV)
	@$(test_dependent_file)
CSVSTACK: $(CSVSTACK)
	@$(test_dependent_file)
SQLITEUTILS: $(SQLITEUTILS)
	@$(test_dependent_file)
SPLIT: $(SPLIT)
	@$(test_dependent_file)
TREE: $(TREE)
	@$(test_dependent_file)
GRAPHVIZDOT: $(GRAPHVIZDOT)
	@$(test_dependent_file)
GCLOUD: $(GCLOUD)
	@$(test_dependent_file)
NODEGRAPH: $(NODEGRAPH)
	@$(test_dependent_file)

#.PHONY: dist
#dist: ## Create a distribution package.
#	@echo $(DTS)    [INFO] - Executing $@.

################################################################################
# Deployment configuration                                                     #
################################################################################
# Source files ----------------------------------------------------------------
.PHONY: test/shared/datasette

# ---- Datasette ------------------------------------------------------------
test/shared/datasette: \
	etc/app/metadata.yaml \
	etc/server/requirements.txt \
	etc/server/settings.json

etc/app/metadata.yaml:
	@$(test_file)

etc/server/requirements.txt:
	@$(test_file)

etc/server/settings.json:
	@$(test_file)

# ---- Vega ------------------------------------------------------------
etc/app/vega_embed_header.viz:
	@$(test_file)

etc/app/vega_embed_footer.viz:
	@$(test_file)

################################################################################
# Configure Database                                                           #
################################################################################
# Database and table tests-----------------------------------------------------
.PHONY: test/db test/sales.db test/tables \
	test_table/SRC_online_retail_II_-_Year_2010-2011_002 \
	test_table/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001

test/db: test/sales.db

test/sales.db: svc/db/sales.db
	$(test_database)

svc/db/sales.db:

test/tables: \
	test_table/SRC_online_retail_II_-_Year_2010-2011_002 \
	test_table/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001 \
	test_table/BSAT_INVOICES_001 \
	test_table/BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001 \
	test_table/BHUB_STOCK_CODES_001 \
	test_table/BHUB_INVOICE_CODES_001 \
	test_table/INFO_WEEKLY_TOP_SALES_RANK_002

# INFO_WEEKLY_TOP_SALES_RANK_002_create.sql -----------------------------------
test_table/INFO_WEEKLY_TOP_SALES_RANK_002: \
	INFO_WEEKLY_TOP_SALES_RANK_002
	@$(test_table)

etc/sql/INFO_WEEKLY_TOP_SALES_RANK_002_create.sql:
	@$(test_file)

INFO_WEEKLY_TOP_SALES_RANK_002: \
	etc/sql/INFO_WEEKLY_TOP_SALES_RANK_002_create.sql
	@$(create_table)

# BHUB_INVOICE_CODES_001_create.sql -------------------------------------------
test_table/BHUB_INVOICE_CODES_001: \
	BHUB_INVOICE_CODES_001
	@$(test_table)

etc/sql/BHUB_INVOICE_CODES_001_create.sql:
	@$(test_file)

BHUB_INVOICE_CODES_001: \
	etc/sql/BHUB_INVOICE_CODES_001_create.sql
	@$(create_table)

# BHUB_STOCK_CODES_001_create.sql ---------------------------------------------
test_table/BHUB_STOCK_CODES_001: \
	BHUB_STOCK_CODES_001
	@$(test_table)

etc/sql/BHUB_STOCK_CODES_001_create.sql:
	@$(test_file)

BHUB_STOCK_CODES_001: \
	etc/sql/BHUB_STOCK_CODES_001_create.sql
	@$(create_table)

# BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001 -----------------------------------
test_table/BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001: \
	BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001
	@$(test_table)

etc/sql/BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001_create.sql:
	@$(test_file)

BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001: \
	etc/sql/BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001_create.sql
	@$(create_table)

# BSAT_INVOICES_001 -----------------------------------------------------------
test_table/BSAT_INVOICES_001: \
	SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001
	@$(test_table)

etc/sql/BSAT_INVOICES_001_create.sql:
	@$(test_file)

BSAT_INVOICES_001: \
	etc/sql/BSAT_INVOICES_001_create.sql
	@$(create_table)

# SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001 -------------------------------------
test_table/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001: \
	SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001
	@$(test_table)

etc/sql/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001_create.sql:
	@$(test_file)

SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001: \
	etc/sql/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001_create.sql
	@$(create_table)

# SRC_online_retail_II_-_Year_2010-2011_002 -----------------------------------
test_table/SRC_online_retail_II_-_Year_2010-2011_002: \
	SRC_online_retail_II_-_Year_2010-2011_002
	@$(test_table)

etc/sql/SRC_online_retail_II_-_Year_2010-2011_002_create.sql:
	@$(test_file)

SRC_online_retail_II_-_Year_2010-2011_002: \
	etc/sql/SRC_online_retail_II_-_Year_2010-2011_002_create.sql
	@$(create_table)

################################################################################
# Project Pipeline                                                             #
################################################################################
.PHONY: test/inputs test/outputs
# ---- Tests inputs ----
test/inputs: \
	svc/source/online_retail_II.xlsx

svc/source/online_retail_II.xlsx:
	@$(test_file)

touch_src/online_retail: svc/source/online_retail_II.xlsx
	@$(update_file_modified_date)

# ---- Tests outputs ----
test/outputs: \
	test/WEEKLY_TOP_SALES_RANK_004.html

test/WEEKLY_TOP_SALES_RANK_004.html: svc/static/WEEKLY_TOP_SALES_RANK_004.html
	@$(test_dependent_file)

# Extract ---------------------------------------------------------------------
.PHONY: extract split/online_retail_II uninstall/online_retail_II
extract: split/online_retail_II

svc/load/online_retail_II_-_Year_2010-2011.csv: TABNAME = "Year 2010-2011"
svc/load/online_retail_II_-_Year_2010-2011.csv: svc/source/online_retail_II.xlsx
	@$(extract_csv_from_excel)

split/online_retail_II: SOURCEDIR="svc/load/$(@F)/"
split/online_retail_II: TARGETDIR="svc/load/split_$(@F)/"
split/online_retail_II: TARGETNAME="$(basename $(<F))_"
split/online_retail_II: svc/load/online_retail_II_-_Year_2010-2011.csv
	@#<split/file_group_description>(colon)(space) path/to/source_file.csv
	@echo $(DTS)     [INFO] - Splitting $< into $(TARGETDIR)$(TARGETNAME)_###
	@mkdir -p $(SOURCEDIR) $(TARGETDIR)
	@/usr/local/bin/gsplit -d -a 3 -l 50000 --additional-suffix=".csv" \
	$< $(TARGETDIR)/$(TARGETNAME)
	@wc -l $(TARGETDIR)*.csv

uninstall/online_retail_II:
	@echo $(DTS)    [INFO] - Executing $@
	@rm -r $(LOADFILEDIR)/$(@F) || true
	@rm -r $(LOADFILEDIR)/split_$(@F) || true

# Load ------------------------------------------------------------------------
.PHONY: load load/SRC_online_retail_II_-_Year_2010-2011_002
load: load/SRC_online_retail_II_-_Year_2010-2011_002

load/SRC_online_retail_II_-_Year_2010-2011_002: svc/load/online_retail_II/load.csv
	@#load/<SRC_target_table_name_###>(colon)(space)<path/to/csv_file/load.csv>
	@echo $(DTS)     [INFO] - Extracting data from $< and loading into $@
	@if test -s $<; \
	then $(SQLITE3) $(DBFILE) ".import --csv $< $(notdir $@)" ".quit"; \
	else echo $(DTS)     [WARNING] - $< file does not exist; fi
	@$(SQLITE3) $(DBFILE) \
	"SELECT COUNT(*) || ' records in $(notdir $@)' FROM [$(notdir $@)]" ".quit"
	@rm -f $<

svc/load/online_retail_II/load.csv: .FORCE
	@#path/to/<source_reference_name_directory>/load.csv(colon)(space)
	@echo $(DTS)     [INFO] - Loading csv files from $(realpath $(dir $@)) and loading into $@
	@$(if $(abspath $(LIST_CSV)), cat $(abspath $(LIST_CSV)) >> $(addsuffix .tmp, $(basename $@)) \
	&& echo $(DTS)     [INFO] - Concatenating csv files [$(realpath $(LIST_CSV))] \
	&& wc -l $(addsuffix .tmp, $(basename $@)), \
	echo $(DTS)     [INFO] - no files to process in $(dir $@))
	@sort -u $(addsuffix .tmp, $(basename $@)) -o $@ || true
	@rm -f $(addsuffix .tmp, $(basename $@)) || true
	@find $(realpath $(dir $@)) -type f -not -name 'load.csv' -delete
	@wc -l $@ || true

# Transform -------------------------------------------------------------------
.PHONY: transform metrics load/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001 \
	clean/SRC_online_retail_II_-_Year_2010-2011_002 load/BSAT_INVOICES_001 \
	load/BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001 load/BHUB_STOCK_CODES_001 \
	load/BHUB_INVOICE_CODES_001 load/INFO_WEEKLY_TOP_SALES_RANK_002
	metrics/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001 metrics/BSAT_INVOICES_001 \
	metrics/BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001 metrics/BHUB_STOCK_CODES_001 \
	metrics/BHUB_INVOICE_CODES_001 metrics/INFO_WEEKLY_TOP_SALES_RANK_002

transform: \
	load/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001 \
	clean/SRC_online_retail_II_-_Year_2010-2011_002 \
	load/BSAT_INVOICES_001 \
	load/BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001 \
	load/BHUB_STOCK_CODES_001 \
	load/BHUB_INVOICE_CODES_001 \
	load/INFO_WEEKLY_TOP_SALES_RANK_002

metrics: \
	metrics/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001 \
	metrics/BSAT_INVOICES_001 \
	metrics/BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001 \
	metrics/BHUB_STOCK_CODES_001 \
	metrics/BHUB_INVOICE_CODES_001 \
	metrics/INFO_WEEKLY_TOP_SALES_RANK_002

# INFO_WEEKLY_TOP_SALES_RANK_002 ----------------------------------------------
.PHONY: load/INFO_WEEKLY_TOP_SALES_RANK_002
etc/sql/INFO_WEEKLY_TOP_SALES_RANK_002_load.sql:
	@$(test_file)

load/INFO_WEEKLY_TOP_SALES_RANK_002: \
	etc/sql/INFO_WEEKLY_TOP_SALES_RANK_002_load.sql \
	INFO_WEEKLY_TOP_SALES_RANK_002 \
	load/BSAT_INVOICES_001 \
	load/BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001
	@$(execute_sql)

metrics/INFO_WEEKLY_TOP_SALES_RANK_002: \
	INFO_WEEKLY_TOP_SALES_RANK_002
	@$(record_count_table)

# BHUB_INVOICE_CODES_001 ------------------------------------------------------
.PHONY: load/BHUB_INVOICE_CODES_001
etc/sql/BHUB_INVOICE_CODES_001_load.sql:
	@$(test_file)

load/BHUB_INVOICE_CODES_001: \
	etc/sql/BHUB_INVOICE_CODES_001_load.sql \
	SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001 \
	BHUB_INVOICE_CODES_001 \
	load/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001
	@$(execute_sql)

metrics/BHUB_INVOICE_CODES_001: \
	BHUB_INVOICE_CODES_001
	@$(record_count_table)

# BHUB_STOCK_CODES_001 --------------------------------------------------------
.PHONY: load/BHUB_STOCK_CODES_001
etc/sql/BHUB_STOCK_CODES_001_load.sql:
	@$(test_file)

load/BHUB_STOCK_CODES_001: \
	etc/sql/BHUB_STOCK_CODES_001_load.sql \
	SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001 \
	BHUB_STOCK_CODES_001 \
	load/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001
	@$(execute_sql)

metrics/BHUB_STOCK_CODES_001: \
	BHUB_STOCK_CODES_001
	@$(record_count_table)

# BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001 -----------------------------------
.PHONY: load/BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001
etc/sql/BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001_load.sql:
	@$(test_file)

load/BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001: \
	etc/sql/BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001_load.sql \
	SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001 \
	BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001 \
	load/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001
	@$(execute_sql)

metrics/BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001: \
	BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001
	@$(record_count_table)

# BSAT_INVOICES_001 -----------------------------------------------------------
.PHONY: load/BSAT_INVOICES_001
etc/sql/BSAT_INVOICES_001_load.sql:
	@$(test_file)

load/BSAT_INVOICES_001: \
	etc/sql/BSAT_INVOICES_001_load.sql \
	SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001 \
	BSAT_INVOICES_001 \
	load/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001
	@$(execute_sql)

metrics/BSAT_INVOICES_001: \
	BSAT_INVOICES_001
	@$(record_count_table)

# SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001 -------------------------------------
.PHONY: load/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001 \
	clean/SRC_online_retail_II_-_Year_2010-2011_002

etc/sql/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001_load.sql:
	@$(test_file)

load/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001: \
	etc/sql/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001_load.sql \
	SRC_online_retail_II_-_Year_2010-2011_002 \
	SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001 \
	load/SRC_online_retail_II_-_Year_2010-2011_002
	@$(execute_sql)

clean/SRC_online_retail_II_-_Year_2010-2011_002: \
	etc/sql/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001_clean.sql \
	load/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001
	@$(execute_sql)

metrics/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001: \
	SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001
	@$(record_count_table)

################################################################################
# Publish                                                                      #
################################################################################
# Vega-Lite reports -----------------------------------------------------------
etc/app/WEEKLY_TOP_SALES_RANK_001.vega:
	@$(test_file)

svc/static/WEEKLY_TOP_SALES_RANK_004.html: VIZTITLE="Weekly Top Sales Rank - JSON API call v2"
svc/static/WEEKLY_TOP_SALES_RANK_004.html: VIZTEMPLATE=etc/app/WEEKLY_TOP_SALES_RANK_001.vega
svc/static/WEEKLY_TOP_SALES_RANK_004.html: VIZURL="/sales/INFO_WEEKLY_TOP_SALES_RANK_002.json?_shape=array"
svc/static/WEEKLY_TOP_SALES_RANK_004.html: INFO_WEEKLY_TOP_SALES_RANK_002
	$(vega_report_from_api)

################################################################################
# Deployments                                                                  #
################################################################################
# Local deployment ------------------------------------------------------------
.PHONY: deploy/local test/local_config build/local uninstall/local start/local test/local
deploy/local: start/local test/local
	@echo $(DTS)     [INFO] - Executing $@

test/local_config: \
	opt/local/metadata.yaml \
	opt/local/requirements.txt \
	opt/local/settings.json \
	opt/local/sales.db \
	opt/local/static/WEEKLY_TOP_SALES_RANK_004.html
	@echo $(DTS)     [INFO] - Executing $@

build/local:
	@echo $(DTS)     [INFO] - Executing $@
	@mkdir -p opt/$(notdir $@)/static
	@cp -f etc/app/metadata.yaml opt/local/metadata.yaml
	@cp -f etc/server/requirements.txt opt/local/requirements.txt
	@cp -f etc/server/settings.json opt/local/settings.json
	@cp -f svc/db/sales.db opt/local/sales.db
	@cp -f svc/static/WEEKLY_TOP_SALES_RANK_004.html opt/local/static/WEEKLY_TOP_SALES_RANK_004.html

opt/local/metadata.yaml:
	@$(test_file)

opt/local/requirements.txt:
	@$(test_file)

opt/local/settings.json:
	@$(test_file)

opt/local/sales.db:
	@$(test_file)

opt/local/static/WEEKLY_TOP_SALES_RANK_004.html:
	@$(test_file)

uninstall/local: ## Removes the build artifacts. "make uninstall/local"
	@echo $(DTS)    [INFO] - Executing $@
	@rm -r opt/local/static || true
	@rm -f opt/local/* || true

start/local: build/local test/local_config
	@echo $(DTS)     [INFO] - Starting server on http://$(strip $(LOCAL_ADDRESS)):$(LOCAL_PORT)
	@$(DATASETTE) serve $(LOCALDEPLOYMENTDIR) --host $(LOCAL_ADDRESS) --port $(LOCAL_PORT) -o

test/local:
	@echo $(DTS)    [INFO] - Executing $@
	@$(if $(shell curl http://$(strip $(LOCAL_ADDRESS)):$(LOCAL_PORT) -fIs | head -n 1), \
	echo $(DTS)    [INFO] - http://$(strip $(LOCAL_ADDRESS)):$(LOCAL_PORT) - \
	$(shell curl http://$(strip $(LOCAL_ADDRESS)):$(LOCAL_PORT) -fIs | head -n 1), \
	echo $(DTS)    [FAIL] - $(strip $(LOCAL_ADDRESS)):$(LOCAL_PORT) is unavailable)

# Google CloudRun deployment --------------------------------------------------
.PHONY: deploy/gcloud test/gcloud_config build/gcloud uninstall/gcloud start/gcloud test/gcloud
deploy/gcloud: start/gcloud test/gcloud
	@echo $(DTS)     [INFO] - Executing $@

test/gcloud_config: \
	opt/gcloud/metadata.yaml \
	opt/gcloud/requirements.txt \
	opt/gcloud/settings.json \
	opt/gcloud/sales.db \
	opt/gcloud/static/WEEKLY_TOP_SALES_RANK_004.html
	@echo $(DTS)     [INFO] - Executing $@

opt/gcloud/metadata.yaml:
	@$(test_file)

opt/gcloud/requirements.txt:
	@$(test_file)

opt/gcloud/settings.json:
	@$(test_file)

opt/gcloud/sales.db:
	@$(test_file)

opt/gcloud/static/WEEKLY_TOP_SALES_RANK_004.html:
	@$(test_file)

build/gcloud:
	@echo $(DTS)    [INFO] - Executing $@
	@mkdir -p opt/$(notdir $@)/static
	@cp -f svc/db/sales.db opt/$(notdir $@)/sales.db
	@cp -f etc/app/metadata.yaml opt/$(notdir $@)/metadata.yaml
	@cp -f etc/server/requirements.txt opt/$(notdir $@)/requirements.txt
	@cp -f etc/server/settings.json opt/$(notdir $@)/settings.json
	@cp -f svc/static/WEEKLY_TOP_SALES_RANK_004.html opt/$(notdir $@)/static/WEEKLY_TOP_SALES_RANK_004.html

uninstall/gcloud: ## Removes the build artifacts. "make uninstall/local"
	@echo $(DTS)    [INFO] - Executing $@
	@rm -r opt/gcloud/static || true
	@rm -r opt/gcloud || true

start/gcloud: build/gcloud test/gcloud_config
	@echo [INFO] - Starting server build on http://$(strip $(GCLOUD_URL))
	@$(DATASETTE) publish cloudrun --service=$(PROJECTNAME) \
	opt/$(notdir $@)/sales.db \
	-m opt/$(notdir $@)/metadata.yaml \
	--memory 2Gi \
	--install=datasette-vega \
	--install=datasette-copyable \
	--extra-options="--setting allow_download off" \
	--extra-options="--setting default_page_size 1000" \
	--static static:opt/$(notdir $@)/static/

test/gcloud:
	@$(if $(shell curl $(strip $(GCLOUD_URL)) -fIs | head -n 1), \
	echo [PASS] - $(strip $(GCLOUD_URL)) - $(shell curl $(strip $(GCLOUD_URL)) -fIs | head -n 1), \
	echo [FAIL] - $(strip $(GCLOUD_URL)) is unavailable)
