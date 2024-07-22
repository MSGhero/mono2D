package mono.state;

import haxe.ds.StringMap;
import haxe.ds.IntMap;
import mono.command.Command;
import mono.state.StateCommand;
import ecs.Universe;
import ecs.System;

class StateSystem extends System {
	
	var states:IntMap<State>;
	
	var enterNotifs:IntMap<Array<()->Void>>;
	var exitNotifs:IntMap<Array<()->Void>>;
	var triggerNotifs:StringMap<Array<(message:String)->Void>>;
	
	public function new(ecs:Universe) {
		super(ecs);
		
		states = new IntMap();
		
		enterNotifs = new IntMap();
		exitNotifs = new IntMap();
		triggerNotifs = new StringMap();
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		Command.register(REGISTER_ENTER(0, null), handleSC);
		Command.register(REGISTER_EXIT(0, null), handleSC);
		Command.register(REGISTER_STATE(null, 0), handleSC);
		Command.register(REGISTER_TRIGGER("", null), handleSC);
		Command.register(ENTER(0), handleSC);
		Command.register(EXIT(0), handleSC);
		Command.register(TRIGGER("", ""), handleSC);
	}
	
	function handleSC(sc:StateCommand) {
		
		switch (sc) {
			case REGISTER_ENTER(to, callback):
				enterNotifs.get(to).push(callback);
			case REGISTER_EXIT(to, callback):
				exitNotifs.get(to).push(callback);
			case REGISTER_STATE(state, tag):
				states.set(tag, state);
				state.init();
				enterNotifs.set(tag, []);
				exitNotifs.set(tag, []);
			case REGISTER_TRIGGER(type, callback):
				if (triggerNotifs.exists(type)) triggerNotifs.get(type).push(callback);
				else triggerNotifs.set(type, [callback]);
			case ENTER(state):
				states.get(state).enter();
				for (cb in enterNotifs.get(state)) cb();
			case EXIT(state):
				states.get(state).exit();
				for (cb in exitNotifs.get(state)) cb();
			case TRIGGER(type, message):
				var arr = triggerNotifs.get(type);
				if (arr != null) for (cb in arr) cb(message);
		}
	}
}