package mono.graphics;

import haxe.ds.StringMap;
import h2d.Layers;
import h2d.SpriteBatch;
import ecs.Entity;
import mono.command.Command;
import ecs.Universe;
import ecs.System;
import mono.graphics.DisplayListCommand;
import mono.graphics.RenderCommand;

class RenderSystem extends System {
	
	@:fastFamily
	var sprites : {
		sprite:Sprite
	};
	
	var batchMap:StringMap<SpriteBatch>;
	var parentMap:StringMap<Layers>;
	
	public function new(ecs:Universe) {
		super(ecs);
		
		batchMap = new StringMap();
		parentMap = new StringMap();
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		Command.register(CREATE_BATCH("", "", 0), handleRC);
		Command.register(ALLOC_SPRITE(Entity.none, ""), handleRC);
		Command.register(ALLOC_SPRITES(null, ""), handleRC);
		Command.register(POSITION_SPRITE(Entity.none, 0, 0), handleRC);
		
		Command.register(ADD_PARENT(null, ""), handleDLC);
		Command.register(ADD_TO(null, "", 0), handleDLC);
		Command.register(REMOVE_FROM_PARENT(null), handleDLC);
	}
	
	function handleRC(rc:RenderCommand) {
		
		switch (rc) {
			case CREATE_BATCH(tag, parentTag, layer):
				final batch = new SpriteBatch(null); // input tile is not used
				batchMap.set(tag, batch);
				Command.queue(ADD_TO(batch, parentTag, layer));
			case ALLOC_SPRITE(entity, from):
				final elt = batchMap.get(from).alloc(null); // the animation will set the tile properly
				universe.setComponents(entity, (elt:Sprite));
			case ALLOC_SPRITES(entities, from):
				final batch = batchMap.get(from); // avoids many stringmap gets
				var elt:Sprite;
				for (entity in entities) {
					elt = batch.alloc(null);
					universe.setComponents(entity, (elt:Sprite));
				}
			case POSITION_SPRITE(entity, x, y):
				fetch(sprites, entity, {
					sprite.x = x;
					sprite.y = y;
				});
		}
	}
	
	function handleDLC(dlc:DisplayListCommand) {
		
		switch (dlc) {
			case ADD_PARENT(parent, tag):
				parentMap.set(tag, parent);
			case ADD_TO(child, parent, layer):
				parentMap.get(parent).add(child, layer);
			case REMOVE_FROM_PARENT(child):
				child.remove();
			default:
		}
	}
}