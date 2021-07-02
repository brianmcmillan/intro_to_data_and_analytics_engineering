# ~/projects/projects/makefile
# Initialize a new data project
#
# make help
# make install PROJECTNAME=myproject
# make uninstall PROJECTNAME=myproject
#
##############################################################
# System variables and paths
SHELL := /bin/bash
ROOTDIR := $(shell pwd)

# Setup project
PROJECTNAME ?= test
PROJECTDIR := $(ROOTDIR)/$(PROJECTNAME)
SOURCEDIR := /src
SYSCONFIGDIR := /etc
SERVICEDIR := /svc
OPTIONALPKGDIR := /opt
LOCALSTATEDIR := /var
TEMPSTATEDIR := /tmp

# Utility variables
DTS = $(shell date +%Y-%m-%dT%H:%M:%S-%Z)

# Software variables
URL_SHA1 := "https://www.sqlite.org/src/raw/c8f2253c8792ffab9517695ea7d88c079f0395a5505eefef5c8198fe184ed5ac?at=sha1.c"

# Macros
define test_dir
	# tests the directory in the <first dependency>
	if ! test -d \$$<; \
	then echo $(DTS)    [FAIL] - \$$< does not exist; \
	else true; fi
endef

define test_file
	# tests the file in the <first dependency>
	if ! test -s \$$@; \
	then echo $(DTS)    [FAIL] - \$$@ does not exist; \
	else true; fi
endef

##############################################################
all: install check ## Executes the default make task. Initially, 'help'.
info: help info/variables ## Generates the informational files.
check: test/templates test/project test/project_dirs test/project_templates ## Executes all test suites.
installcheck: test/templates test/project test/project_dirs test/project_templates ## Run the project test suite.
install: installdirs install/templates install/project_templates src/sha1 ## Builds the project "make install PROJECTNAME=<proj>".
uninstall: uninstalldirs ## Uninstalls the project.

.PHONY: installcheck
installcheck: ## Run the installation test suite.
	@echo $(DTS)    [INFO] - $@.

.PHONY: dist
dist: ## Create a distribution package.
	@echo $(DTS)    [INFO] - $@

.PHONY: help
help: ## List of all makefile tasks.
	@echo $(DTS)    [INFO] - $@
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "};\
	{printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: info/variables
info/variables: ## List the variables in the makefile.
	@echo $(DTS)    [INFO] - $@
	@echo SHELL: $(SHELL)
	@echo ROOTDIR: $(ROOTDIR)
	@echo PROJECTNAME: $(PROJECTNAME)
	@echo PROJECTDIR: $(PROJECTDIR)
	@echo DTS: $(DTS)
	@echo SOURCEDIR: $(SOURCEDIR)
	@echo SYSCONFIGDIR: $(SYSCONFIGDIR)
	@echo SYSCONFIGDIR: $(SERVICEDIR)
	@echo OPTIONALPKGDIR: $(OPTIONALPKGDIR)
	@echo LOCALSTATEDIR: $(LOCALSTATEDIR)
	@echo TEMPSTATEDIR: $(TEMPSTATEDIR)
	@echo SQLITE_VERSION: $(SQLITE_VERSION)
	@echo URL_SQLITE: $(URL_SQLITE)
	@echo URL_EXTENSION_FUNCTIONS: $(URL_EXTENSION_FUNCTIONS)
	@echo URL_SHA1: $(URL_SHA1)
	@echo URL_PERCENTILE: $(URL_PERCENTILE)

################################################################################
# Tests                                                                        #
################################################################################
.PHONY: test/templates test/project test/project_dirs test/project_templates

