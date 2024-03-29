package mono.layout;

import ecs.Entity;
import mono.command.Command;
import ecs.System;
import ecs.Universe;
import mono.graphics.Sprite;
import mono.layout.LayoutCommand;

class LayoutSystem extends System {
	
	@:fastFamily
	var aligners : {
		align:Align,
		sprite:Sprite
	};
	
	@:fastFamily
	var sprites : {
		other:Sprite
	};
	
	public function new(ecs:Universe) {
		super(ecs);
		
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		Command.register(ENFORCE_ALL, handleLC);
		Command.register(ENFORCE_FOR(Entity.none), handleLC);
	}
	
	function handleLC(lc:LayoutCommand) {
		
		switch (lc) {
			
			case ENFORCE_ALL:
				
				// might need to organize constraints, detect cycles, etc
				iterate(aligners, {
					
					switch (align) {
						case NONE:
						case OFFSET(to, x, y):
							fetch(sprites, to, {
								if (!Math.isNaN(x)) sprite.x = other.x + x;
								if (!Math.isNaN(y)) sprite.y = other.y + y;
							});
					}
				});
				
			case ENFORCE_FOR(entity):
				
				fetch(aligners, entity, {
						
					switch (align) {
						case NONE:
						case OFFSET(to, x, y):
							fetch(sprites, to, {
								if (!Math.isNaN(x)) sprite.x = other.x + x;
								if (!Math.isNaN(y)) sprite.y = other.y + y;
							});
					}
				});
		}
	}
	
	override function update(dt:Float) {
		
		// consider manual trigger
		
	}
}