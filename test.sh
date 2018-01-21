set -e
cd test
haxe compile.hxml
cd ..
echo CPP
bin/test/TestMain-debug
echo NEKO
neko bin/test/TestMain.n