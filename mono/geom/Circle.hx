package mono.geom;

class Circle extends Shape {
	
	public var x(get, never):Float;
	inline function get_x() { return center.x; }
	public var y(get, never):Float;
	inline function get_y() { return center.y; }
	
	// consider storing/precalcing radiusSq
	public var radius:Float;
	
	public function new(centerX:Float, centerY:Float, radius:Float) {
		super(centerX, centerY);
		
		this.radius = radius;
		type = CIRCLE;
	}
}