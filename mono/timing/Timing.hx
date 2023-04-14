package mono.timing;

class Timing {
	
	public static function every(dur:Float, reps:Int = -1, callback:() -> Void, onComplete:() -> Void = null) {
		final ev = new Updater(dur, reps, false);
		ev.callback = callback; ev.onComplete = onComplete;
		return ev;
	}
	
	public static function delay(dur:Float, onComplete:() -> Void) {
		final del = new Updater(dur, 1, false);
		del.onComplete = onComplete;
		return del;
	}
	
	// maybe make TweenerProps<T> that has from<T> to<T> dur onComplete ease, etc
	public static function tween(dur:Float, onUpdate:(f:Float) -> Void, onComplete:() -> Void = null) {
		final tw = new Tweener(dur, onUpdate);
		tw.onComplete = onComplete;
		return tw;
	}
	
	public static function cycle(updaters:Array<Updater>, overallReps:Int = -1) {
		final cycle = new Cycler(overallReps, updaters);
		return cycle;
	}
}