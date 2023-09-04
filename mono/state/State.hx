package mono.state;

import ecs.Universe;

abstract class State {
	
	public var active:Bool;
	var ecs:Universe;
	
	public function new(ecs:Universe) {
		active = false;
		this.ecs = ecs;
	}
	
	public abstract function init():Void;
	public abstract function destroy():Void;
	public abstract function reset():Void;
	
	public function enter() {
		active = true;
	}
	
	public function exit() {
		active = false;
	}
}