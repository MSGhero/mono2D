package mono.timing;

import mono.command.Command;
import ecs.Entity;
import ecs.Universe;
import ecs.System;

class TimingSystem extends System {
	
	@:fastFamily
	var timings : {
		updaters:mono.timing.Paralleler
	}
	
	public function new(ecs:Universe) {
		super(ecs);
		
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		Command.register(TimingCommand.ADD_UPDATER(Entity.none, null), handleTC);
	}
	
	function handleTC(tc:TimingCommand) {
		
		switch (tc) {
			case ADD_UPDATER(entity, updater):
				getUpdaters(entity).push(updater);
		}
	}
	
	function getUpdaters(entity:Entity) {
		
		var ups = null;
		
		fetch(timings, entity, {
			ups = updaters;
		});
		
		if (ups == null) {
			ups = new Paralleler([]);
			universe.setComponents(entity, ups);
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