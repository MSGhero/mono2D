package mono.animation;

typedef TexturePackerData = {
	frames:Array<TexturePackerTile>
}

typedef TexturePackerTile = {
	filename:String,
	frame:{ x:Int, y:Int, w:Int, h:Int },
	rotated:Bool,
	trimmed:Bool,
	spriteSourceSize:{ x:Int, y:Int, w:Int, h:Int },
	sourceSize:{ w:Int, h:Int },
}