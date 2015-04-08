import classes.NullClass;
class TestCloner extends haxe.unit.TestCase {

    public function testClondeClass() {
        var cloner:Cloner = new Cloner();
        var klass:NullClass = new NullClass();
        assertTrue(cloner.cloneClass(klass) != null);
    }

}