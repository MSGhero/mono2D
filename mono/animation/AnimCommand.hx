package mono.animation;

import mono.animation.AnimRequest;
import ecs.Entity;

enum AnimCommand {
	ADD_SHEET(sheet:Spritesheet, id:String);
	CREATE_ANIMATIONS(entity:Entity, from:String, animReqs:Array<AnimRequest>, play:String);
	CREATE_FRAME_ANIM(entity:Entity, from:String, frameName:String);
	PLAY_ANIMATION(entity:Entity, play:String);
	COPY_ANIMATIONS(entity:Entity, from:Entity, play:String);
}