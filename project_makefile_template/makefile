# ~/projects/<project_name>/makefile
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
SHELL := $(shell which bash)
SQLITE3 := $(shell which sqlite3)
SPLIT := $(shell which gsplit)
TREE := $(shell which tree)
CURL := $(shell which curl)
GRAPHVIZDOT := $(shell which dot)
GCLOUD := $(shell which gcloud)
#PYENVDIR := /Users/brianmcmillan/.pyenv/shims)
PYTHON3 := $(shell which python3)
PIP := $(shell which pip)
IN2CSV := $(shell which in2csv)
SQL2CSV := $(shell which sql2csv)
CSVSTACK := $(shell which csvstack)
CSVSQL := $(shell which csvsql)
SQLITEUTILS := $(shell which sqlite-utils)
NODEGRAPH := $(shell which makefile2dot)
DATASETTE := $(shell which datasette)
ERALCHEMY := $(shell which eralchemy)

# Utility variables
DTS = $(shell date +%Y-%m-%dT%H:%M:%S-%Z)
LIST_CSV = $(shell find $(dir $@) -type f -name '*.csv' -not -name 'load.csv')

# Deployment variables
LOCAL_ADDRESS := $(shell hostname -I) #192.168.1.251
LOCAL_PORT := 8001

################################################################################
# Macros                                                                       #
################################################################################
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
	@#test_databse(colon)(space)<path/to/database.db>
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
	@#record_count/<table name>(colon)(space)<path/to/database.db>
	echo $(DTS)     [INFO] - record count = $(shell $(SQLITE3) $< \
	"SELECT COUNT(*) || ' records in $(@F).$(notdir $<)' FROM [$(@F)]" ".quit")
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
	@$(CSVSTACK) -n load_dts -g $(DTS) $@ > tmp/$(@F)_1.tmp
	@$(CSVSTACK) -n provider_code -g $@ tmp/$(@F)_1.tmp > tmp/$(@F)_2.tmp
	@mv tmp/$(@F)_2.tmp $@
	@rm tmp/$(@F)_1.tmp
	@$(test_file)
endef

define execute_sql_export_csv
	@#<path/to/export_file.csv>(colon)(space)<path/to/query.sql>
	@echo $(DTS)     [INFO] - Executing $< and exporting to $@
	@$(SQL2CSV) --db sqlite:///$(DBFILE) $< > $@
endef

define load_csv_into_database
	@#load_csv/SRC_<csv_file_name>_001(colon)(space)DBNAME=<database_name>
	@#load_csv/SRC_<csv_file_name>_001(colon)(space)<path/to/csv_file.csv>
	@echo $(DTS)    [INFO] - Executing $@
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

define table_metadata
	@#table_metadata(colon)(space)<path/to/database.db>"
	@echo $(DTS)    [INFO] - Executing $@
	@$(SQLITE3) $(<) "DROP TABLE IF EXISTS '_analyze_tables_';" ".quit"
	@$(SQLITE3) $(<) "DROP TABLE IF EXISTS 'META_TABLES_001';" ".quit"
	@$(SQLITEUTILS) analyze-tables $(<) --save
	@$(SQLITE3) $(<) "ALTER TABLE '_analyze_tables_' RENAME TO 'META_TABLES_001';" ".quit"
endef

define sql_template_from_csv
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
endef

define er_diagram
	@#<path/to/diagram.type>(colon)(space)REL_FILE="<path/to/relationship_file.txt>"
	@#<path/to/diagram.type>(colon)(space)<table_name(s)>"
	@#Types can be er, pdf, png, dot
	@echo $(DTS)    [INFO] - Executing $@
	@$(ERALCHEMY) -i sqlite:///$(DBFILE) -o tmp/$(@F).er
	@cat tmp/$(@F).er $(REL_FILE) > tmp/$(@F)_2.er || true
	@$(ERALCHEMY) -i tmp/$(@F)_2.er -o $@
	@rm -f tmp/$(@F)*.er
endef

define log_rotate
	@#log_rotate:(colon)(space)<path/to/logfile>
	@echo $(DTS)    [INFO] - Executing $@
	@mv $< $(basename($<))_$(shell date +%Y-%m-%d).txt
endef

define compact_database
	@#compact_database(colon)(space)<path/to/database.db>
	@echo $(DTS)    [INFO] - Executing $@
	@$(SQLITE3) $< "PRAGMA optimize;" && echo $(DTS)    [INFO] - Optimizing database
	@$(SQLITE3) $< "PRAGMA auto_vacuum;" && echo $(DTS)    [INFO] - Vacuuming database
	@$(SQLITE3) $< "PRAGMA integrity_check;" && echo $(DTS)    [INFO] - Performing integrity check
endef

define help
	@echo $(DTS)    [INFO] - Executing $@
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "};\
	{printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
endef

