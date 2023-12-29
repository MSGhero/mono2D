package mono.graphics;

import IDs.BatchID;
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
		sprite:Sprite,
		batch:BatchID
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
		
		sprites.onEntityAdded.subscribe(onSprite);
		
		Command.register(CREATE_BATCH("", "", 0), handleRC);
		Command.register(ADD_SPRITE(null, ""), handleRC);
		Command.register(ADD_SPRITES(null, ""), handleRC);
		Command.register(POSITION_SPRITE(Entity.none, 0, 0), handleRC);
		Command.register(SPACE_SPRITES(null, 0, 0), handleRC);
		Command.register(GRID_SPRITES(null, 0, 0, 0, 0), handleRC);
		
		Command.register(ADD_PARENT(null, ""), handleDLC);
		Command.register(ADD_TO(null, "", 0), handleDLC);
		Command.register(REMOVE_FROM_PARENT(null), handleDLC);
	}
	
	function handleRC(rc:RenderCommand) {
		
		switch (rc) {
			case CREATE_BATCH(tag, parentTag, layer):
				final batch = new SpriteBatch(null); // input tile is not used
				batchMap.set(tag, batch);
				batch.hasRotationScale = true; // don't like this, mb just create batch locally
				Command.queue(ADD_TO(batch, parentTag, layer));
			case ADD_SPRITE(sprite, to):
				batchMap.get(to).add(sprite);
			case ADD_SPRITES(sprites, to):
				final batch = batchMap.get(to);
				for (sprite in sprites)
					batch.add(sprite);
			case POSITION_SPRITE(entity, x, y):
				fetch(sprites, entity, {
					sprite.x = x;
					sprite.y = y;
				});
			case SPACE_SPRITES(entities, dx, dy):
				
				var entity, xx = 0.0, yy = 0.0;
				for (i in 0...entities.length) {
					entity = entities[i];
					
					fetch(sprites, entity, {
						
						if (i == 0) {
							xx = sprite.x;
							yy = sprite.y;
						}
						
						else {
							xx += dx;
							yy += dy;
							sprite.x = xx;
							sprite.y = yy;
						}
					});
				}
			
			case GRID_SPRITES(entities, dx, dy, maxCols, maxRows):
				
				var sx = 0.0, sy = 0.0;
				var entity = entities[0];
				fetch(sprites, entity, {
					sx = sprite.x;
					sy = sprite.y;
				});
				
				if (maxCols <= 0) maxCols = Math.ceil(entities.length / maxRows);
				
				for (i in 1...entities.length) {
					entity = entities[i];
					
					fetch(sprites, entity, {
						sprite.x = sx + dx * (i % maxCols);
						sprite.y = sy + dy * Std.int(i / maxCols);
					});
				}
		}
	}
	
	function handleDLC(dlc:DisplayListCommand) {
		
		switch (dlc) {
			case ADD_PARENT(parent, tag): // parentid should be part of its batch, then add onAdded
				parentMap.set(tag, parent);
			case ADD_TO(child, parent, layer):
				parentMap.get(parent).add(child, layer);
			case REMOVE_FROM_PARENT(child):
				child.remove();
			default:
		}
	}
	
	function onSprite(entity:Entity) {
		
		fetch(sprites, entity, {
			batchMap.get(batch).add(sprite);
		});
	}
}