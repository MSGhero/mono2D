package mono.graphics;

import mono.graphics.LayerID;
import ecs.Entity;

enum RenderCommand {
	CREATE_BATCH(tag:String, parentTag:String, layer:LayerID);
	ADD_SPRITE(sprite:Sprite, to:String);
	ADD_SPRITES(sprites:Array<Sprite>, to:String);
	POSITION_SPRITE(entity:Entity, x:Float, y:Float);
	SPACE_SPRITES(entities:Array<Entity>, dx:Float, dy:Float);
	GRID_SPRITES(entities:Array<Entity>, dx:Float, dy:Float, maxCols:Int, maxRows:Int);
}