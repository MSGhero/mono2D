package mono.geom;

import h2d.col.Point;

class RightTri extends Shape {
	
	public var width(get, never):Float;
	inline function get_width() { return a.x - center.x; }
	public var height(get, never):Float;
	inline function get_height() { return b.y - center.y; }
	
	public var a(default, null):Point;
	public var b(default, null):Point;
	public var c(get, never):Point;
	inline function get_c() { return center; }
	
	public function new(centerX:Float, centerY:Float, width:Float, height:Float) {
		super(centerX, centerY);
		
		// maybe save wh and reconstruct ab in setter or get/never
		
		a = new Point(width + centerX, 0);
		b = new Point(0, height + centerY);
		
		type = RTRI;
	}
	
	public function lerpC(x:Float) {
		return b.y + height / width * (x - center.x);
	}
}