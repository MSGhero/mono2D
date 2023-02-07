package mono.input;

import h2d.col.Point;
import mono.interactive.CursorCommand;
import mono.command.Command;
import ecs.Entity;
import hxd.Window;
import ecs.System;
import ecs.Universe;
import h2d.Scene;

class MouseSystem extends System {
	
	@:fullFamily
	var screen : {
		resources : {
			s2d:Scene
		}
	}
	
	var screenPt:Point;
	
	public function new(ecs:Universe) {
		super(ecs);
		
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		screenPt = new Point();
		
		Window.getInstance().addEventTarget(checkMove);
	}
	
	function checkMove(e:hxd.Event) {
		
		switch (e.kind) {
			case EMove, ERelease:
				setup(screen, {
					// touch seems to be at the prev position on press/release
					@:privateAccess s2d.syncPos();
					screenPt.set(e.relX, e.relY);
					s2d.interactiveCamera.screenToCamera(screenPt); // transform e.relX/Y into viewport space
					Command.queue(POSITION_ABSOLUTE(screenPt.x, screenPt.y));
				});
			default:
		}
	}
}