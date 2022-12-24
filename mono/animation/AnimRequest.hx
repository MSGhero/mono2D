package mono.animation;

/**
 * Animation data passed into internal functions, resulting in an Animation being created
 * frameNames is mapped by a spritesheet to create the Tile array of each Animation
 */
@:structInit @:publicFields
class AnimRequest {
	
	var name:String;
	var frameNames:Array<String>;
	var loop:Bool = true;
	var fps:Float = 1;
	var loopPoint:Int = 0;
	
	function fulfill(sheet:Spritesheet) {
		return ({
			name : name,
			frames : sheet.map(frameNames),
			loop : loop,
			fps : fps,
			loopPoint : loopPoint
		}:Animation);
	}
}