test/templates:
	@if test -s $(ROOTDIR)/src/AUTHORS.md; \
		then echo $(DTS)    [PASS] - $(ROOTDIR)/src/AUTHORS.md file exists; \
		else echo $(DTS)    [FAIL] - $(ROOTDIR)/src/AUTHORS.md file does not exist; fi
	@if test -s $(ROOTDIR)/src/CHANGELOG.md; \
		then echo $(DTS)    [PASS] - $(ROOTDIR)/src/CHANGELOG.md file exists; \
		else echo $(DTS)    [FAIL] - $(ROOTDIR)/src/CHANGELOG.md file does not exist; fi
	@if test -s $(ROOTDIR)/src/LICENSE.md; \
		then echo $(DTS)    [PASS] - $(ROOTDIR)/src/LICENSE.md file exists; \
		else echo $(DTS)    [FAIL] - $(ROOTDIR)/src/LICENSE.md file does not exist; fi
	@if test -s $(ROOTDIR)/src/NEWS.md; \
		then echo $(DTS)    [PASS] - $(ROOTDIR)/src/NEWS.md file exists; \
		else echo $(DTS)    [FAIL] - $(ROOTDIR)/src/NEWS.md file does not exist; fi
	@if test -s $(ROOTDIR)/src/README.md; \
		then echo $(DTS)    [PASS] - $(ROOTDIR)/src/README.md file exists; \
		else echo $(DTS)    [FAIL] - $(ROOTDIR)/src/README.md file does not exist; fi
	@if test -s $(ROOTDIR)/src/crontab.txt; \
		then echo $(DTS)    [PASS] - $(ROOTDIR)/src/crontab.txt file exists; \
		else echo $(DTS)    [FAIL] - $(ROOTDIR)/src/crontab.txt file does not exist; fi
	@if test -s $(ROOTDIR)/src/datasette_metadata.yaml; \
		then echo $(DTS)    [PASS] - $(ROOTDIR)/src/datasette_metadata.yaml file exists; \
		else echo $(DTS)    [FAIL] - $(ROOTDIR)/src/datasette_metadata.yaml file does not exist; fi
	@if test -s $(ROOTDIR)/src/datasette_requirements.txt; \
		then echo $(DTS)    [PASS] - $(ROOTDIR)/src/datasette_requirements.txt file exists; \
		else echo $(DTS)    [FAIL] - $(ROOTDIR)/src/datasette_requirements.txt file does not exist; fi
	@if test -s $(ROOTDIR)/src/datasette_settings.txt; \
		then echo $(DTS)    [PASS] - $(ROOTDIR)/src/datasette_settings.txt file exists; \
		else echo $(DTS)    [FAIL] - $(ROOTDIR)/src/datasette_settings.txt file does not exist; fi
	@if test -s $(ROOTDIR)/src/er_relationships.txt; \
		then echo $(DTS)    [PASS] - $(ROOTDIR)/src/er_relationships.txt file exists; \
		else echo $(DTS)    [FAIL] - $(ROOTDIR)/src/er_relationships.txt file does not exist; fi
	@if test -s $(ROOTDIR)/src/header.sql; \
		then echo $(DTS)    [PASS] - $(ROOTDIR)/src/header.sql file exists; \
		else echo $(DTS)    [FAIL] - $(ROOTDIR)/src/header.sql file does not exist; fi
	@if test -s $(ROOTDIR)/src/vega_bar_chart.vega; \
		then echo $(DTS)    [PASS] - $(ROOTDIR)/src/vega_bar_chart.vega file exists; \
		else echo $(DTS)    [FAIL] - $(ROOTDIR)/src/vega_bar_chart.vega file does not exist; fi
	@if test -s $(ROOTDIR)/src/vega_line_chart.vega; \
		then echo $(DTS)    [PASS] - $(ROOTDIR)/src/vega_bar_chart.vega file exists; \
		else echo $(DTS)    [FAIL] - $(ROOTDIR)/src/vega_bar_chart.vega file does not exist; fi
	@if test -s $(ROOTDIR)/src/vega_scatter_chart.vega; \
		then echo $(DTS)    [PASS] - $(ROOTDIR)/src/vega_bar_chart.vega file exists; \
		else echo $(DTS)    [FAIL] - $(ROOTDIR)/src/vega_bar_chart.vega file does not exist; fi
	@if test -s $(ROOTDIR)/src/vega_embed_header.viz; \
		then echo $(DTS)    [PASS] - $(ROOTDIR)/src/vega_embed_header.viz file exists; \
		else echo $(DTS)    [FAIL] - $(ROOTDIR)/src/vega_embed_header.viz file does not exist; fi
	@if test -s $(ROOTDIR)/src/vega_embed_footer.viz; \
		then echo $(DTS)    [PASS] - $(ROOTDIR)/src/vega_embed_footer.viz file exists; \
		else echo $(DTS)    [FAIL] - $(ROOTDIR)/src/vega_embed_footer.viz file does not exist; fi

test/project: ## Test for a PROJECTNAME directory.
	@echo $(DTS)    [INFO] - $@
	@if test -d $(PROJECTDIR);\
    then echo $(DTS)    [PASS] - Project directory already exist;\
    else echo $(DTS)    [FAIL] - Missing project directory, run \"make install PROJECTNAME=\<proj\>\";\
    fi

