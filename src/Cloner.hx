import Map.IMap;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
class Cloner {

    var noArgs:Array<Dynamic>;

    public function new():Void {
        noArgs = [];
    }

    public function clone(inValue:Dynamic):Dynamic {
        if(!Reflect.isObject(inValue))
            return inValue;
        else if(Std.is(inValue,Array)) {
            return cloneArray(inValue);
        }
        else if(Std.is(inValue,StringMap)) {
            return cloneMap(inValue, StringMap);
        }
        else if(Std.is(inValue,IntMap)) {
            return cloneMap(inValue, IntMap);
        }
        else
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