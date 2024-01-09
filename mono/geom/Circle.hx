package mono.geom;

class Circle extends Shape {
	
	public var x(get, never):Float;
	inline function get_x() { return center.x; }
	public var y(get, never):Float;
	inline function get_y() { return center.y; }
	
	// consider storing/precalcing radiusSq
	public var radius:Float;
	
	inline function get_left() return center.x - radius;
	inline function get_right() return center.x + radius;
	inline function get_top() return center.y - radius;
	inline function get_bottom() return center.y + radius;
	
	public function new(centerX:Float, centerY:Float, radius:Float) {
		super(centerX, centerY);
		
		this.radius = radius;
		type = CIRCLE;
	}
	
	public function clone() {
		return new Circle(center.x, center.y, radius);
	}
}