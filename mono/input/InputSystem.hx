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
		resources : {
			inputMap:StringMap<Input>
		},
		requires : {
			input:Input
		}
	};
	
	// just store inputs in an array? i don't think input alone is used anywhere
	
	public function new(ecs:Universe) {
		super(ecs);
		
		ecs.setResources(
			new StringMap<Input>() // InputID => Input mapping
		);
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		Command.register(ADD_INPUT(null, ""), handleInput);
		Command.register(REGISTER_INPUT(Entity.none, ""), handleInput);
		Command.register(UNREGISTER_INPUT(Entity.none, ""), handleInput);
		Command.register(ENABLE_INPUT(""), handleInput);
		Command.register(DISABLE_INPUT(""), handleInput);
	}
	
	function handleInput(ic:InputCommand) {
		
		switch (ic) {
			case ADD_INPUT(input, id):
				setup(inputs, {
					inputMap.set(id, input);
				});
			case REGISTER_INPUT(entity, tag):
				setup(inputs, {
					final input:Input = inputMap.get(tag);
					universe.setComponents(entity, input);
				});
			case UNREGISTER_INPUT(entity, tag):
				setup(inputs, {
					final input:Input = inputMap.get(tag);
					universe.removeComponents(entity, input);
				});
			case ENABLE_INPUT(id):
				setup(inputs, {
					inputMap.get(id).enabled = true;
				});
			case DISABLE_INPUT(id):
				setup(inputs, {
					inputMap.get(id).enabled = false;
				});
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
		
		iterate(inputs, {
			if (input.enabled) {
				for (device in input.devices) {
					device.reset(); // not a fan, but hey
				}
			}
		});
	}
}