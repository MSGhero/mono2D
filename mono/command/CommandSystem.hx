package mono.command;

import haxe.ds.StringMap;
import ecs.Universe;
import ecs.System;

class CommandSystem extends System {
	
	static var _cmdSys:CommandSystem;
	
	var commandMap:StringMap<Array<Command->Void>>;
	
	@:fullFamily
	var commands : {
		resources : {
			queue:Array<Command>
		}
	}
	
	public function new(ecs:Universe) {
		super(ecs);
		
		if (_cmdSys != null) throw "Can't have multiple CommandSystems";
		_cmdSys = this;
		
		commandMap = new StringMap();
		
		// set up callback register. can't enqueue the first one
		onRegister(CoreCommand.REGISTER(CoreCommand.REGISTER(null, null), cast onRegister));
		
		// command queue needs to be added before enabling systems
		ecs.setResources(([]:Array<Command>));
	}
	
	function onRegister(comm:CoreCommand) {
		
		switch (comm) {
			case CoreCommand.REGISTER(type, callback):
				if (!commandMap.exists(type)) commandMap.set(type, []);
				commandMap.get(type).push(callback);
			default:
		}
	}
	
	inline function enqueue(comm:Command) {
		
		setup(commands, {
			queue.push(comm);
		});
	}
	
	function getQueue() {
		
		setup(commands, {
			return queue;
		});
		
		throw "Queue not found";
	}
	
	override function update(dt:Float) {
		super.update(dt);
		
		setup(commands, {
			
			if (queue.length == 0) return;
			
			for (comm in queue) {
				// trace(comm); // to see what's going on
				var fs = commandMap.get(comm);
				if (fs == null) trace('Enum command not registered: $comm'); // shouldn't throw since maybe no one is using that command
				else for (f in fs) f(comm);
			}
			
			queue.splice(0, queue.length);
		});
	}
}