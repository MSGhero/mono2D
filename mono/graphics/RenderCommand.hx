package mono.graphics;

import mono.graphics.LayerID;
import ecs.Entity;

enum RenderCommand {
	CREATE_BATCH(tag:String, parentTag:String, layer:LayerID);
	ALLOC_SPRITE(entity:Entity, from:String);
	ALLOC_SPRITES(entities:Array<Entity>, from:String);
	POSITION_SPRITE(entity:Entity, x:Float, y:Float);
}