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
		
		consumers.onEntityAdded.subscribe(handleConsumer);
		
		Command.register(APPLY_FROM_CONTEXT(null), handleCC);
		Command.register(APPLY_TO_CONTEXT(null), handleCC);
		
		setup(consumers, {
			Command.queue(INIT_CONTEXT(ctx)); // handled by implemented systems
		});
	}
	
	function handleConsumer(entity) {
		
		fetch(consumers, entity, {
			setup(consumers, {
				consumer.setCtx(ctx);
			});
		});
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
			default:
		}
	}
}