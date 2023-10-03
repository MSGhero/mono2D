package mono.interactive;

import mono.geom.Shape;

@:structInit
class Interactive {
	
	public var enabled:Bool = true;
	public var shape:Shape;
	
	public var priority:Int = 0;
	
	public var onOver:()->Void = null;
	public var onOut:()->Void = null;
	public var onSelect:()->Void = null;
}