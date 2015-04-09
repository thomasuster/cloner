package cloner;
import haxe.ds.ObjectMap;
import haxe.Serializer;
import Type.ValueType;
import Map.IMap;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
class Cloner {

    var noArgs:Array<Dynamic>;
    var cache:ObjectMap<Dynamic,Dynamic>;

    public function new():Void {
        noArgs = [];
        cache = new ObjectMap<Dynamic,Dynamic>();
    }

    public function clone(v:Dynamic):Dynamic {
        switch(Type.typeof(v)){
            case TNull:
                return null;
            case TInt:
                return v;
            case TFloat:
                return v;
            case TBool:
                return v;
            case TObject:
                return v;
            case TFunction:
                return null;
            case TClass(c):
                if(!cache.exists(v))
                    cache.set(v,handleClass(c, v));
                return cache.get(v);
            case TEnum(e):
                return v;
            case TUnknown:
                return null;
        }
    }

    function handleClass(c:Class<Dynamic>,inValue:Dynamic):Dynamic {
        var name = Type.getClassName(c);
        if(name == 'String')
            return inValue;
        if(name == 'Array')
            return cloneArray(inValue);
        if(name == 'haxe.ds.StringMap')
            return cloneMap(inValue, StringMap);
        else if(name == 'haxe.ds.IntMap')
            return cloneMap(inValue, IntMap);
        return cloneClass(inValue);
    }

    function cloneMap <K,Dynamic> (inValue:IMap<K,Dynamic>, type:Class<IMap<K,Dynamic>>):IMap<K,Dynamic> {
        var inMap:IMap<K,Dynamic> = inValue;
        var map:IMap<K,Dynamic> = Type.createInstance(type, noArgs);
        for (key in inMap.keys()) {
            map.set(key, inMap.get(key));
        }
        return map;
    }

    function cloneArray(inValue:Array<Dynamic>):Dynamic {
        var inArray:Array<Dynamic> = inValue;
        var array:Array<Dynamic> = inArray.copy();
        for (i in 0...array.length)
            array[i] = clone(array[i]);
        return array;
    }

    function cloneClass <T> (inValue:T):T {
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