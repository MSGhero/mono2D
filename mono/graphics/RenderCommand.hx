package mono.graphics;

import ecs.Entity;

enum RenderCommand {
	CREATE_BATCH(tag:String, parentTag:String, layer:Int);
	ALLOC_SPRITE(entity:Entity, from:String);
	ALLOC_SPRITES(entities:Array<Entity>, from:String);
}