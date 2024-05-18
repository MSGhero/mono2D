package mono.app;

import hxd.App;
import mono.timing.Updater;
import mono.timing.Timing;
import haxe.Timer;

class Main extends App {
	
	var updateLoop:Updater;
	var renderLoop:Updater;
	
	var fixedUpdate:Bool = false;
	var fixedRender:Bool = false;
	var updateFPS:Int = 60;
	var renderFPS:Int = 60;
	var maxAccumulatedTime:Float;
	
	var lastStamp:Float;
	
	var loadedIn:Bool;
	
	var mono:Mono;
	var stage:Stage;
	
	static function main() {
		new Main();
	}
	
	override function init() {
		
		loadedIn = false; // some stuff is null at the beginning on JS
		@:privateAccess haxe.MainLoop.add(() -> { }); // bug that prevents sound from playing past 1 sec
		
		stage = {
			scenes : [s2d],
			engine : engine,
			window : hxd.Window.getInstance(),
			sceneEvents : sevents
		};
		
		mono = new Mono(stage);
		
		lastStamp = haxe.Timer.stamp();
		
		updateLoop = Timing.every(1 / updateFPS, onUpdate);
		
		renderLoop = Timing.every(1 / renderFPS, mono.render);
		maxAccumulatedTime = 2 / renderFPS - 0.001; // don't update two or more frames at a time in fixed-time loops
		
		#if !js
		stage.window.vsync = fixedUpdate = false; // no vsync, framerate equals real FPS
		#else
		fixedUpdate = true;
		#end
		
		onResize();
		
		loadedIn = true; // is this good here now?
	}
	
	override function mainLoop() {
		
		if (!stage.window.vsync) {
			final targetDT = 1 / updateFPS;
			final safeTime = 1 / 1000;
			while (Timer.stamp() - lastStamp < targetDT - safeTime) {
				// limit !vsync to around the updateFPS
				// if not, the framerate will go into the thousands
				// @trethaller at Shiro Games
			}
		}
		
		final newTime = Timer.stamp();
		final dt = newTime - lastStamp;
		lastStamp = newTime;
		
		if (isDisposed || !loadedIn) return;
		
		update(dt);
	}
	
	override function update(dt:Float) {
		
		hxd.Timer.update(); // is this necessary?
		
		if (fixedUpdate) {
			// update at the desired FPS
			@:privateAccess
			if (updateLoop.counter + dt > maxAccumulatedTime) {
				// limit the effect of lag causing multiple "catch-up" updates at once
				updateLoop.counter = maxAccumulatedTime;
				updateLoop.update(0);
			}
			
			else updateLoop.update(dt);
		}
		
		else {
			// force update using whatever the real FPS ends up being
			if (dt > maxAccumulatedTime) dt = maxAccumulatedTime; // limited by the max
			mono.update(dt);
		}
		
		if (fixedRender) {
			// render at desired FPS
			renderLoop.update(dt);
		}
		
		else {
			// render as often as possible
			mono.render();
		}
	}
	
	function onUpdate() {
		mono.update(1 / updateFPS);
	}
}