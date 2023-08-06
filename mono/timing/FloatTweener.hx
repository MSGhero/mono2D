package mono.timing;

class FloatTweener extends Tweener {
	
	public var onFloat:(f:Float)->Void;
	
	public var start:Float;
	public var end:Float;
	
	public function new(duration:Float, start:Float, end:Float, onFloat:(f:Float)->Void) {
		super(duration, floatTween);
		
		this.onFloat = onFloat;
		this.start = start;
		this.end = end;
	}
	
	override function dispose() {
		super.dispose();
		onFloat = null;
	}
	
	function floatTween(f:Float) {
		onFloat(start + f * (end - start));
	}
}
