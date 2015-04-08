class TestProject extends haxe.unit.TestCase {

    public function testIsNotExploding() {
        var project:Project = new Project();
        assertTrue(project.returnTrue());
    }

}