package mono.geom;

class Circle extends Shape {
	
	public var x(get, never):Float;
	inline function get_x() { return center.x; }
	public var y(get, never):Float;
	inline function get_y() { return center.y; }
	
	// consider storing/precalcing radiusSq
	public var radius:Float;
	
	inline function get_left() return centerX - radius;
	inline function get_right() return centerX + radius;
	inline function get_top() return centerY - radius;
	inline function get_bottom() return centerY + radius;
	
	public function new(centerX:Float, centerY:Float, radius:Float) {
		super(centerX, centerY);
		
		this.radius = radius;
		type = CIRCLE;
	}
	
	public function clone() {
		return new Circle(centerX, centerY, radius);
	}
}