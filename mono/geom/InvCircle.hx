package mono.geom;

class InvCircle extends Circle {
	
	public function new(centerX:Float, centerY:Float, radius:Float) {
		super(centerX, centerY, radius);
		
		type = INV_CIRCLE;
	}
	
	override public function clone() {
		return new InvCircle(center.x, center.y, radius);
	}
}