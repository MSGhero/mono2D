package mono.interactive.shapes;

class Circle extends Shape {
	
	public var radiusSq:Float;
	
	public function new(centerX:Float, centerY:Float, radius:Float) {
		super(centerX, centerY);
		
		radiusSq = radius * radius;
	}
	
	public function isPointWithin(x:Float, y:Float) {
		return radiusSq >= (x - centerX) * (x - centerX) + (y - centerY) * (y - centerY);
	}
}