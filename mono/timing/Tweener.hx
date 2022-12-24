package mono.timing;

class Tweener extends Updater {
	
	public var onUpdate:(easedPerc:Float)->Void;
	public var ease:(perc:Float)->Float = f -> return f;
	
	public function new(duration:Float, onUpdate:(easedPerc:Float)->Void) {
		super(duration, 1, true);
		
		this.onUpdate = onUpdate;
	}
	
	override function dispose() {
		super.dispose();
		onUpdate = null;
		ease = null;
	}
	
	override function update(dt:Float) {
		
		if (isActive) {
			
			if (isReady) {
				
				if (callback != null) callback();
				
				if (repetitions > 0) {
					--repetitions;
					if (repetitions == 0 && onComplete != null) onComplete();
				}
			}
			
			incrementCounter(dt);
		}
	}
	
	override function incrementCounter(dt:Float) {
		
		if (counter >= duration) return;
		
		super.incrementCounter(dt);
		
		if (onUpdate != null) {
			
			if (counter >= duration) {
				if (repetitions == 1) counter = duration;
				else counter -= duration;
			}
			
			onUpdate(ease(counter / duration));
		}
	}
}
