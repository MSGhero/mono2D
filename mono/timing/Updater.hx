package mono.timing;

class Updater {
	
	public var duration:Float; // setter, throw if <= 0. causes inf while loop
	public var repetitions:Int = -1;
	public var paused:Bool = false;
	public var autoDispose:Bool;
	
	public var callback:()->Void = null;
	public var onComplete:()->Void = null;
	public var onCancel:()->Void = null;
	
	public var isActive(get, never):Bool;
	inline function get_isActive() { return !paused && repetitions != 0; }
	
	public var isComplete(get, never):Bool;
	inline function get_isComplete() { return repetitions == 0; }
	
	public var isTimeLeft(get, never):Bool;
	inline function get_isTimeLeft() { return counter > 0; }
	
	public var isReady(get, never):Bool;
	inline function get_isReady() { return counter >= duration; }
	
	var counter:Float = 0;
	var timescale:Float = 1.0;
	
	public function new(duration:Float, repetitions:Int = -1, autoDispose:Bool = false) {
		this.duration = duration;
		this.repetitions = repetitions;
		this.autoDispose = autoDispose;
	}
	
	public function dispose() {
		callback = null;
		onComplete = null;
		onCancel = null;
	}
	
	public function cancel() {
		repetitions = 0;
		if (onCancel != null) onCancel();
	}
	
	public inline function resetCounter() {
		counter = 0;
	}
	
	public function forceCallback() {
		
		if (callback != null) callback();
		
		if (repetitions > 0) {
			--repetitions;
			if (repetitions == 0 && onComplete != null) onComplete();
		}
		
		resetCounter();
	}
	
	public function forceComplete() {
		if (onComplete != null) onComplete();
		repetitions = 0;
		resetCounter();
	}
	
	public function update(dt:Float) {
		
		if (isActive) {
			
			while (isReady) {
				
				if (callback != null) callback();
				
				if (repetitions > 0) {
					--repetitions;
					if (repetitions == 0 && onComplete != null) onComplete();
				}
				
				if (duration <= 0) break; // avoid infinite while loops/allow for instant 0 duration calls
				else counter -= duration;
			}
			
			incrementCounter(dt);
		}
	}
	
	function incrementCounter(dt:Float) {
		counter += dt * timescale;
	}
	
	function decrementCounter(dt:Float) {
		counter -= dt * timescale;
	}
}