package mono.input;

import input.Action;

class Input {
	
	public var actions(default, null):ActionSet;
	@:allow(mono.input.InputSystem)
	var previous(default, null):ActionSet;
	
	public var devices(default, null):Array<InputDevice>;
	public var enabled:Bool;
	
	public var justReleased(get, never):ActionList;
	inline function get_justReleased() { return actions.justReleased; }
	public var justPressed(get, never):ActionList;
	inline function get_justPressed() { return actions.justPressed; }
	public var pressed(get, never):ActionList;
	inline function get_pressed() { return actions.pressed; }
	
	public function new() {
		actions = new ActionSet();
		previous = new ActionSet();
		devices = [];
		enabled = true;
	}
	
	public function addDevice(id:InputDevice) {
		devices.push(id);
	}
}

abstract InputMapping(Array<Array<Int>>) {

	public function new() this = [];

	@:op([])
	public function get(action:Action) {
		return this[action];
	}

	@:op([])
	public function set(action:Action, mapping:Array<Int>) {
		return this[action] = mapping;
	}
}