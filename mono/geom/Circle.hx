package mono.geom;

class Circle extends Shape {
	
	public var x(get, never):Float;
	inline function get_x() { return centerX; }
	public var y(get, never):Float;
	inline function get_y() { return centerY; }
	
	// consider storing/precalcing radiusSq
	public var radius:Float;
	
	public function new(centerX:Float, centerY:Float, radius:Float) {
		super(centerX, centerY);
		
		this.radius = radius;
		type = CIRCLE;
	}
	
	public function clone() {
		return new Circle(centerX, centerY, radius);
	}
}