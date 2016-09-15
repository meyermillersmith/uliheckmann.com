/**
 * Map Datatype
 */
class lessrain.lib.utils.Map
{
	/** Key Holder */
	private var _keys : Array;
	
	/** Value Holder */
	private var _values : Array;

	/**
	* Constructor
	* Create an empty Map
	*/
	public function Map() {
		clear();
	}
	
	/**
	 * Check if the Map contains <code>key</code>
	 * @param key	The key to be searched for
	 * @return		<code>true</code> if <code>key</code> exists
	 */
	public function containsKey(key_:Object):Boolean {
		return (findKey(key_) > -1);
	}
	
	/**
	 * Check if the Map contains a element with the value <code>value</code>
	 * @param value	The value to be checked for
	 * @return		<code>true</code> if <code>value</code> could be found
	 */
	public function containsValue(value_:Object):Boolean {
		return (findValue(value_) > -1);
	}
	
	/**
	 * Get an array that contains all keys that have a value mapped to it
	 * @return An array that contains all keys
	 */
	public function getKeys():Array {
		return _keys.slice();
	}
	
	/**
	 * Get an array that contains all values that are mapped to a key
	 * @return	An array that contains all mapped values
	 */
	public function getValues():Array {
		return _values.slice();
	}
	
	/**
	 * Returns the value that is mapped to <code>key</code>
	 * @param key	The key to return the corresponding value for
	 * @return		The value corresponding to <code>key</code>
	 */
	public function getAt(key_:Object):Object {
		return _values[findKey(key_)];
	}
	
	/**
	 * Maps the given <code>key</code> to the value <code>val</code>
	 * @description Both <code>key</code> and <code>val</code> are allowed to be <code>null</code> and
	 * <code>undefined</code>.
	 * @param key	The key used as identifier for the <code>val</code>
	 * @param value	The value to map to the <code>key</code>
	 * @return		The value
	 */
	public function putAt(key_:Object, value_:Object):Object {
		var i:Number = findKey(key_); 
		if(i < 0) {
			_keys.push(key_);
			_values.push(value_);
			return value_;
		}
		_values[i] = value_;
		return value_;
	}		
	
	/**
	 * Copies all mappings from <code>map</code> to this map.
	 * @param map	The mappings to add to this map
	 */
	public function merge(map_:Map):Void {
		var values:Array = map_.getValues();
		var keys:Array = map_.getKeys();
		var l:Number = keys.length;
		for(var i:Number = 0; i < l; i++) {
			putAt(keys[i], values[i]);
		}
	}
	
	/**
	* Clear the map
	*/
	public function clear():Void {
		_keys = new Array();
		_values = new Array();
	}
	
	/**
	 * Removes the item <code>key</code>
	 * @param key	The key identifying the mapping to remove
	 * @return		The value that was originally mapped to <code>key</code>
	 */
	public function removeAt(key_:Object):Object {
		var i:Number = findKey(key_);
		if(i > -1) {
			_keys.splice(i, 1);
			return _values.splice( i, 1 );
		}
		return null;
	}
	
	/**
	 * Get the map size
	 * @return Number of elements stored in the map
	 */
	public function size():Number {
		return _keys.length;
	}
	
	/**
	 * Search for the value <code>v</code> and return its position
	 * @param value	The value to search for
	 * @return		The index
	 */
	private function findValue(value_:Object):Number {
		var a:Array = _values;
		var i:Number = a.length;
		while(a[ --i ] !== value_ && i >- 1);
		return i;
	}
	
	/**
	 * Search for the key <code>key</code> and return its position
	 * @param key	The key to search for
	 * @return		The index
	 */
	private function findKey(key_:Object):Number {
		var a:Array = _keys;
		var i:Number = a.length;
		while(a[ --i ] !== key_ && i >- 1);
		return i;
	}
	
}