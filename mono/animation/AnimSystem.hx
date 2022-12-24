package mono.animation;

import haxe.ds.StringMap;
import ecs.Entity;
import h2d.Bitmap;
import mono.timing.TimingCommand;
import mono.command.Command;
import ecs.Universe;
import ecs.System;
import mono.graphics.Sprite;
import mono.animation.AnimCommand;

class AnimSystem extends System {
	
	@:fastFamily
	var anims : {
		anim:AnimController
	}
	
	@:fastFamily
	var spriteAnims : {
		anim:AnimController,
		sprite:Sprite
	}
	
	@:fastFamily
	var bitmapAnims : {
		anim:AnimController,
		bitmap:Bitmap
	}
	
	var sheetMap:StringMap<Spritesheet>;
	
	public function new(ecs:Universe) {
		super(ecs);
		
		sheetMap = new StringMap();
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		spriteAnims.onEntityAdded.subscribe(handleSpriteAnim);
		bitmapAnims.onEntityAdded.subscribe(handleBitmapAnim);
		
		Command.register(ADD_SHEET(null, ""), handleAC);
		Command.register(CREATE_ANIMATIONS(Entity.none, "", null, ""), handleAC);
	}
	
	function handleSpriteAnim(entity) {
		
		fetch(spriteAnims, entity, {
			sprite.t = anim.currFrame;
			anim.onFrame = () -> sprite.t = anim.currFrame;
			Command.queue(ADD_UPDATER(entity, anim.updater));
		});
	}
	
	function handleBitmapAnim(entity) {
		
		fetch(bitmapAnims, entity, {
			bitmap.tile = anim.currFrame;
			anim.onFrame = () -> bitmap.tile = anim.currFrame;
			Command.queue(ADD_UPDATER(entity, anim.updater));
		});
	}
	
	function handleAC(ac:AnimCommand) {
		
		switch (ac) {
			case ADD_SHEET(sheet, id):
				sheetMap.set(id, sheet);
			case CREATE_ANIMATIONS(entity, from, animReqs, play):
				
				final anim = new AnimController();
				
				final sheet = sheetMap.get(from);
				for (req in animReqs) anim.add(req.fulfill(sheet));
				
				if (play != null && play.length > 0) anim.play(play);
				
				universe.setComponents(entity, anim);
		}
	}
}