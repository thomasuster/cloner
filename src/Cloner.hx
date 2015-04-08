class Cloner {

    public function new():Void {}

    public function cloneClass <T> (inValue:T):T {
        var outValue:T = Type.createEmptyInstance(Type.getClass(inValue));
        var fields:Array<String> = Reflect.fields(inValue);
        for (i in 0...fields.length) {
            var field = fields[i];
            Reflect.setField(outValue, field, Reflect.getProperty(inValue,field));
        }
        return outValue;
    }

}