test/project_dirs: ## Test for the existance of a directory_listing
	@echo $(DTS)    [INFO] - $@
	@if test -d $(ROOTDIR)$(SOURCEDIR);\
		then echo $(DTS)    [PASS] - Project directory $(ROOTDIR)$(SOURCEDIR) exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(ROOTDIR)$(SOURCEDIR) does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(SYSCONFIGDIR);\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(SYSCONFIGDIR) exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(SYSCONFIGDIR) does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(SYSCONFIGDIR)/app;\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(SYSCONFIGDIR)/app exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(SYSCONFIGDIR)/app does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(SYSCONFIGDIR)/cron;\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(SYSCONFIGDIR)/cron exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(SYSCONFIGDIR)/cron does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(SYSCONFIGDIR)/server;\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(SYSCONFIGDIR)/server exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(SYSCONFIGDIR)/server does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(SYSCONFIGDIR)/sql;\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(SYSCONFIGDIR)/sql exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(SYSCONFIGDIR)/sql does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(SYSCONFIGDIR)/test;\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(SYSCONFIGDIR)/test exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(SYSCONFIGDIR)/test does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(OPTIONALPKGDIR);\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(OPTIONALPKGDIR) exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(OPTIONALPKGDIR) does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(OPTIONALPKGDIR)/local;\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(OPTIONALPKGDIR)/local exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(OPTIONALPKGDIR)/local does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(OPTIONALPKGDIR)/local/static;\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(OPTIONALPKGDIR)/local/static exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(OPTIONALPKGDIR)/local/static does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(OPTIONALPKGDIR)/python;\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(OPTIONALPKGDIR)/python exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(OPTIONALPKGDIR)/python does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(OPTIONALPKGDIR)/sqlite3;\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(OPTIONALPKGDIR)/sqlite3 exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(OPTIONALPKGDIR)/sqlite3 does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(SOURCEDIR);\
	  then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(SOURCEDIR) exists.;\
	  else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(SOURCEDIR) does not exist;\
	  fi
	@if test -d $(PROJECTDIR)$(SOURCEDIR)/sqlite3;\
	  then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(SOURCEDIR)/sqlite3 exists.;\
	  else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(SOURCEDIR)/sqlite3 does not exist;\
	  fi
	@if test -d $(PROJECTDIR)$(SERVICEDIR);\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(SERVICEDIR) exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(SERVICEDIR) does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(SERVICEDIR)/analysis;\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(SERVICEDIR)/analysis exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(SERVICEDIR)/analysis does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(SERVICEDIR)/db;\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(SERVICEDIR)/db exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(SERVICEDIR)/db does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(SERVICEDIR)/doc;\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(SERVICEDIR)/doc exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(SERVICEDIR)/doc does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(SERVICEDIR)/load;\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(SERVICEDIR)/load exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(SERVICEDIR)/load does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(SERVICEDIR)/source;\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(SERVICEDIR)/source exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(SERVICEDIR)/source does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(SERVICEDIR)/static;\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(SERVICEDIR)/static exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(SERVICEDIR)/static does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(TEMPSTATEDIR);\
		then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(TEMPSTATEDIR) exists.;\
		else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(TEMPSTATEDIR) does not exist;\
		fi
	@if test -d $(PROJECTDIR)$(LOCALSTATEDIR);\
	  then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(LOCALSTATEDIR) exists.;\
	  else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(LOCALSTATEDIR) does not exist;\
	  fi
	@if test -d $(PROJECTDIR)$(LOCALSTATEDIR)/log;\
	  then echo $(DTS)    [PASS] - Project directory $(PROJECTDIR)$(LOCALSTATEDIR)/log exists.;\
	  else echo $(DTS)    [FAIL] - Project directory $(PROJECTDIR)$(LOCALSTATEDIR)/log does not exist;\
	  fi

