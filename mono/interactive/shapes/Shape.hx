package mono.interactive.shapes;

abstract class Shape {
	
	public var centerX:Float;
	public var centerY:Float;
	
	public function new(centerX:Float, centerY:Float) {
		this.centerX = centerX;
		this.centerY = centerY;
	}
	
	public abstract function isPointWithin(x:Float, y:Float):Bool;
}