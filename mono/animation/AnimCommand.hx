package mono.animation;

import mono.animation.AnimController;
import mono.animation.AnimRequest;
import ecs.Entity;

enum AnimCommand {
	ADD_SHEET(sheet:Spritesheet, id:String);
	CREATE_ANIMATIONS(entity:Entity, from:String, animReqs:Array<AnimRequest>, play:String, optionalController:AnimController);
	CREATE_FRAME_ANIM(entity:Entity, from:String, frameName:String);
	PLAY_ANIMATION(entity:Entity, play:String);
	PLAY_ANIMATION_FROM(entity:Entity, play:String, from:Int);
	COPY_ANIMATIONS(entities:Array<Entity>, from:Entity, play:String);
}