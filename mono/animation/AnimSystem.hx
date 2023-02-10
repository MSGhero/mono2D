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
		Command.register(PLAY_ANIMATION(Entity.none, ""), handleAC);
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
				
				var newAnim = null;
				
				fetch(anims, entity, {
					// if animcontroller already exists, add to it instead
					newAnim = anim;
				});
				
				if (newAnim == null) newAnim = new AnimController();
				
				final sheet = sheetMap.get(from);
				for (req in animReqs) newAnim.add(req.fulfill(sheet));
				
				if (play != null && play.length > 0) newAnim.play(play);
				
				universe.setComponents(entity, newAnim);
				
			case PLAY_ANIMATION(entity, play):
				fetch(anims, entity, {
					anim.play(play);
				});
			
			case COPY_ANIMATIONS(entity, from, play):
				
				fetch(anims, from, {
					final newAnim = new AnimController();
					newAnim.copyFrom(anim);
					newAnim.play(play);
				});
		}
	}
}