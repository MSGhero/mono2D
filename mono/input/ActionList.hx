package mono.input;

import haxe.ds.Vector;

@:forward @:build(mono.input.ActionMacros.buildInput(input.Action))
abstract ActionList(Vector<Bool>) {
	
	public function new() {
		this = new Vector(ActionMacros.count(input.Action));
		for (i in 0...this.length) this[i] = false;
	}

	public function copyFrom(al:ActionList) {
		
		for (i in 0...this.length) {
			this[i] = al[i];
		}
	}
	
	@:op([])
	public inline function get(index:Int) {
		return this.get(index);
	}
	
	@:op([])
	public inline function set(index:Int, val:Bool) {
		return this.set(index, val);
	}
}