test/project_templates:
	@if test -s $(PROJECTDIR)/AUTHORS.md; \
		then echo $(DTS)    [PASS] - $(PROJECTDIR)/AUTHORS.md file exists; \
		else echo $(DTS)    [FAIL] - $(PROJECTDIR)/AUTHORS.md file does not exist; fi
	@if test -s $(PROJECTDIR)/CHANGELOG.md; \
		then echo $(DTS)    [PASS] - $(PROJECTDIR)/CHANGELOG.md file exists; \
		else echo $(DTS)    [FAIL] - $(PROJECTDIR)/CHANGELOG.md file does not exist; fi
	@if test -s $(PROJECTDIR)/LICENSE.md; \
		then echo $(DTS)    [PASS] - $(PROJECTDIR)/LICENSE.md file exists; \
		else echo $(DTS)    [FAIL] - $(PROJECTDIR)/LICENSE.md file does not exist; fi
	@if test -s $(PROJECTDIR)/NEWS.md; \
		then echo $(DTS)    [PASS] - $(PROJECTDIR)/NEWS.md file exists; \
		else echo $(DTS)    [FAIL] - $(PROJECTDIR)/NEWS.md file does not exist; fi
	@if test -s $(PROJECTDIR)/README.md; \
		then echo $(DTS)    [PASS] - $(PROJECTDIR)/README.md file exists; \
		else echo $(DTS)    [FAIL] - $(PROJECTDIR)/README.md file does not exist; fi
	@if test -s $(PROJECTDIR)$(SYSCONFIGDIR)/app/er_business_relationships.txt; \
		then echo $(DTS)    [PASS] - $(PROJECTDIR)$(SYSCONFIGDIR)/app/er_business_relationships.txt file exists; \
		else echo $(DTS)    [FAIL] - $(PROJECTDIR)$(SYSCONFIGDIR)/app/er_business_relationships.txt file does not exist; fi
	@if test -s $(PROJECTDIR)$(SYSCONFIGDIR)/app/metadata.yaml; \
		then echo $(DTS)    [PASS] - $(PROJECTDIR)$(SYSCONFIGDIR)/app/metadata.yaml file exists; \
		else echo $(DTS)    [FAIL] - $(PROJECTDIR)$(SYSCONFIGDIR)/app/metadata.yaml file does not exist; fi
	@if test -s $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_embed_header.viz; \
		then echo $(DTS)    [PASS] - $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_embed_header.viz file exists; \
		else echo $(DTS)    [FAIL] - $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_embed_header.viz file does not exist; fi
	@if test -s $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_embed_footer.viz; \
		then echo $(DTS)    [PASS] - $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_embed_footer.viz file exists; \
		else echo $(DTS)    [FAIL] - $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_embed_footer.viz file does not exist; fi
	@if test -s $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_bar_chart.vega; \
		then echo $(DTS)    [PASS] - $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_bar_chart.vega file exists; \
		else echo $(DTS)    [FAIL] - $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_bar_chart.vega file does not exist; fi
	@if test -s $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_line_chart.vega; \
		then echo $(DTS)    [PASS] - $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_line_chart.vega file exists; \
		else echo $(DTS)    [FAIL] - $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_line_chart.vega file does not exist; fi
	@if test -s $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_scatter_chart.vega; \
		then echo $(DTS)    [PASS] - $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_scatter_chart.vega file exists; \
		else echo $(DTS)    [FAIL] - $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_scatter_chart.vega file does not exist; fi
	@if test -s $(PROJECTDIR)$(SYSCONFIGDIR)/cron/crontab.txt; \
		then echo $(DTS)    [PASS] - $(PROJECTDIR)$(SYSCONFIGDIR)/cron/crontab.txt file exists; \
		else echo $(DTS)    [FAIL] - $(PROJECTDIR)$(SYSCONFIGDIR)/cron/crontab.txt file does not exist; fi
	@if test -s $(PROJECTDIR)$(SYSCONFIGDIR)/server/requirements.txt; \
		then echo $(DTS)    [PASS] - $(PROJECTDIR)$(SYSCONFIGDIR)/server/requirements.txt file exists; \
		else echo $(DTS)    [FAIL] - $(PROJECTDIR)$(SYSCONFIGDIR)/server/requirements.txt file does not exist; fi
	@if test -s $(PROJECTDIR)$(SYSCONFIGDIR)/server/settings.txt; \
		then echo $(DTS)    [PASS] - $(PROJECTDIR)$(SYSCONFIGDIR)/server/settings.txt file exists; \
		else echo $(DTS)    [FAIL] - $(PROJECTDIR)$(SYSCONFIGDIR)/server/settings.txt file does not exist; fi
	@if test -s $(PROJECTDIR)$(SYSCONFIGDIR)/sql/header.sql; \
		then echo $(DTS)    [PASS] - $(PROJECTDIR)$(SYSCONFIGDIR)/sql/header.sql file exists; \
		else echo $(DTS)    [FAIL] - $(PROJECTDIR)$(SYSCONFIGDIR)/sql/header.sql file does not exist; fi
	@echo "-------------------------------------------------------------------------------"
	@if test -s $(PROJECTDIR)$(OPTIONALPKGDIR)/sqlite3/sha1.dylib; \
		then echo $(DTS)    [PASS] - $(PROJECTDIR)$(OPTIONALPKGDIR)/sqlite3/sha1.dylib file exists; \
		else echo $(DTS)    [FAIL] - $(PROJECTDIR)$(OPTIONALPKGDIR)/sqlite3/sha1.dylib file does not exist; fi
	@if test -s $(PROJECTDIR)$(OPTIONALPKGDIR)/sqlite3/sha1.so; \
		then echo $(DTS)    [PASS] - $(PROJECTDIR)$(OPTIONALPKGDIR)/sqlite3/sha1.so file exists; \
		else echo $(DTS)    [FAIL] - $(PROJECTDIR)$(OPTIONALPKGDIR)/sqlite3/sha1.so file does not exist; fi

