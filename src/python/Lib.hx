package python;

import python.lib.Types;



class HaxeIterable<T> 
{
  var x :NativeIterable<T>;
  public inline function new (x:NativeIterable<T>) {
    this.x = x;
  }

  public inline function iterator ():HaxeIterator<T> return new HaxeIterator(x.__iter__());
}

class HaxeIterator<T> 
{
  var it :NativeIterator<T>;
  var x:Null<T> = null;
  var checked = false;

  public function new (it:NativeIterator<T>) {
    this.it = it;
  }

  public inline function next ():T
  {
    checked = false;
    return x;
  }

  public function hasNext ():Bool
  {
    if (checked) {
      return x != null;
    } else {
      try {
        x = it.__next__();
      } catch (s:StopIteration) {
        x = null;
      }
      checked = true;
      return x != null;  
    }
    
  }
}

class Lib
{
	/*
    public static inline function assert(value:Dynamic)
    {
        untyped __assert__(value);
    }

    public static function random(max:Int)
    {
       var r = new dart.math.Random(); //TODO(av) benchmark / test caching Random instance as static
       return r.nextInt(max);
    }
    */

    public static function print(v:Dynamic)
    {
       python.lib.Sys.stdout.write(Std.string(v));
       python.lib.Sys.stdout.flush();
    }

    public static function println(v:Array<Dynamic>)
    {
       for (e in v) {
          untyped __python__("print")(Std.string(e));
       }
    }

    public static function toPythonIterable <T>(it:Iterable<T>):python.lib.Types.NativeIterable<T> 
    {
      return {
        __iter__ : function () {
          var it1 = it.iterator();
          return new PyIterator({
            __next__ : function ():T {
              if (it1.hasNext()) {
                return it1.next();
              } else {
                throw new python.lib.Types.StopIteration();
              }
            }
          });
        }
      }
    }

    public static inline function toHaxeIterable <T>(it:NativeIterable<T>):HaxeIterable<T> 
    {
      return new HaxeIterable(it);
    }

    public static inline function toHaxeIterator <T>(it:NativeIterator<T>):HaxeIterator<T> 
    {
      return new HaxeIterator(it);
    }


    
}
