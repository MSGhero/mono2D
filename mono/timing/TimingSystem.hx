package mono.timing;

import mono.command.Command;
import ecs.Entity;
import ecs.Universe;
import ecs.System;
import mono.timing.Paralleler;

class TimingSystem extends System {
	
	@:fastFamily
	var timings : {
		updaters:Paralleler
	}
	
	public function new(ecs:Universe) {
		super(ecs);
		
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		Command.register(TimingCommand.ADD_UPDATER(Entity.none, null), handleTC);
		Command.register(TimingCommand.REMOVE_UPDATER(Entity.none, null), handleTC);
		Command.register(TimingCommand.CALL(null), handleTC);
	}
	
	function handleTC(tc:TimingCommand) {
		
		switch (tc) {
			case ADD_UPDATER(entity, updater):
				if (entity == Entity.none) entity = universe.createEntity();
				getUpdaters(entity).push(updater);
			case REMOVE_UPDATER(entity, updater):
				getUpdaters(entity).remove(updater);
			case CALL(func):
				if (func != null) func();
		}
	}
	
	function getUpdaters(entity:Entity) {
		
		var ups = null;
		
		fetch(timings, entity, {
			ups = updaters;
		});
		
		if (ups == null) {
			ups = new Paralleler([]);
			universe.setComponents(entity, (ups:Paralleler));
		}
		
		return ups;
	}
	
	override function update(dt:Float) {
		super.update(dt);
		
		iterate(timings, {
			updaters.update(dt);
		});
	}
}