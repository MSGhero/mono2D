package;

import haxe.Timer;
import hxd.Window;
import graphics.LayerID;
import graphics.BatchID;
import animation.SheetID;
import graphics.ParentID;
import animation.AnimRequest;
import animation.Spritesheet;
import input.KeyboardInput;
import interactive.Interactive;
import input.MouseInput;
import input.InputCommand;
import hxd.Key;
import input.Action;
import input.Input;
import command.Command;
import graphics.Sprite;
import timing.Timing;
import ecs.Universe;
import ecs.Phase;
import hxd.Res;
import hxd.App;
import animation.AnimSystem;
import graphics.RenderSystem;
import command.CommandSystem;
import timing.TimingSystem;
import input.InputSystem;
import input.MouseSystem;
import interactive.InteractiveSystem;
import audio.AudioSystem;
import timing.Updater;
import graphics.RenderCommand;
import graphics.DisplayListCommand;
import animation.AnimCommand;

#if js
import utils.ResTools;
#end

class Main extends App {
	
	var ecs:Universe;
	
	var updateLoop:Updater;
	var renderLoop:Updater;
	
	var fixedUpdate:Bool = true;
	var fixedRender:Bool = true;
	var updateFPS:Int = 60;
	var renderFPS:Int = 60;
	var maxAccumulatedTime:Float;
	
	var updatePhase:Phase;
	
	var lastStamp:Float;
	
	var loadedIn:Bool;
	
	static function main() {
		#if !js
		Res.initEmbed();
		#end
		new Main();
	}
	
	override function init() {
		
		loadedIn = false; // some stuff is null at the beginning on JS
		@:privateAccess haxe.MainLoop.add(() -> {}); // bug that prevents sound from playing past 1 sec
		
		#if !js
		realInit();
		#else
		ResTools.initPakAuto("assets", () -> { // i need to write a multi use preloader
			realInit();
		}, p -> { });
		#end
	}
	
	function realInit() {
		
		engine.backgroundColor = 0xff888888;
		
		ecs = Universe.create({
			entities : 400,
			phases : [
				{
					name : "update",
					enabled : false,
					systems : [
						InteractiveSystem,
						InputSystem,
						MouseSystem,
						RenderSystem,
						AnimSystem,
						TimingSystem,
						AudioSystem,
						CommandSystem // we usually want this to be the final system
					]
				}
			]
		});
		
		// manually managing main phase, may change later
		updatePhase = ecs.getPhase("update");
		updatePhase.enable();
		
		lastStamp = haxe.Timer.stamp();
		
		updateLoop = Timing.every(1 / updateFPS, onUpdate); // prepUpdate?
		
		renderLoop = Timing.every(1 / renderFPS, prepRender);
		s2d.setElapsedTime(1 / renderFPS);
		maxAccumulatedTime = 2 / renderFPS - 0.001; // don't update two or more frames at a time in fixed-time loops
		
		Window.getInstance().vsync = fixedUpdate = false; // no vsync, framerate equals real FPS
		
		postInit();
	}
	
	function postInit() {
		
		loadedIn = true;
		
		var sheet = new Spritesheet();
		sheet.loadAnimation(Res.bitmap_200x184, "test", 1, 2);
		ecs.setResources(sheet);
		
		var input = new Input();
		var kmap = new InputMapping();
		kmap[Action.SELECT] = [Key.SPACE, Key.Z, Key.F, Key.ENTER];
		kmap[Action.MUTE] = [Key.M];
		input.addDevice(new KeyboardInput(kmap));
		var mmap = new InputMapping();
		mmap[Action.SELECT] = [Key.MOUSE_LEFT, Key.MOUSE_RIGHT];
		input.addDevice(new MouseInput(mmap));
		
		var anims:Array<AnimRequest> = [
			{
				name : "default",
				frameNames : ["test0", "test1"],
				fps : 2,
				loop : true
			}
		];
		
		var ent = ecs.createEntity();
		
		Command.queueMany(
			ADD_PARENT(s2d, ParentID.S2D),
			ADD_SHEET(sheet, BatchID.MAIN),
			CREATE_BATCH(BatchID.MAIN, ParentID.S2D, LayerID.S2D_GAME),
			ALLOC_SPRITE(ent, BatchID.MAIN),
			CREATE_ANIMATIONS(ent, SheetID.MAIN, anims, "default"),
			ADD_INPUT(input, P1)
			// PLAY(MUSIC, "audio/music/1122420_Streambeat.ogg", true, 1, "")
		);
	}
	
	override function mainLoop() {
		
		if (!Window.getInstance().vsync) {
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
			s2d.setElapsedTime(dt);
			sevents.checkEvents();
			updatePhase.update(dt);
		}
		
		if (fixedRender) {
			// render at desired FPS
			renderLoop.update(dt);
		}
		
		else {
			// render as often as possible
			prepRender();
		}
	}
	
	function onUpdate() {
		s2d.setElapsedTime(1 / updateFPS);
		sevents.checkEvents();
		updatePhase.update(1 / updateFPS);
	}
	
	function prepRender() {
		
		if (!engine.begin()) return;
		
		onRender();
		engine.end();
	}
	
	function onRender() {
		
		s2d.render(engine);
		
		// trace("draw calls: " + engine.drawCalls);
	}
}