################################################################################
# Installation                                                                 #
################################################################################
.PHONY: installdirs install/templates install/project_templates

installdirs: ## Creates the project directories.
	@echo $(DTS)    [INFO] - Executing $@
	@mkdir -p $(ROOTDIR)/src \
	$(PROJECTNAME)$(SYSCONFIGDIR)/app \
	$(PROJECTNAME)$(SYSCONFIGDIR)/cron \
	$(PROJECTNAME)$(SYSCONFIGDIR)/server \
	$(PROJECTNAME)$(SYSCONFIGDIR)/sql \
	$(PROJECTNAME)$(SYSCONFIGDIR)/test \
	$(PROJECTNAME)$(OPTIONALPKGDIR)/local/static \
	$(PROJECTNAME)$(OPTIONALPKGDIR)/python \
	$(PROJECTNAME)$(OPTIONALPKGDIR)/sqlite3 \
	$(PROJECTNAME)$(SOURCEDIR)/sqlite3 \
	$(PROJECTNAME)$(SERVICEDIR)/analysis \
	$(PROJECTNAME)$(SERVICEDIR)/db \
	$(PROJECTNAME)$(SERVICEDIR)/doc \
	$(PROJECTNAME)$(SERVICEDIR)/load \
	$(PROJECTNAME)$(SERVICEDIR)/source \
	$(PROJECTNAME)$(SERVICEDIR)/static \
	$(PROJECTNAME)$(TEMPSTATEDIR) \
	$(PROJECTNAME)$(LOCALSTATEDIR)/log

install/templates: installdirs \
	src/AUTHORS.md \
	src/CHANGELOG.md \
	src/LICENSE.md \
	src/NEWS.md \
	src/README.md \
	src/header.sql \
	src/er_relationships.txt \
	src/vega_embed_header.viz \
	src/vega_embed_footer.viz \
	src/vega_bar_chart.vega \
	src/vega_line_chart.vega \
	src/vega_scatter_chart.vega \
	src/crontab.txt \
	src/datasette_requirements.txt \
	src/datasette_settings.txt \
	src/datasette_metadata.yaml
	@echo $(DTS)    [INFO] - Executing $@

install/project_templates: install/templates
	@echo $(DTS)    [INFO] - Executing install/project_templates.
	@cp -f $(ROOTDIR)/src/AUTHORS.md $(PROJECTDIR)
	@cp -f $(ROOTDIR)/src/CHANGELOG.md $(PROJECTDIR)
	@cp -f $(ROOTDIR)/src/LICENSE.md $(PROJECTDIR)
	@cp -f $(ROOTDIR)/src/NEWS.md $(PROJECTDIR)
	@cp -f $(ROOTDIR)/src/README.md $(PROJECTDIR)
	@cp -f $(ROOTDIR)/src/er_relationships.txt $(PROJECTDIR)$(SYSCONFIGDIR)/app/er_relationships.txt
	@cp -f $(ROOTDIR)/src/datasette_metadata.yaml $(PROJECTDIR)$(SYSCONFIGDIR)/app/metadata.yaml
	@cp -f $(ROOTDIR)/src/vega_embed_header.viz $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_embed_header.viz
	@cp -f $(ROOTDIR)/src/vega_embed_footer.viz $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_embed_footer.viz
	@cp -f $(ROOTDIR)/src/vega_bar_chart.vega $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_bar_chart.vega
	@cp -f $(ROOTDIR)/src/vega_line_chart.vega $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_line_chart.vega
	@cp -f $(ROOTDIR)/src/vega_scatter_chart.vega $(PROJECTDIR)$(SYSCONFIGDIR)/app/vega_scatter_chart.vega
	@cp -f $(ROOTDIR)/src/crontab.txt $(PROJECTDIR)$(SYSCONFIGDIR)/cron/crontab.txt
	@cp -f $(ROOTDIR)/src/datasette_requirements.txt $(PROJECTDIR)$(SYSCONFIGDIR)/server/requirements.txt
	@cp -f $(ROOTDIR)/src/datasette_settings.txt $(PROJECTDIR)$(SYSCONFIGDIR)/server/settings.txt
	@cp -f $(ROOTDIR)/src/header.sql $(PROJECTDIR)$(SYSCONFIGDIR)/sql/header.sql

