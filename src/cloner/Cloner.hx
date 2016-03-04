package cloner;
import Array;
import haxe.ds.ObjectMap;
import Type.ValueType;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
class Cloner {

    var cache:ObjectMap<Dynamic,Dynamic>;
    var classHandles:Map<String,Dynamic->Dynamic>;
    var stringMapCloner:MapCloner<String>;
    var intMapCloner:MapCloner<Int>;

    public function new():Void {
        stringMapCloner = new MapCloner(this,StringMap);
        intMapCloner = new MapCloner(this,IntMap);
        classHandles = new Map<String,Dynamic->Dynamic>();
        classHandles.set('String',returnString);
        classHandles.set('Array',cloneArray);
        classHandles.set('haxe.ds.StringMap',stringMapCloner.clone);
        classHandles.set('haxe.ds.IntMap',intMapCloner.clone);
    }

    function returnString(v:String):String {
        return v;
    }

    public function clone <T> (v:T):T {
        cache = new ObjectMap<Dynamic,Dynamic>();
        var outcome:T = _clone(v);
        cache = null;
        return outcome;
    }

    public function _clone <T> (v:T):T {
        if(Type.getClassName(cast v) != null)
            return v;
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
                return handleAnonymous(v);
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

    function handleAnonymous (v:Dynamic):Dynamic {
        var properties:Array<String> = Reflect.fields(v);
        var anonymous:Dynamic = {};
        for (i in 0...properties.length) {
            var property:String = properties[i];
            Reflect.setField(anonymous, property, _clone(Reflect.getProperty(v, property)));
        }
        return anonymous;
    }

    function handleClass <T> (c:Class<T>,inValue:T):T {
        var handle:T->T = classHandles.get(Type.getClassName(c));
        if(handle == null)
            handle = cloneClass;
        return handle(inValue);
    }

    function cloneArray <T> (inValue:Array<T>):Array<T> {
        var array:Array<T> = inValue.copy();
        for (i in 0...array.length)
            array[i] = _clone(array[i]);
        return array;
    }

    function cloneClass <T> (inValue:T):T {
        var outValue:T = Type.createEmptyInstance(Type.getClass(inValue));
        var fields:Array<String> = Reflect.fields(inValue);
        for (i in 0...fields.length) {
            var field = fields[i];
            var property = Reflect.getProperty(inValue, field);
            Reflect.setField(outValue, field, _clone(property));
        }
        return outValue;
    }

}