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
	
	inline function get_left() return Math.min(center.x, center.x + width);
	inline function get_right() return Math.max(center.x, center.x + width);
	inline function get_top() return Math.min(center.y, center.y + height);
	inline function get_bottom() return Math.max(center.y, center.y + height);
	
	public function new(cornerX:Float, cornerY:Float, width:Float, height:Float) {
		super(cornerX, cornerY);
		
		// maybe save wh and reconstruct ab in setter or get/never
		
		a = new Point(width + cornerX, 0);
		b = new Point(0, height + cornerY);
		
		type = RTRI;
	}
	
	public function clone() {
		return new RightTri(c.x, c.y, width, height);
	}
	
	public function lerpC(x:Float) {
		return b.y - height / width * (x - center.x);
	}
}