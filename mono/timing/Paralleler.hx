package mono.timing;

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
	
	public inline function push(up:Updater) {
		updaters.push(up);
	}
	
	public inline function remove(up:Updater) {
		updaters.remove(up);
	}
	
	override function update(dt:Float) {
		
		if (isActive) {
			
			for (up in updaters) {
				
				if (up.repetitions == 0) {
					if (up.autoDispose) {
						up.dispose();
						updaters.remove(up);
					}
				}
				
				else {
					up.update(dt * timescale);
				}
			}
		}
	}
	
	override function incrementCounter(dt:Float) { }
	override function decrementCounter(dt:Float) { }
}