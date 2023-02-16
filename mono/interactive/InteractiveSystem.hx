package mono.interactive;

import mono.input.Input;
import ecs.Entity;
import mono.command.Command;
import ecs.Universe;
import ecs.System;

class InteractiveSystem extends System {
	
	@:fullFamily
	var interactives : {
		resources : {
			
		},
		requires : {
			interactive:Interactive
		}
	};
	
	@:fastFamily
	var inputs : {
		input:Input
	}
	
	var cx:Float;
	var cy:Float;
	var cEnabled:Bool;
	
	var currentOver:Entity;
	var tempOver:Entity;
	
	var interactiveState:Int;
	
	public function new(ecs:Universe) {
		super(ecs);
		
		cx = cy = 0;
		cEnabled = true;
		currentOver = tempOver = Entity.none;
		
		interactiveState = 0;
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		interactives.onEntityAdded.subscribe(onInteractive);
		
		Command.register(CursorCommand.POSITION_ABSOLUTE(0, 0), handleCC);
		Command.register(CursorCommand.DISABLE_CURSOR, handleCC);
		Command.register(CursorCommand.ENABLE_CURSOR, handleCC);
		Command.register(InteractiveCommand.DISABLE_INTERACTIVES(0), handleIC);
		Command.register(InteractiveCommand.ENABLE_INTERACTIVES(0), handleIC);
	}
	
	function onInteractive(entity) {
		fetch(interactives, entity, {
			interactive.enabled = getEnabled(interactive);
			trace(interactive.enabled, interactive.disablers, interactiveState);
		});
	}
	
	function handleCC(cc:CursorCommand) {
		
		switch (cc) {
			case POSITION_ABSOLUTE(x, y):
				cx = x; cy = y;
			case DISABLE_CURSOR:
				cEnabled = false;
			case ENABLE_CURSOR:
				cEnabled = true;
		}
	}
	
	function handleIC(ic:InteractiveCommand) {
		
		switch (ic) {
			case DISABLE_INTERACTIVES(trigger):
				interactiveState |= trigger;
				refresh();
			case ENABLE_INTERACTIVES(trigger):
				interactiveState &= ~trigger;
				refresh();
		}
	}
	
	override function update(dt:Float) {
		super.update(dt);
		
		tempOver = Entity.none;
		
		if (cEnabled) {
			iterate(interactives, entity -> {
				if (interactive.enabled && interactive.isPointWithin(cx, cy)) {
					// need to deal with sorting somehow
					tempOver = entity;
				}
			});
		}
		
		if (currentOver != tempOver) {
			
			// onOut
			if (currentOver != Entity.none) {
				fetch(interactives, currentOver, {
					if (interactive.onOut != null) interactive.onOut();
				});
			}
			
			currentOver = tempOver;
			
			// onOver
			if (currentOver != Entity.none) {
				fetch(interactives, currentOver, {
					if (interactive.onOver != null) interactive.onOver();
				});
			}
		}
		
		if (currentOver != Entity.none) {
			// rn click, release, other keys do not exist
			// multiple cursors (local multi) possible using arrays everywhere. future feature
			fetch(interactives, currentOver, {
				if (interactive.onSelect != null) {
					iterate(inputs, {
						if (input.justPressed.SELECT) interactive.onSelect();
					});
				}
			});
		}
	}
	
	function refresh() {
		
		iterate(interactives, {
			interactive.enabled = getEnabled(interactive);
		});
	}
	
	inline function getEnabled(interactive:Interactive) {
		return !(interactive.disablers & interactiveState > 0);
	}
}