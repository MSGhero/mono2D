package mono.command;

import haxe.EnumTools.EnumValueTools;

abstract Command(EnumValue) from EnumValue to EnumValue {
	
	@:to
	public inline function toString() {
		return EnumValueTools.getName(this);
	}
	
	/**
	 * Queue up any enum value as a Command to execute during CommandSystem's update()
	 * @param command Any enum value
	 */
	public static inline function queue(command:Command) {
		@:privateAccess(CommandSystem)
		CommandSystem._cmdSys.enqueue(command);
	}
	
	/**
	 * Queue up many enum values as Commands to execute during CommandSystem's update()
	 * @param commands Any enum values
	 */
	public static inline function queueMany(...commands:Command) {
		
		for (command in commands) {
			@:privateAccess(CommandSystem)
			CommandSystem._cmdSys.enqueue(command);
		}
	}
	
	/**
	 * Register a callback to be executed whenever the specified Command is found in the queue
	 * @param type Any enum value. The values of the parameters do not matter here
	 * @param callback A callback that will receive the queued `type` Command as an argument
	 */
	public static function register<T>(type:Command, callback:T->Void) {
		queue(CoreCommand.REGISTER(type, cast callback));
	}
}