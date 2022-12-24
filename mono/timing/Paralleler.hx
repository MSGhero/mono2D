package mono.timing;

import timing.Updater;

class Paralleler extends Updater {
	
	public var updaters:Array<Updater>;
	
	public function new(updaters:Array<Updater>) {
		super(0, 1, false);
		
		this.updaters = updaters;
	}
	
	override function dispose() {
		super.dispose();
		
		if (updaters != null) {
			for (up in updaters) up.dispose();
			updaters = null;
		}
	}
	
	override function cancel() {
		super.cancel();
		
		if (updaters != null) {
			for (up in updaters) up.cancel();
		}
	}
	
	override function update(dt:Float) {
		
		if (isActive) {
			
			for (up in updaters) {
				up.update(dt);
			}
		}
	}
	
	override function incrementCounter(dt:Float) { }
	override function decrementCounter(dt:Float) { }
}