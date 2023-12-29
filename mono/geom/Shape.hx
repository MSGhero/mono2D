package mono.geom;

abstract class Shape {
	
	public var centerX:Float;
	public var centerY:Float;
	
	public var type(default, null):ShapeType;
	
	public function new(centerX:Float, centerY:Float) {
		this.centerX = centerX;
		this.centerY = centerY;
	}
	
	public abstract function clone():Shape;
	
	// maybe get,never
	public inline function asCircle() {
		return (cast this:Circle);
	}
	
	public inline function asRect() {
		return (cast this:Rect);
	}
}

enum ShapeType {
	POINT;
	CIRCLE;
	RECT;
}