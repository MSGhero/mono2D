package mono.input;

import ecs.Entity;
import haxe.ds.StringMap;

enum InputCommand {
     ADD_INPUT(mapping:Input, tag:String);
     REGISTER_INPUT(entity:Entity, tag:String);
     UNREGISTER_INPUT(entity:Entity, tag:String);
     ENABLE_INPUT(tag:String);
     DISABLE_INPUT(tag:String);
	RAW_INPUT(f:(inputMap:StringMap<Input>)->Void);
}