package mono.geom;

import h2d.col.Point;

abstract class Shape {
	
	public var center:Point;
	
	public var type(default, null):ShapeType;
	
	public function new(centerX:Float, centerY:Float) {
		center = new Point(centerX, centerY);
	}
	
	// maybe get,never
	public inline function asCircle() {
		return (cast this:Circle);
	}
	
	public inline function asRect() {
		return (cast this:Rect);
	}
}

enum ShapeType {
	CIRCLE;
	RECT;
	RTRI;
}