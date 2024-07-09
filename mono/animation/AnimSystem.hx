package mono.animation;

import hxd.Res;
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
	
	var protoController:AnimController;
	
	public function new(ecs:Universe) {
		super(ecs);
		
		protoController = new AnimController();
		ecs.setResources(new StringMap<Spritesheet>());
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		anims.onEntityAdded.subscribe(handleAnim);
		spriteAnims.onEntityAdded.subscribe(handleSpriteAnim);
		pictureAnims.onEntityAdded.subscribe(handlePictureAnim);
		
		Command.register(ADD_SHEET(null, ""), handleAC);
		Command.register(PARSE_ANIMS(null, ""), handleAC);
		Command.register(ADD_ANIMS(null, ""), handleAC);
	}
	
	function handleAnim(entity) {
		
		fetch(anims, entity, {
			anim.refAnimsFrom(protoController);
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
			case PARSE_ANIMS(paths, sheetID):
				setup(anims, {
					final sheet = sheetMap.get(sheetID);
					var reqs;
					for (path in paths) {
						reqs = AnimParser.parseText(Res.load(path).entry.getText());
						for (req in reqs) {
							protoController.add(req.fulfill(sheet));
						}
					}
				});
			case ADD_ANIMS(animReqs, sheetID):
				setup(anims, {
					final sheet = sheetMap.get(sheetID);
					for (req in animReqs) {
						protoController.add(req.fulfill(sheet));
					}
				});
		}
	}
}