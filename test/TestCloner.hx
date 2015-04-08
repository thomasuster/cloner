import classes.SingleProperty;
import classes.NullClass;
class TestCloner extends haxe.unit.TestCase {

    var cloner:Cloner;

    override public function setup() {
        cloner = new Cloner();
    }

    public function testClondeClass() {
        var klass:NullClass = new NullClass();
        assertTrue(cloner.cloneClass(klass) != null);
    }

    public function testBoolProperty() {
        var singleProperty:SingleProperty = new SingleProperty();
        singleProperty.property = true;
        assertTrue(cloner.cloneClass(singleProperty).property);
    }

}