package mono.animation;

import h2d.Tile;

@:structInit @:publicFields
class Animation {
	var name:String;
	var frames:Array<Tile>;
	var loop:Bool;
	var fps:Float;
	var loopPoint:Int;
}