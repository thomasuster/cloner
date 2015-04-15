import cloner.Cloner;
import classes.ClassProperty;
import classes.BoolProperty;
class TestClonerCache extends haxe.unit.TestCase {

    var cloner:Cloner;
    var input:Array<ClassProperty>;
    var outcome:Array<ClassProperty>;

    override public function setup() {
        cloner = new Cloner();
    }

    public function testReferences():Void {
        setupOutcomeWithReferences();
        assertTrue(outcome[0].property == outcome[1].property);
    }

    public function testNoSideEffects():Void {
        setupOutcomeWithReferences();
        outcome[0].property = true;
        outcome = cloner.clone(input);
        assertFalse(outcome[0].property);
    }

    function setupOutcomeWithReferences():Void {
        var a:ClassProperty = new ClassProperty();
        var b:ClassProperty = new ClassProperty();
        var c:BoolProperty = new BoolProperty();
        a.property = c;
        b.property = c;
        input = [a, b];
        outcome = cloner.clone(input);
    }
}