package mono.input;

import ecs.Entity;

enum InputCommand {
     ADD_INPUT(mapping:Input, tag:String, entity:Entity);
     REGISTER_INPUT(entity:Entity, tag:String);
     UNREGISTER_INPUT(entity:Entity, tag:String);
     ENABLE_INPUT(tag:String);
     DISABLE_INPUT(tag:String);
}