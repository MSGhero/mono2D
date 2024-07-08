package mono.animation;

import mono.animation.AnimController;
import mono.animation.AnimRequest;
import ecs.Entity;

enum AnimCommand {
	ADD_SHEET(sheet:Spritesheet, id:String);
	PARSE_ANIMS(paths:Array<String>, sheetID:String);
	CREATE_ANIMATION(entity:Entity, from:String, animReqs:Array<AnimRequest>, play:String, optionalController:AnimController);
	CREATE_ANIMATIONS(entities:Array<Entity>, from:String, animReqs:Array<AnimRequest>, play:String);
	CREATE_FRAME_ANIM(entity:Entity, from:String, frameName:String);
	PLAY_ANIMATION(entity:Entity, play:String);
	PLAY_ANIMATION_FROM(entity:Entity, play:String, from:Int);
	COPY_ANIMATIONS(entity:Entity, from:Entity, play:String);
}