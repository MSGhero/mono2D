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
	
	public static function tween(dur:Float, onUpdate:(f:Float) -> Void, onComplete:() -> Void = null, ease:(perc:Float)->Float = null) {
		final tw = new Tweener(dur, onUpdate);
		tw.onComplete = onComplete;
		if (ease != null) tw.ease = ease;
		return tw;
	}
	
	public static function float(dur:Float, start:Float, end:Float, onFloat:(f:Float) -> Void, onComplete:() -> Void = null, ease:(perc:Float)->Float = null) {
		final ftw = new FloatTweener(dur, start, end, onFloat);
		ftw.onComplete = onComplete;
		if (ease != null) ftw.ease = ease;
		return ftw;
	}
	
	public static function cycle(updaters:Array<Updater>, overallReps:Int = -1) {
		final cycle = new Cycler(overallReps, updaters);
		return cycle;
	}
}