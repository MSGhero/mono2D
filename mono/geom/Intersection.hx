package mono.geom;

import h2d.col.Point;

class Intersection {
	
	public static function xyInShape(x:Float, y:Float, shape:Shape, eps:Float = 0) {
		return switch (shape.type) {
			case CIRCLE: xyInCircle(x, y, cast shape, eps);
			case RECT: xyInRect(x, y, cast shape, eps);
			case RTRI: xyInRTri(x, y, cast shape, eps);
		}
	}
	
	public static inline function pointInShape(point:Point, shape:Shape, eps:Float = 0) {
		return xyInShape(point.x, point.y, shape, eps);
	}
	
	public static function shapeShape(shape1:Shape, shape2:Shape, eps:Float = 0) {
		return switch (shape1.type) {
			case CIRCLE:
				switch (shape2.type) {
					case CIRCLE: circleCircle(cast shape1, cast shape2, eps);
					case RECT: circleRect(cast shape1, cast shape2, eps);
					case RTRI: throw "not implemented";
				}
			case RECT:
				switch (shape2.type) {
					case CIRCLE: circleRect(cast shape2, cast shape1, eps);
					case RECT: rectRect(cast shape1, cast shape2, eps);
					case RTRI: throw "not implemented";
				}
			case RTRI:
				throw "not implemented";
		}
	}
	
	public static function pointInCircle(point:Point, circle:Circle, eps:Float = 0) {
		return xyInCircle(point.x, point.y, circle, eps);
	}
	
	public static inline function xyInCircle(x:Float, y:Float, circle:Circle, eps:Float = 0) {
		return Math.abs((x - circle.x) * (x - circle.x) + (y - circle.y) * (y - circle.y) - circle.radius * circle.radius) < eps * eps;
	}
	
	public static function pointInRect(point:Point, rect:Rect, eps:Float = 0) {
		return xyInRect(point.x, point.y, rect, eps);
	}
	
	public static inline function xyInRect(x:Float, y:Float, rect:Rect, eps:Float = 0) {
		return !(x < rect.left - eps || x > rect.right + eps || y < rect.top - eps || y > rect.bottom + eps);
	}
	
	public static function pointInRTri(point:Point, tri:RightTri, eps:Float = 0) {
		return xyInRTri(point.x, point.y, tri, eps);
	}
	
	public static inline function xyInRTri(x:Float, y:Float, tri:RightTri, eps:Float = 0) {
		final u = (x - tri.c.x) / tri.width, v = (y - tri.c.y) / tri.height;
		return u >= -eps / Math.abs(tri.width) && v >= -eps / Math.abs(tri.height) && u + v <= 1 + eps / Math.abs(tri.width) + eps / Math.abs(tri.height);
	}
	
	public static function xyInPoint(x:Float, y:Float, point:Point, eps:Float = 0) {
		return (x - point.x) * (x - point.x) + (y - point.y) * (y - point.y) < eps * eps;
	}
	
	public static inline function pointPoint(point1:Point, point2:Point, eps:Float = 0) {
		return xyInPoint(point1.x, point1.y, point2, eps);
	}
	
	public static function circleCircle(circle1:Circle, circle2:Circle, eps:Float = 0) {
		return (circle1.x - circle2.x) * (circle1.x - circle2.x) + (circle1.y - circle2.y) * (circle1.y - circle2.y) - (circle1.radius + circle2.radius) * (circle1.radius + circle2.radius) < eps * eps;
	}
	
	public static function rectRect(rect1:Rect, rect2:Rect, eps:Float = 0) {
		return !(rect1.left > rect2.right + eps || rect1.right < rect2.left - eps || rect1.top > rect2.bottom + eps || rect1.bottom < rect2.top - eps);
	}
	
	public static function circleRect(circle:Circle, rect:Rect, eps:Float = 0) {
		// https://yal.cc/rectangle-circle-intersection-test/
		
		final dx = circle.x - Math.max(rect.left, Math.min(circle.x, rect.right));
		final dy = circle.y - Math.max(rect.top, Math.min(circle.y, rect.bottom));
		
		return dx * dx + dy * dy - circle.radius * circle.radius < eps * eps;
	}
}