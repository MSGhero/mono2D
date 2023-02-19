package mono.interactive;

import mono.interactive.shapes.Shape;

@:structInit @:allow(mono.interactive.InteractiveSystem)
class Interactive {
	
	var enabled:Bool = false;
	public var shape:Shape;
	
	public var disabled:Bool = false;
	public var disablers:Int = 0;
	
	// something like index
	
	public var onOver:()->Void = null;
	public var onOut:()->Void = null;
	public var onSelect:()->Void = null;
	
	public function isPointWithin(x:Float, y:Float) {
		return shape.isPointWithin(x, y);
	}
}