package mono.layout;

import ecs.System;
import ecs.Universe;
import mono.graphics.Sprite;

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
	
	override function update(dt:Float) {
		
		// consider manual trigger
		iterate(aligners, {
			
			switch (align) {
				case NONE:
				case OFFSET(to, x, y):
					fetch(sprites, to, {
						sprite.x = other.x + x;
						sprite.y = other.y + y;
					});
			}
		});
	}
}