.PHONY: uninstalldirs
uninstalldirs: ## Removes the project directories. "make uninstall PROJECTNAME=<proj>"
	@echo $(DTS)    [INFO] - Executing uninstalldirs.
	@rm -r $(PROJECTNAME) && echo $(DTS)    [WARNING] - Removing project directory
	@rm -r $(ROOTDIR)/src && echo $(DTS)    [WARNING] - Removing /src directory

################################################################################
# Compile software                                                             #
################################################################################
.PHONY: src/sha1
src/sha1: src/sha1.dylib

src/sha1.c:
	@echo $(DTS)    [INFO] - Executing $@
	@curl -o $@ $(URL_SHA1)

src/sha1.dylib: src/sha1.c
	@echo $(DTS)    [INFO] - Executing $@
	@gcc -fno-common -dynamiclib src/sha1.c -o $(PROJECTNAME)$(OPTIONALPKGDIR)/sqlite3/sha1.dylib

src/sha1.so: src/sha1.c
	@echo $(DTS)    [INFO] - Executing $@
	@gcc -fPIC -lm -shared src/sha1.c -o $(PROJECTNAME)$(OPTIONALPKGDIR)/sqlite3/sha1.so

################################################################################
# File templates                                                               #
################################################################################
src/AUTHORS.md:
	@echo $(DTS)    [INFO] - Executing $@
	@echo "# Authors" >> $@
	@echo "| Name | Role | Email | Phone |" >> $@
	@echo "|:--|:--|:--|:--|" >> $@
	@echo "| Prospero | Lead Sorcerer | prince@milan.com | 555-444-3333 |" >> $@
	@echo "| Miranda | Prospero's daughter | princess@milan.com | 555-444-2222 |" >> $@
	@echo "| Caliban | Slave of Prospero | mooncalf@island.net | 555-867-5000 |" >> $@
	@echo "| Ariel | Spirit | spirit@island.net | 555-867-5309 |" >> $@

src/CHANGELOG.md:
	@echo $(DTS)    [INFO] - Executing $@
	@echo "# Change Log" >> $@
	@echo "YYYY-MM-DD  Jane Doe  <mailto:johndoe@example.com>" >> $@
	@echo "* file1.txt (function): Lorem ipsum dolor sit amet" >> $@
	@echo "* file1.txt (unrelated_change): Lorem ipsum dolor sit amet" >> $@

src/LICENSE.md:
	@echo $(DTS)    [INFO] - Executing $@
	@echo "# MIT License" >> $@
	@echo "Copyright (c) [year] [fullname]" >> $@
	@echo " " >> $@
	@echo "Permission is hereby granted, free of charge, to any person obtaining a copy" >> $@
	@echo "of this software and associated documentation files (the "Software"), to deal" >> $@
	@echo "in the Software without restriction, including without limitation the rights" >> $@
	@echo "to use, copy, modify, merge, publish, distribute, sublicense, and/or sell" >> $@
	@echo "copies of the Software, and to permit persons to whom the Software is" >> $@
	@echo "furnished to do so, subject to the following conditions:" >> $@
	@echo " " >> $@
	@echo "The above copyright notice and this permission notice shall be included in all" >> $@
	@echo "copies or substantial portions of the Software." >> $@
	@echo " " >> $@
	@echo "THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR" >> $@
	@echo "IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY," >> $@
	@echo "FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE" >> $@
	@echo "AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER" >> $@
	@echo "LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM," >> $@
	@echo "OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE" >> $@
	@echo "SOFTWARE." >> $@

src/NEWS.md:
	@echo $(DTS)    [INFO] - Executing $@
	@echo "# News" >> $@
	@echo "## YYYY-MM-DD" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor." >> $@
	@echo " " >> $@
	@echo "## YYYY-MM-DD" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor." >> $@
	@echo " " >> $@
	@echo "## YYYY-MM-DD" >> $@
	@echo "Lorem ipsum incididunt ut labore et dolore magna aliqua. Bibendum arcu vitae." >> $@

