package mono.ds;

// Allows safe iteration and array ops even if this array is null
// (in practice, the inlining turns into a null check around otherwise unsafe ops)
// thanks @rudy
abstract LazyArray<T>(Array<T>) from Array<T> to Array<T> {
	
	public var length(get, never):Int;
	inline function get_length() { return this == null ? 0 : this.length; }
	
	public inline function iterator():Iterator<T> {
		return new LazyIterator(this);
	}
	
	public inline function push(x:T) {
		if (this == null) this = [x];
		else this.push(x);
	}
}

private class LazyIterator<T> {
	final empty:Bool;
	final array:Array<T>;
	var current:Int = 0;

	public inline function new(array:Null<Array<T>>) {
		this.array = array;
		empty = array == null;
	}

	public inline function hasNext() {
		return !empty && current < array.length;
	}

	public inline function next() {
		return array[current++];
	}
}
