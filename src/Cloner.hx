class Cloner {

    public function new():Void {}

    public function clone(inValue:Dynamic):Dynamic {
        if(!Reflect.isObject(inValue))
            return inValue;
        else if(Std.is(inValue,Array)) {
            var inArray:Array<Dynamic> = inValue;
            var array:Array<Dynamic> = inArray.copy();
            for (i in 0...array.length)
                array[i] = clone(array[i]);
            return array;
        }
        else
            return cloneClass(inValue);
    }

    public function cloneClass <T> (inValue:T):T {
        var outValue:T = Type.createEmptyInstance(Type.getClass(inValue));
        var fields:Array<String> = Reflect.fields(inValue);
        for (i in 0...fields.length) {
            var field = fields[i];
            var property = Reflect.getProperty(inValue, field);
            Reflect.setField(outValue, field, clone(property));
        }
        return outValue;
    }

}