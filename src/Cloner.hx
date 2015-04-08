class Cloner {

    public function new():Void {}

    public function cloneClass <T> (value:T):T {
        return Type.createEmptyInstance(Type.getClass(value));
    }

}