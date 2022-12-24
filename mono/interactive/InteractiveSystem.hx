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
	
	// maybe a class or resource or something
	var cx:Float;
	var cy:Float;
	
	var currentOver:Entity;
	var tempOver:Entity;
	
	public function new(ecs:Universe) {
		super(ecs);
		
		cx = cy = 0;
		currentOver = tempOver = Entity.none;
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		Command.register(CursorCommand.POSITION_ABSOLUTE(0, 0), handleCC);
	}
	
	function handleCC(cc:CursorCommand) {
		
		switch (cc) {
			case POSITION_ABSOLUTE(x, y):
				cx = x; cy = y;
		}
	}
	
	override function update(dt:Float) {
		super.update(dt);
		
		tempOver = Entity.none;
		
		iterate(interactives, entity -> {
			if (interactive.enabled && interactive.isPointWithin(cx, cy)) {
				// need to deal with sorting somehow
				tempOver = entity;
			}
		});
		
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
}