define split_csv
	@#<split/file_group_description>(colon)(space) path/to/source_file.csv
	@echo $(DTS)     [INFO] - Splitting $< into $(TARGETDIR)$(TARGETNAME)_###
	@mkdir -p svc/load/$(@F)/ svc/load/split_$(@F)/
	@$(SPLIT) -d -a 3 -l 50000 --additional-suffix=".csv" \
	$< svc/load/split_$(@F)/$(basename $(<F))_
	@wc -l svc/load/split_$(@F)/*.csv
endef

###############################################################################
all: run ## Executes the default make task.
info: help info/variables documentation ## Generates the informational files.
check: test/inputs test/outputs ## Executes all test suites.
installcheck: test/inputs ## Run the project test suite.
install: test/inputs ## Builds the database and application structure.
uninstall: uninstalldirs ## Uninstalls the project.
run: test/inputs build/local table_metadata documentation metrics ## Executes the data pipelines.
deploy: deploy/local ##Deploys local web server.

.PHONY: all info check installcheck install uninstall run deploy help documentation \
	table_metadata uninstalldirs log_rotate compact_database info/variables template/src_from_csv

.FORCE:

help: ## List of all makefile tasks.
	@$(help)

documentation: svc/doc/directory_listing.txt ## Builds the documentation files for the build. (e.g. schema docs, data flow diagrams)

#documentation: svc/doc/directory_listing.txt svc/doc/makefile_graph.png svc/doc/er_diagram.pdf ## Builds the documentation files for the build. (e.g. schema docs, data flow diagrams)


table_metadata: svc/db/online_retail.db
	@$(table_metadata)

svc/doc/directory_listing.txt: .FORCE
	@echo $(DTS)    [INFO] - Executing $@
	@$(TREE) --prune > svc/doc/directory_listing.txt

svc/doc/makefile_graph.png: .FORCE
	@echo $(DTS)    [INFO] - Executing $@
	@$(NODEGRAPH) --direction LR | $(GRAPHVIZDOT) -Tpng > $@

svc/doc/er_diagram.pdf: REL_FILE=""
svc/doc/er_diagram.pdf:	DBFILE=svc/db/online_retail.db
svc/doc/er_diagram.pdf: svc/db/online_retail.db .FORCE
	@$(er_diagram)

uninstalldirs: ## Removes the project directories. "make uninstall"
	@echo $(DTS)    [INFO] - Executing $@
	@rm -rf svc/db/* svc/doc/* svc/load/* svc/static/* opt/local/static/* opt/local/*

log_rotate: <path/to/log_file> ## Rotates log files.
	@$(log_rotate)

compact_database: svc/db/online_retail.db ## Database maintenance scripts.
	@$(compact_database)

info/variables: ## List the variables in the makefile.
	@echo $(DTS)    [INFO] - Executing $@
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
	@echo "---------------------------------------------------------------------"

.PHONY: template/src_from_csv
template/src_from_csv: ## Create source table from CSV template (make template/src_from_csv CSVPATH=<path/to/file.csv).
	@$(sql_template_from_csv)

################################################################################
# Tests                                                                        #
################################################################################
.PHONY: test/inputs test/outputs test/database metrics metrics/SRC_online_retail_II_001

test/inputs: svc/source/online_retail_II.xlsx

test/outputs: test/database
	@echo $(DTS)    [INFO] - Executing $@

test/database: svc/db/online_retail.db
	$(test_database)

metrics: metrics/SRC_online_retail_II_001 metrics/META_TABLES_001

metrics/SRC_online_retail_II_001: svc/db/online_retail.db
	@$(record_count_table)

metrics/META_TABLES_001: svc/db/online_retail.db
	@$(record_count_table)

################################################################################
# Project Pipeline                                                             #
################################################################################
.PHONY: load_csv/SRC_online_retail_II_001 build/local deploy/local

svc/source/online_retail_II.xlsx: PATH="https://archive.ics.uci.edu/ml/machine-learning-databases/00502/online_retail_II.xlsx"
svc/source/online_retail_II.xlsx:
	@echo $(DTS)    [INFO] - Executing $@
	@$(CURL) -o $@ $(PATH)

svc/load/online_retail_II_-_Year_2010-2011.csv: TABNAME = "Year 2010-2011"
svc/load/online_retail_II_-_Year_2010-2011.csv: svc/source/online_retail_II.xlsx
	@$(extract_csv_from_excel)

load_csv/SRC_online_retail_II_001: DBFILE=svc/db/online_retail.db
load_csv/SRC_online_retail_II_001: svc/load/online_retail_II_-_Year_2010-2011.csv
	@$(load_csv_into_database)

svc/db/online_retail.db: load_csv/SRC_online_retail_II_001

build/local: svc/db/online_retail.db
	@echo $(DTS)     [INFO] - Executing $@
	@mkdir -p opt/$(notdir $@)/static
	@cp -f etc/app/metadata.yaml opt/local/metadata.yaml
	@cp -f etc/server/requirements.txt opt/local/requirements.txt
	@cp -f etc/server/settings.txt opt/local/settings.txt
	@cp -f $< opt/local/$(<F)

deploy/local: build/local
	@echo $(DTS)     [INFO] - Starting server on http://$(strip $(LOCAL_ADDRESS)):$(LOCAL_PORT)
	@$(DATASETTE) serve opt/local/ --host $(LOCAL_ADDRESS) --port $(LOCAL_PORT) -o
