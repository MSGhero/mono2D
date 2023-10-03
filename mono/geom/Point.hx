package mono.geom;

class Point extends Shape {
	
	public var x(get, never):Float;
	inline function get_x() { return centerX; }
	public var y(get, never):Float;
	inline function get_y() { return centerY; }
	
	public function new(centerX:Float, centerY:Float) {
		super(centerX, centerY);
		
		type = POINT;
	}
}