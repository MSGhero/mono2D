package mono.animation;

import haxe.ds.StringMap;
import h2d.Tile;
import mono.timing.Updater;

@:allow(mono.animation.AnimSystem)
class AnimController {
	
	public var frames(get, never):Array<Tile>;
	inline function get_frames() return currAnim.frames;
	
	public var index(default, null):Int = 0;
	public var allowLoop:Bool;
	
	public var currFrame(get, never):Tile;
	inline function get_currFrame() { return frames[index]; }
	
	public var paused(get, never):Bool;
	inline function get_paused() { return updater.paused; }
	
	public var isActive(get, never):Bool;
	inline function get_isActive() { return updater.isActive; }
	
	public var isComplete(get, never):Bool;
	inline function get_isComplete() { return updater.isComplete; }
	
	public var isReady(get, never):Bool;
	inline function get_isReady() { return anims != null; }
	
	public var name(get, never):String;
	inline function get_name() { return currAnim.name; }
	
	var onFrame:()->Void; // maybe make a signal/event dispatcher if strong need to use elsewhere
	
	var updater:Updater;
	var anims:StringMap<Animation>;
	var currAnim:Animation;
	
	var queuedPlayName:String;
	var queuedPlayFrom:Int;
	
	public function new() {
		
		updater = new Updater(0, -1, false);
		updater.callback = advance;
		allowLoop = true;
		
		anims = null;
		currAnim = null;
		onFrame = null;
		
		queuedPlayName = "";
		queuedPlayFrom = -1;
	}
	
	public function add(anim:Animation) {
		anims ??= new StringMap();
		anims.set(anim.name, anim);
		return this;
	}
	
	public function copyFrom(ac:AnimController) {
		anims ??= new StringMap();
		for (k => v in ac.anims) anims.set(k, v);
		return this;
	}
	
	public function refAnimsFrom(ac:AnimController) {
		
		anims = ac.anims;
		
		if (anims != null && queuedPlayName.length > 0) {
			play(queuedPlayName, queuedPlayFrom);
			queuedPlayName = "";
			queuedPlayFrom = -1;
		}
	}
	
	public function play(name:String, from:Int = 0) {
		
		if (anims == null) {
			queuedPlayName = name;
			queuedPlayFrom = from;
			return;
		}
		
		currAnim = anims.get(name);
		if (currAnim == null) throw '"$name" anim not found, or forgot to play()';
		
		if (from > -1) {
			index = from;
			updater.resetCounter();
		}
		else index %= currAnim.frames.length; // continue from current frame number and counter dt
		
		updater.paused = false;
		updater.duration = 1 / currAnim.fps;
		updater.repetitions = currAnim.loop ? -1 : frames.length;
		
		allowLoop = true;
		
		if (onFrame != null) onFrame();
	}
	
	public inline function pause() {
		updater.paused = true;
	}
	
	public inline function resume() {
		updater.paused = false;
	}
	
	function advance() {
		
		if (currAnim.loop && allowLoop) {
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