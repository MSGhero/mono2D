package mono.audio;

import mono.command.Command;
import mono.audio.AudioCommand;

@:structInit
class AudioVolume {
	
	public var muted:Bool = false;
	
	public var musicMult(get, never):Float;
	public var sfxMult(get, never):Float;
	public var voiceMult(get, never):Float;
	public var uiMult(get, never):Float;
	
	public var master:Float = 1;
	public var music:Float = 1;
	public var sfx:Float = 1;
	public var ui:Float = 1;
	public var voice:Float = 1;
	
	inline function get_musicMult() { return master * music; }
	inline function get_sfxMult() { return master * sfx; }
	inline function get_uiMult() { return master * ui; }
	inline function get_voiceMult() { return master * voice; }
}