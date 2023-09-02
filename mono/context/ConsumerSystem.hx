package mono.context;

import ecs.Universe;
import ecs.System;

class ConsumerSystem extends System {
	
	@:fullFamily
	var consumers : {
		resources : {
			ctx:context.Context
		},
		requires : {
			consumer:Consumer
		}
	}
	
	public function new(ecs:Universe) {
		super(ecs);
		
	}
	
	override function update(dt:Float) {
		super.update(dt);
		
		setup(consumers, {
			iterate(consumers, {
				consumer.update(ctx);
			});
		});
	}
}