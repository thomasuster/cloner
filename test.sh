set -e
cd test
haxe compile.hxml
cd ..
bin/test/TestMain
