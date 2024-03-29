package mono.geom;

class Rect extends Shape {
	
	public var halfWidth:Float;
	public var halfHeight:Float;
	
	inline function get_left() return center.x - halfWidth;
	inline function get_right() return center.x + halfWidth;
	inline function get_top() return center.y - halfHeight;
	inline function get_bottom() return center.y + halfHeight;
	
	public function new(centerX:Float, centerY:Float, width:Float, height:Float) {
		super(centerX, centerY);
		
		halfWidth = width / 2;
		halfHeight = height / 2;
		
		type = RECT;
	}
	
	public function clone() {
		return new Rect(center.x, center.y, halfWidth * 2, halfHeight * 2);
	}
	
	public static function fromTL(left:Float, top:Float, width:Float, height:Float) {
		return new Rect(left + width / 2, top + height / 2, width, height);
	}
}