package mono.animation;

import mono.animation.AnimRequest;
import ecs.Entity;

enum AnimCommand {
	ADD_SHEET(sheet:Spritesheet, id:String);
	CREATE_ANIMATIONS(entity:Entity, from:String, animReqs:Array<AnimRequest>, play:String);
}