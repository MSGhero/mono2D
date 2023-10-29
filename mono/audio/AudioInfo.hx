package mono.audio;

@:structInit @:publicFields
class AudioInfo {
	var type:AudioType;
	var loop:Bool = false;
	var volume:Float = 1.0;
	var tag:String = "";
	var position:Float = 0;
}