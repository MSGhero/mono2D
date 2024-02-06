package mono.timing;

class JitterTweener extends FloatTweener {
	
	public var amplitude:Float;
	
	var steps:Array<Float>;
	
	public function new(duration:Float, start:Float, end:Float, onFloat:(f:Float)->Void) {
		super(duration, start, end, onFloat);
		
		amplitude = 3;
		
		steps = [for (i in 0...10) Math.random() * (i % 2) * -1]; // make this more generic
		steps.push(0);
	}
	
	override function floatTween(f:Float) {
		final fStep = Std.int(f * (steps.length - 1));
		onFloat(start + f * (end - start) + steps[fStep] * amplitude);
	}
}
