package mono.interactive.shapes;

class Rect extends Shape {
	
	public var halfWidth:Float;
	public var halfHeight:Float;
	
	public var left(get, never):Float;
	inline function get_left() return centerX - halfWidth;
	public var right(get, never):Float;
	inline function get_right() return centerX + halfWidth;
	public var top(get, never):Float;
	inline function get_top() return centerY - halfHeight;
	public var bottom(get, never):Float;
	inline function get_bottom() return centerY + halfHeight;
	
	public function new(centerX:Float, centerY:Float, width:Float, height:Float) {
		super(centerX, centerY);
		
		halfWidth = width / 2;
		halfHeight = height / 2;
	}
	
	public function isPointWithin(x:Float, y:Float):Bool {
		return !(x < left || x > right || y < top || y > bottom);
	}
}