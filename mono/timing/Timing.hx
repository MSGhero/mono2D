package mono.timing;

class Timing {
	
	public static function every(dur:Float, reps:Int = -1, callback:() -> Void, onComplete:() -> Void = null, autoDispose:Bool = false) {
		final ev = new Updater(dur, reps, false);
		ev.callback = callback; ev.onComplete = onComplete;
		ev.autoDispose = autoDispose;
		return ev;
	}
	
	public static function delay(dur:Float, onComplete:() -> Void, autoDispose:Bool = false) {
		final del = new Updater(dur, 1, false);
		del.onComplete = onComplete;
		del.autoDispose = autoDispose;
		return del;
	}
	
	public static function tween(dur:Float, onUpdate:(f:Float) -> Void, onComplete:() -> Void = null, ease:(perc:Float)->Float = null, autoDispose:Bool = false) {
		final tw = new Tweener(dur, onUpdate);
		tw.onComplete = onComplete;
		if (ease != null) tw.ease = ease;
		tw.autoDispose = autoDispose;
		return tw;
	}
	
	public static function float(dur:Float, start:Float, end:Float, onFloat:(f:Float) -> Void, onComplete:() -> Void = null, ease:(perc:Float)->Float = null, autoDispose:Bool = false) {
		final ftw = new FloatTweener(dur, start, end, onFloat);
		ftw.onComplete = onComplete;
		if (ease != null) ftw.ease = ease;
		ftw.autoDispose = autoDispose;
		return ftw;
	}
	
	public static function cycle(updaters:Array<Updater>, overallReps:Int = -1, autoDispose:Bool = false) {
		final cycle = new Cycler(overallReps, updaters);
		cycle.autoDispose = autoDispose;
		return cycle;
	}
}