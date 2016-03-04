import classes.ClassTypeProperty;
import classes.ABCEnum;
import cloner.Cloner;
import classes.ArrayProperty;
import classes.ClassProperty;
import classes.BoolProperty;
import classes.NullClass;
class TestCloner extends haxe.unit.TestCase {

    var cloner:Cloner;

    override public function setup() {
        cloner = new Cloner();
    }

    public function testclone() {
        var value:NullClass = new NullClass();
        assertTrue(cloner.clone(value) != null);
    }

    public function testBoolProperty() {
        var value:BoolProperty = new BoolProperty(true);
        assertTrue(cloner.clone(value).property);
    }

    public function testArrayProperty() {
        var value:ArrayProperty = new ArrayProperty([true]);
        assertTrue(cloner.clone(value).property[0]);
    }

    public function testStringMap():Void {
        var value:Map<String, Int> = new Map<String, Int>();
        value.set('you',1);
        assertTrue(cloner.clone(value).get('you') == 1);
    }

    public function testIntMap():Void {
        var value:Map<Int, Int> = new Map<Int, Int>();
        value.set(1,2);
        assertTrue(cloner.clone(value).get(1) == 2);
    }

    public function testObjectsInMap():Void {
        var value:Map<Int, NullClass> = new Map<Int, NullClass>();
        var v:NullClass = new NullClass();
        value.set(1,v);
        assertTrue(cloner.clone(value).get(1) != v);
    }

    public function testString():Void {
        assertTrue(cloner.clone('a') == 'a');
    }

    public function testClassType():Void {
        assertTrue(cloner.clone(NullClass) == NullClass);
    }

    public function testEnum():Void {
        assertTrue(cloner.clone(ABCEnum.b) == ABCEnum.b);
    }

    public function testClassProperty():Void {
        var value:ClassProperty = new ClassProperty();
        var inValue = new BoolProperty(true);
        value.property = inValue;
        var outValue:BoolProperty = cloner.clone(value).property;
        assertTrue(outValue.property);
        assertFalse(inValue == outValue);
    }

    public function testAnonObjectAreDifferentCopies():Void {
        var value = { a: 10, b: 20 };
        var clone = cloner.clone(value);
        Reflect.setField(value, 'a', 33);
        assertEquals(10, Reflect.getProperty(clone, 'a'));
    }

    public function testEmbededAnonObject():Void {
        var inner = {b: 5};
        var value = { a: 10, inner: inner };
        var clone = cloner.clone(value);
        Reflect.setField(inner, 'b', 33);

        var cloneInner = Reflect.getProperty(clone, 'inner');
        assertEquals(5, Reflect.getProperty(cloneInner, 'b'));
    }

    public function testClassRefInsideAnObj():Void {
        var value:ClassTypeProperty = new ClassTypeProperty();
        value.property = BoolProperty;
        var outValue:ClassTypeProperty = cloner.clone(value);
        assertEquals(outValue.property, BoolProperty);
    }
}