src/README.md:
	@echo $(DTS)    [INFO] - Executing $@
	@echo "	# Project Name" >> $@
	@echo "	## Brief Description" >> $@
	@echo "	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor." >> $@
	@echo " " >> $@
	@echo "	## Project Status" >> $@
	@echo "	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor." >> $@
	@echo " " >> $@
	@echo "	## Problem Statement" >> $@
	@echo "	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor." >> $@
	@echo " " >> $@
	@echo "	## Usage" >> $@
	@echo "	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor." >> $@
	@echo "	## Screen Shots" >> $@
	@echo "	/docs/images/36-200x200.jpg" >> $@
	@echo " " >> $@
	@echo "	## Support" >> $@
	@echo "	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor." >> $@
	@echo " " >> $@
	@echo "	## Roadmap" >> $@
	@echo "	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor." >> $@
	@echo " " >> $@
	@echo "	## How you can help" >> $@
	@echo "	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor." >> $@
	@echo " " >> $@
	@echo "----" >> $@
	@echo " " >> $@
	@echo "	## For developers" >> $@
	@echo "	#### Prerequisites" >> $@
	@echo "	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor." >> $@
	@echo " " >> $@
	@echo "	#### Installation" >> $@
	@echo "	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor." >> $@
	@echo " " >> $@
	@echo "	#### Usage" >> $@
	@echo "	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor." >> $@
	@echo " " >> $@
	@echo "	### License" >> $@
	@echo "	[MIT](https://choosealicense.com/licenses/mit/)" >> $@

src/header.sql:
	@echo $(DTS)    [INFO] - Executing $@
	@echo "--etc/sql/<file_name>_###_<action>.sql" >> $@
	@echo "-------------------------------------------------------------------------------" >> $@

src/er_relationships.txt:
	@echo $(DTS)    [INFO] - Executing $@
	@echo "<table 1> 1--1 <table 2>" >> $@
	@echo "1 - Exactly one" >> $@
	@echo "? - 0 or 1" >> $@
	@echo "* - 0 or more" >> $@
	@echo "+ - 1 or more" >> $@

src/vega_embed_header.viz:
	@echo $(DTS)    [INFO] - Executing $@
	@echo " <!DOCTYPE html>" >> $@
	@echo "	<html>" >> $@
	@echo "	  <head>" >> $@
	@echo "	    <title>Data Discovery Reporting</title>" >> $@
	@echo "	    <meta charset="utf-8" />" >> $@
	@echo "	    <script src="https://cdn.jsdelivr.net/npm/vega@5.17.0"></script>" >> $@
	@echo "	    <script src="https://cdn.jsdelivr.net/npm/vega-lite@4.17.0"></script>" >> $@
	@echo "	    <script src="https://cdn.jsdelivr.net/npm/vega-embed@6.12.2"></script>" >> $@
	@echo " " >> $@
	@echo "	    <style media="screen">" >> $@
	@echo "	      /* Add space between Vega-Embed links  */" >> $@
	@echo "	      .vega-actions a {" >> $@
	@echo "	        margin-right: 5px;" >> $@
	@echo "	      }" >> $@
	@echo "	    </style>" >> $@
	@echo "	  </head>" >> $@
	@echo "	  <body>" >> $@
	@echo "	    <!-- Container for the visualization -->" >> $@
	@echo "	    <div id="vis"></div>" >> $@
	@echo "	    <script>" >> $@
	@echo "	      // Assign the specification to a local variable vlSpec." >> $@
	@echo "	      var vlSpec = {" >> $@
	@echo "	        $schema: 'https://vega.github.io/schema/vega-lite/v4.json'," >> $@
	@echo "	<!-- Embed Vega-Lite Definition Here -->" >> $@

src/vega_embed_footer.viz:
	@echo $(DTS)    [INFO] - Executing $@
	@echo "}" >> $@
	@echo "};" >> $@
	@echo " " >> $@
	@echo "// Embed the visualization in the container with id "vis"" >> $@
	@echo "vegaEmbed('#vis', vlSpec);" >> $@
	@echo "</script>" >> $@
	@echo "</body>" >> $@
	@echo "</html>" >> $@

src/vega_bar_chart.vega:
	@echo $(DTS)    [INFO] - Executing $@
	@echo "  "mark": "bar"," >> $@
	@echo "  "encoding": {" >> $@
	@echo "    "x": {"field": "end_of_week_ssmtwtf", "type": "temporal", "bin": false}," >> $@
	@echo "    "y": {"field": "total_sales_revenue", "type": "quantitative", "bin": false}," >> $@
	@echo "    "tooltip": {"sfield": "_tooltip_summary", "type": "ordinal"}" >> $@
	@echo "  }" >> $@

src/vega_line_chart.vega:
	@echo $(DTS)    [INFO] - Executing $@
	@echo "  "mark": "line"," >> $@
	@echo "  "encoding": {" >> $@
	@echo "    "x": {"field": "end_of_week_ssmtwtf", "type": "temporal", "bin": false}," >> $@
	@echo "    "y": {"field": "total_sales_revenue", "type": "quantitative", "bin": false}," >> $@
	@echo "    "tooltip": {"field": "_tooltip_summary", "type": "ordinal"}" >> $@
	@echo "  }" >> $@

