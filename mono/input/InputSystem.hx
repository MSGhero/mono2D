package mono.input;

import ecs.Entity;
import haxe.ds.StringMap;
import mono.command.Command;
import ecs.Universe;
import ecs.System;
import mono.input.InputCommand;

class InputSystem extends System {
	
	@:fullFamily
	var inputs : {
		requires : {
			input:Input
		}
	};
	
	var inputMap:StringMap<Input>;
	
	public function new(ecs:Universe) {
		super(ecs);
		
		inputMap = new StringMap();
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		Command.register(ADD_INPUT(null, "", Entity.none), handleInput);
		Command.register(REGISTER_INPUT(Entity.none, ""), handleInput);
		Command.register(UNREGISTER_INPUT(Entity.none, ""), handleInput);
		Command.register(ENABLE_INPUT(""), handleInput);
		Command.register(DISABLE_INPUT(""), handleInput);
	}
	
	function handleInput(ic:InputCommand) {
		
		switch (ic) {
			case ADD_INPUT(input, id, entity):
				inputMap.set(id, input);
				if (entity != Entity.none) universe.setComponents(entity, input);
			case REGISTER_INPUT(entity, tag):
				universe.setComponents(entity, inputMap.get(tag));
			case UNREGISTER_INPUT(entity, tag):
				universe.removeComponents(entity, inputMap.get(tag));
			case ENABLE_INPUT(id):
				inputMap.get(id).enabled = true;
			case DISABLE_INPUT(id):
				inputMap.get(id).enabled = false;
			default:
		}
	}
	
	override function update(dt:Float) {
		super.update(dt);
		
		// reset on focus lost or something?
		
		iterate(inputs, {
			
			input.previous.copyFrom(input.actions);
			
			for (i in 0...input.pressed.length)
				input.pressed[i] = false;
			
			if (input.enabled) {
				
				for (device in input.devices) {
					
					for (i in 0...input.pressed.length) {
						if (input.pressed[i]) continue;
						input.pressed[i] = device.getStatus(i);
					}
				}
			}
			
			input.actions.updateJust(input.previous);
		});
	}
}