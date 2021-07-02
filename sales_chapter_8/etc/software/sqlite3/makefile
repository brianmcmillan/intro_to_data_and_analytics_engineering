# https://sqlite.org/contrib/download/extension-functions.c
SQLITE_VERSION:=3350500
URL_SQLITE="https://sqlite.org/2021/sqlite-amalgamation-$(SQLITE_VERSION).zip" #From https://sqlite.org/download.html
URL_EXTENSION_FUNCTIONS:="https://sqlite.org/contrib/download/extension-functions.c/download/extension-functions.c?get=25"
URL_SHA1:="https://www.sqlite.org/src/raw/c8f2253c8792ffab9517695ea7d88c079f0395a5505eefef5c8198fe184ed5ac?at=sha1.c"
URL_PERCENTILE:="https://www.sqlite.org/src/raw/b9086e223d583bdaf8cb73c98a6539d501a2fc4282654adbfea576453d82e691?at=percentile.c"

all: sqlite3 libsqlitefunctions.dylib sha1.dylib percentile.dylib

sqlite-amalgamation.zip:
	curl -o sqlite-amalgamation-$(SQLITE_VERSION).zip $(URL_SQLITE)
	unzip -o sqlite-amalgamation-$(SQLITE_VERSION).zip

sqlite3: sqlite-amalgamation.zip
	gcc -Os -I. \
	-DSQLITE_DEFAULT_FILE_PERMISSIONS=0644 \
	-DSQLITE_DEFAULT_LOCKING_MODE=0 \
	-DSQLITE_ENABLE_API_ARMOR \
	-DSQLITE_ENABLE_COLUMN_METADATA \
	-DSQLITE_ENABLE_DBSTAT_VTAB \
	-DSQLITE_ENABLE_FTS4 \
	-DSQLITE_ENABLE_FTS5 \
	-DSQLITE_ENABLE_GEOPOLY \
	-DSQLITE_ENABLE_JSON1 \
	-DSQLITE_ENABLE_RBU \
	-DSQLITE_ENABLE_RTREE \
	-DSQLITE_ENABLE_STAT4 \
	-DSQLITE_ENABLE_MATH_FUNCTIONS \
	-DSQLITE_OMIT_DEPRECATED \
	-DSQLITE_OMIT_TRACE \
	-DSQLITE_SOUNDEX \
	-DSQLITE_THREADSAFE=2 \
	-DHAVE_USLEEP \
	-DHAVE_READLINE \
	-DSQLITE_DEFAULT_FOREIGN_KEYS=0 \
	-DSQLITE_DQS=0 \
	-DSQLITE_ENABLE_EXPLAIN_COMMENTS \
	sqlite-amalgamation-$(SQLITE_VERSION)/shell.c \
	sqlite-amalgamation-$(SQLITE_VERSION)/sqlite3.c \
	-ldl -lreadline -lncurses -o sqlite3

extension-functions.c:
	#curl -o extension-functions.c "https://sqlite.org/contrib/download/extension-functions.c/download/extension-functions.c?get=25"
	curl -o $@ $(URL_EXTENSION_FUNCTIONS)

sha1.c:
	curl -o $@ $(URL_SHA1)

percentile.c:
	curl -o $@ $(URL_PERCENTILE)

libsqlitefunctions.dylib: extension-functions.c
	@#gcc -fPIC -lm -shared extension-functions.c -o libsqlitefunctions.so #linux
	gcc -fno-common -dynamiclib $< -o $@ #macos
	@echo "Usage:"
	@echo "  sqlite> SELECT load_extension('/path/to/$@');"
	@echo "  sqlite> SELECT 1, log(1);--1|0.0;"

sha1.dylib: sha1.c
	@#gcc -fPIC -lm -shared extension-functions.c -o libsqlitefunctions.so #linux
	gcc -fno-common -dynamiclib $< -o $@ #macos
	#gcc -fno-common -DSQLITE_INNOCUOUS=0 -DSQLITE_DIRECTONLY=0 -dynamiclib sha1.c -o sha1.dylib
	#gcc -fno-common -dynamiclib sha1.c -o sha1.dylib
	@echo "Usage:"
	@echo "  sqlite> SELECT load_extension('/path/to/$@');"
	@echo "  sqlite> SELECT "cat", SHA1("cat");--cat|9D989E8D27DC9E0EC3389FC855F142C3D40F0C50;"

percentile.dylib: percentile.c
	gcc -fno-common -dynamiclib $< -o $@ #macos

clean:
	rm -fr *.zip *.c sqlite-amalgamation-$(SQLITE_VERSION)

uninstall:
	@rm -f *.c
	@rm -f *.dylib
	@rm -f *.dll
	@rm -f *.so
