package mono.geom;

abstract class Shape {
	
	public var centerX:Float;
	public var centerY:Float;
	
	public var type(default, null):ShapeType;
	
	public var left(get, never):Float;
	abstract function get_left():Float;
	public var right(get, never):Float;
	abstract function get_right():Float;
	public var top(get, never):Float;
	abstract function get_top():Float;
	public var bottom(get, never):Float;
	abstract function get_bottom():Float;
	
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