package mono.geom;

class Point extends Shape {
	
	public var x(get, never):Float;
	inline function get_x() { return centerX; }
	public var y(get, never):Float;
	inline function get_y() { return centerY; }
	
	inline function get_left() return centerX;
	inline function get_right() return centerX;
	inline function get_top() return centerY;
	inline function get_bottom() return centerY;
	
	public function new(centerX:Float, centerY:Float) {
		super(centerX, centerY);
		
		type = POINT;
	}
	
	public function clone() {
		return new Point(centerX, centerY);
	}
}