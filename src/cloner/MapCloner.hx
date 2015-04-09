package cloner;
import cloner.Cloner;
import Type.ValueType;
import Map.IMap;
class MapCloner<K>{

    var cloner:Cloner;
    var type:Class<IMap<K,Dynamic>>;
    var noArgs:Array<Dynamic>;

    public function new(cloner:Cloner, type:Class<IMap<K,Dynamic>>):Void {
        this.cloner = cloner;
        this.type = type;
        noArgs = [];
    }

    public function clone <K,Dynamic> (inValue:IMap<K,Dynamic>):IMap<K,Dynamic> {
        var inMap:IMap<K,Dynamic> = inValue;
        var map:IMap<K,Dynamic> = cast Type.createInstance(type, noArgs);
        for (key in inMap.keys()) {
            map.set(key, cloner._clone(inMap.get(key)));
        }
        return map;
    }
}