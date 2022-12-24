package mono.input;

import mono.interactive.CursorCommand;
import mono.command.Command;
import ecs.Entity;
import hxd.Window;
import ecs.System;
import ecs.Universe;
import h2d.Scene;

class MouseSystem extends System {
	
	public function new(ecs:Universe) {
		super(ecs);
		
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		Window.getInstance().addEventTarget(checkMove);
	}
	
	function checkMove(e:hxd.Event) {
		
		switch (e.kind) {
			case EMove:
				Command.queue(POSITION_ABSOLUTE(e.relX, e.relY));
			default:
		}
	}
}