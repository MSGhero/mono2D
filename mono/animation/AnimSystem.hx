package mono.animation;

import haxe.ds.StringMap;
import ecs.Entity;
import mono.timing.TimingCommand;
import mono.command.Command;
import ecs.Universe;
import ecs.System;
import mono.graphics.Sprite;
import mono.animation.AnimCommand;
import mono.graphics.Picture;

class AnimSystem extends System {
	
	@:fullFamily
	var anims : {
		resources : {
			sheetMap:StringMap<Spritesheet>
		},
		requires : {
			anim:AnimController
		}
	}
	
	@:fastFamily
	var spriteAnims : {
		anim:AnimController,
		sprite:Sprite
	}
	
	@:fastFamily
	var pictureAnims : {
		anim:AnimController,
		picture:Picture
	}
	
	public function new(ecs:Universe) {
		super(ecs);
		
		ecs.setResources(new StringMap<Spritesheet>());
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		anims.onEntityAdded.subscribe(handleAnim);
		spriteAnims.onEntityAdded.subscribe(handleSpriteAnim);
		pictureAnims.onEntityAdded.subscribe(handlePictureAnim);
		
		Command.register(ADD_SHEET(null, ""), handleAC);
		Command.register(CREATE_ANIMATION(Entity.none, "", null, "", null), handleAC);
		Command.register(CREATE_ANIMATIONS(null, "", null, ""), handleAC);
		Command.register(CREATE_FRAME_ANIM(Entity.none, "", ""), handleAC);
		Command.register(PLAY_ANIMATION(Entity.none, ""), handleAC);
		Command.register(PLAY_ANIMATION_FROM(Entity.none, "", 0), handleAC);
		Command.register(COPY_ANIMATIONS(Entity.none, Entity.none, ""), handleAC);
	}
	
	function handleAnim(entity) {
		
		fetch(anims, entity, {
			Command.queue(ADD_UPDATER(entity, anim.updater));
		});
	}
	
	function handleSpriteAnim(entity) {
		
		fetch(spriteAnims, entity, {
			if (anim.currAnim != null) sprite.t = anim.currFrame;
			anim.onFrame = () -> sprite.t = anim.currFrame;
		});
	}
	
	function handlePictureAnim(entity) {
		
		fetch(pictureAnims, entity, {
			if (anim.currAnim != null) picture.tile = anim.currFrame;
			anim.onFrame = () -> picture.tile = anim.currFrame;
		});
	}
	
	function handleAC(ac:AnimCommand) {
		
		switch (ac) {
			case ADD_SHEET(sheet, id):
				setup(anims, {
					sheetMap.set(id, sheet);
				});
			case CREATE_ANIMATION(entity, from, animReqs, play, optionalController):
				
				setup(anims, {
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
				});
				
			case CREATE_ANIMATIONS(entities, from, animReqs, play):
				
				setup(anims, {
					
					final firstAnim = new AnimController();
					final sheet = sheetMap.get(from);
					for (req in animReqs) firstAnim.add(req.fulfill(sheet));
					
					var entity, newAnim;
					for (i in 0...entities.length) {
						entity = entities[i];
						
						if (i == 0) {
							newAnim = firstAnim;
						}
						
						else {
							newAnim = new AnimController();
							newAnim.copyFrom(firstAnim);
						}
						
						if (play != null && play.length > 0) newAnim.play(play);
						universe.setComponents(entity, newAnim);
					}
				});
				
			case CREATE_FRAME_ANIM(entity, from, frameName):
				
				setup(anims, {
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
				});
				
			case PLAY_ANIMATION(entity, play):
				fetch(anims, entity, {
					anim.play(play);
				});
			
				
			case PLAY_ANIMATION_FROM(entity, play, from):
				fetch(anims, entity, {
					anim.play(play, from);
				});
			
			case COPY_ANIMATIONS(entity, from, play):
				
				fetch(anims, from, {
					final newAnim = new AnimController();
					newAnim.refAnimsFrom(anim);
					if (play != null && play.length > 0) newAnim.play(play);
					universe.setComponents(entity, newAnim);
				});
		}
	}
}