src/vega_scatter_chart.vega:
	@echo $(DTS)    [INFO] - Executing $@
	@echo "  "mark": "circle"," >> $@
	@echo "  "encoding": {" >> $@
	@echo "    "x": {"field": "end_of_week_ssmtwtf", "type": "temporal", "bin": false}," >> $@
	@echo "    "y": {"field": "total_sales_revenue", "type": "quantitative", "bin": false}," >> $@
	@echo "    "tooltip": {"field": "_tooltip_summary", "type": "ordinal"}" >> $@
	@echo "  }" >> $@

src/crontab.txt:
	@echo $(DTS)    [INFO] - Executing $@
	@echo "MAILTO=""" >> $@
	@echo "#LOG_ROTATE - Rotate the log file every day." >> $@
	@echo "@daily /usr/bin/make -C </path/to/project/> -f makefile log_rotate >> </path/to/project>/var/log/cron_log.txt 2>&1" >> $@
	@echo "#Execute the data pipeline every hour" >> $@
	@echo "#*/15 * * * * /usr/bin/make -C </path/to/project/> -f makefile all >> </path/to/project>/var/log/cron_log.txt 2>&1" >> $@
	@echo "#deploy/local manually as needed" >> $@
	@echo "#0 */2 * * * /usr/bin/make -C </path/to/project/> -f makefile deploy/local >> </path/to/project>/var/log/cron_log.txt 2>&1" >> $@

src/datasette_requirements.txt:
	@echo $(DTS)    [INFO] - Executing $@
	@echo "csvkit >= 1.0.5" >> $@
	@echo "sqlite-utils >= 3.3" >> $@
	@echo "datasette >=0.54.1" >> $@
	@echo "datasette-vega >= 0.6.2" >> $@
	@echo "datasette-copyable >= 0.3.1" >> $@

src/datasette_settings.txt:
	@echo $(DTS)    [INFO] - Executing $@
	@echo "	{" >> $@
	@echo "	    "default_page_size": 1000," >> $@
	@echo "	    "sql_time_limit_ms": 5000," >> $@
	@echo "	    "max_returned_rows": 5000," >> $@
	@echo "	    "num_sql_threads": 3," >> $@
	@echo "	    "allow_facet": true," >> $@
	@echo "	    "default_facet_size": 10," >> $@
	@echo "	    "facet_time_limit_ms": 1000," >> $@
	@echo "	    "facet_suggest_time_limit_ms": 500," >> $@
	@echo "	    "suggest_facets": true," >> $@
	@echo "	    "allow_download": true," >> $@
	@echo "	    "default_cache_ttl": 5," >> $@
	@echo "	    "default_cache_ttl_hashed": 31536000," >> $@
	@echo "	    "cache_size_kb": 0," >> $@
	@echo "	    "allow_csv_stream": true," >> $@
	@echo "	    "max_csv_mb": 0," >> $@
	@echo "	    "truncate_cells_html": 2048," >> $@
	@echo "	    "force_https_urls": false," >> $@
	@echo "	    "hash_urls": false," >> $@
	@echo "	    "template_debug": false," >> $@
	@echo "	    "base_url": "/"" >> $@
	@echo "	}	" >> $@

src/datasette_metadata.yaml:
	@echo $(DTS)    [INFO] - Executing $@
	@echo "title: Modify etc/app/metadata.yml" >> $@
	@echo "license: ~" >> $@
	@echo "license_url: http://example.com/" >> $@
	@echo "source: Building Data Products" >> $@
	@echo "source_url: https://example.com/" >> $@
	@echo "databases:" >> $@
	@echo "  sales:" >> $@
	@echo "    source: ~" >> $@
	@echo "    description_html: |-" >> $@
	@echo "       <strong>Description:</strong> ~ <br>" >> $@
	@echo "       <strong>Source:</strong> ~ <br>" >> $@
	@echo "       <strong>Source table(s):</strong> ~ <p></p>" >> $@
	@echo "       <a href = "mailto: manager@example.com">~Business Contact</a><br>" >> $@
	@echo "       <a href = "mailto: tech@example.com">~Technical Contact</a>" >> $@
	@echo "    tables:" >> $@
	@echo "      table_001:" >> $@
	@echo "        description_html: |-" >> $@
	@echo "         <strong>Description:</strong> ~ <br>" >> $@
	@echo "         <strong>Source:</strong> ~ <br>" >> $@
	@echo "         <strong>Source table(s):</strong> ~ <p></p>" >> $@
	@echo "         <strong>Reports:</strong><br>" >> $@
	@echo "         <a href="http://example.com/path/to/file.html" target="_blank">~.html</a><br>" >> $@
	@echo "         <p></p>	" >> $@
