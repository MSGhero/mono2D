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
		
		anims.onEntityAdded.subscribe(handleAnim);
		spriteAnims.onEntityAdded.subscribe(handleSpriteAnim);
		bitmapAnims.onEntityAdded.subscribe(handleBitmapAnim);
		
		Command.register(ADD_SHEET(null, ""), handleAC);
		Command.register(CREATE_ANIMATIONS(Entity.none, "", null, "", null), handleAC);
		Command.register(CREATE_FRAME_ANIM(Entity.none, "", ""), handleAC);
		Command.register(PLAY_ANIMATION(Entity.none, ""), handleAC);
		Command.register(COPY_ANIMATIONS(Entity.none, Entity.none, ""), handleAC);
	}
	
	function handleAnim(entity) {
		
		fetch(anims, entity, {
			Command.queue(ADD_UPDATER(entity, anim.updater));
		});
	}
	
	function handleSpriteAnim(entity) {
		
		fetch(spriteAnims, entity, {
			sprite.t = anim.currFrame;
			anim.onFrame = () -> sprite.t = anim.currFrame;
		});
	}
	
	function handleBitmapAnim(entity) {
		
		fetch(bitmapAnims, entity, {
			bitmap.tile = anim.currFrame;
			anim.onFrame = () -> bitmap.tile = anim.currFrame;
		});
	}
	
	function handleAC(ac:AnimCommand) {
		
		switch (ac) {
			case ADD_SHEET(sheet, id):
				sheetMap.set(id, sheet);
			case CREATE_ANIMATIONS(entity, from, animReqs, play, optionalController):
				
				var newAnim:AnimController = null;
				
				fetch(anims, entity, {
					// if animcontroller already exists, add to it instead
					newAnim = anim;
				});
				
				if (newAnim == null) newAnim = optionalController ?? new AnimController();
				
				final sheet = sheetMap.get(from);
				for (req in animReqs) newAnim.add(req.fulfill(sheet));
				
				if (play != null && play.length > 0) newAnim.play(play);
				if (optionalController == null) universe.setComponents(entity, newAnim);
				
			case CREATE_FRAME_ANIM(entity, from, frameName):
				
				var newAnim:AnimController = null;
				
				fetch(anims, entity, {
					// if animcontroller already exists, add to it instead
					newAnim = anim;
				});
				
				newAnim = newAnim ?? new AnimController();
				
				final sheet = sheetMap.get(from);
				final req:AnimRequest = {
					name : "default",
					frameNames : [frameName],
					loop : false
				};
				
				newAnim.add(req.fulfill(sheet));
				newAnim.play("default");
				universe.setComponents(entity, newAnim);
				
			case PLAY_ANIMATION(entity, play):
				fetch(anims, entity, {
					anim.play(play);
				});
			
			case COPY_ANIMATIONS(entity, from, play):
				
				fetch(anims, from, {
					final newAnim = new AnimController();
					newAnim.copyFrom(anim);
					if (play != null && play.length > 0) newAnim.play(play);
					universe.setComponents(entity, newAnim);
				});
		}
	}
}