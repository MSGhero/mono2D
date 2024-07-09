package mono.animation;

import mono.animation.AnimController;
import mono.animation.AnimRequest;
import ecs.Entity;

enum AnimCommand {
	ADD_SHEET(sheet:Spritesheet, id:String);
	PARSE_ANIMS(paths:Array<String>, sheetID:String);
	ADD_ANIMS(animReqs:Array<AnimRequest>, sheetID:String);
}