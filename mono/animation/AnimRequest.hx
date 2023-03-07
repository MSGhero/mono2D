package mono.animation;

/**
 * Animation data passed into internal functions, resulting in an Animation being created
 * frameNames is mapped by a spritesheet to create the Tile array of each Animation
 */
@:structInit @:publicFields
class AnimRequest {
	
	var name:String;
	var frameNames:Array<String>;
	@:optional var loop:Bool = true;
	@:optional var fps:Float = 1;
	@:optional var loopPoint:Int = 0;
	
	function fulfill(sheet:Spritesheet) {
		
		for (name in frameNames) if (!sheet.exists(name)) throw 'Frame $name not found';
		
		return ({
			name : name,
			frames : sheet.map(frameNames),
			loop : loop,
			fps : fps,
			loopPoint : loopPoint
		}:Animation);
	}
}