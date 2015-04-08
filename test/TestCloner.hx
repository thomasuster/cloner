import classes.ArrayProperty;
import classes.ClassProperty;
import classes.BoolProperty;
import classes.NullClass;
class TestCloner extends haxe.unit.TestCase {

    var cloner:Cloner;

    override public function setup() {
        cloner = new Cloner();
    }

    public function testCloneClass() {
        var value:NullClass = new NullClass();
        assertTrue(cloner.cloneClass(value) != null);
    }

    public function testBoolProperty() {
        var value:BoolProperty = new BoolProperty(true);
        assertTrue(cloner.cloneClass(value).property);
    }

    public function testArrayProperty() {
        var value:ArrayProperty = new ArrayProperty([true]);
        assertTrue(cloner.cloneClass(value).property[0]);
    }

    public function testStringMap():Void {
        var value:Map<String, Int> = new Map<String, Int>();
        value.set('you',1);
        assertTrue(cloner.clone(value).get('you') == 1);
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