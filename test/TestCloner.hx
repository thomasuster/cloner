import classes.ClassProperty;
import classes.BoolProperty;
import classes.NullClass;
class TestCloner extends haxe.unit.TestCase {

    var cloner:Cloner;

    override public function setup() {
        cloner = new Cloner();
    }

    public function testClondeClass() {
        var value:NullClass = new NullClass();
        assertTrue(cloner.cloneClass(value) != null);
    }

    public function testBoolProperty() {
        var value:BoolProperty = new BoolProperty(true);
        assertTrue(cloner.cloneClass(value).property);
    }

    public function testClassProperty():Void {
        var value:ClassProperty = new ClassProperty();
        var inValue = new BoolProperty(true);
        value.property = inValue;
        var outValue:BoolProperty = cloner.cloneClass(value).property;
        assertTrue(outValue.property);
        assertFalse(inValue == outValue);
    }
}