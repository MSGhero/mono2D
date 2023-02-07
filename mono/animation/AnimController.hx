package mono.animation;

import haxe.ds.StringMap;
import h2d.Tile;
import mono.timing.Updater;

@:allow(mono.animation.AnimSystem)
class AnimController {
	
	public var frames(get, never):Array<Tile>;
	inline function get_frames() return currAnim.frames;
	
	public var index(default, null):Int = 0;
	
	public var currFrame(get, never):Tile;
	inline function get_currFrame() { return frames[index]; }
	
	public var paused(get, never):Bool;
	inline function get_paused() { return updater.paused; }
	
	public var isActive(get, never):Bool;
	inline function get_isActive() { return updater.isActive; }
	
	public var name(get, never):String;
	inline function get_name() { return currAnim.name; }
	
	var onFrame:()->Void; // maybe make a signal/event dispatcher if strong need to use elsewhere
	
	var updater:Updater;
	var anims:StringMap<Animation>;
	var currAnim:Animation;
	
	public function new() {
		
		updater = new Updater(0, -1, false);
		updater.callback = advance;
		
		anims = new StringMap();
		currAnim = null;
		onFrame = null;
	}
	
	public function add(anim:Animation) {
		anims.set(anim.name, anim);
		return this;
	}
	
	public function play(name:String, from:Int = 0) {
		
		currAnim = anims.get(name);
		index = from;
		
		if (currAnim == null) throw '$name anim not found, or forgot to play()';
		
		updater.resetCounter();
		updater.paused = false;
		updater.duration = 1 / currAnim.fps;
		updater.repetitions = currAnim.loop ? -1 : frames.length;
		
		if (onFrame != null) onFrame();
	}
	
	public inline function pause() {
		updater.paused = true;
	}
	
	public inline function resume() {
		updater.paused = false;
	}
	
	function advance() {
		
		if (currAnim.loop) {
			index = (index + 1) % frames.length;
			if (index < currAnim.loopPoint) index = currAnim.loopPoint;
			if (onFrame != null) onFrame();
		}
		
		else if (index + 1 < frames.length) {
			index++;
			if (onFrame != null) onFrame();
		}
	}
}