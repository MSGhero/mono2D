package mono.context;

import mono.context.ConsumerCommand;
import mono.command.Command;
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
		
		ecs.setResources(
			new context.Context(), // custom collection of variables accessible by consumers and specific callbacks
		);
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		Command.register(APPLY_FROM_CONTEXT(null), handleCC);
		Command.register(APPLY_TO_CONTEXT(null), handleCC);
	}
	
	function handleCC(cc:ConsumerCommand) {
		
		switch (cc) {
			case APPLY_FROM_CONTEXT(f):
				setup(consumers, {
					f(ctx);
				});
			case APPLY_TO_CONTEXT(f):
				setup(consumers, {
					f(ctx);
				});
		}
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