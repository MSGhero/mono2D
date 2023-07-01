package mono.animation;

import haxe.Json;
import hxd.res.Image;
import h2d.Tile;
import haxe.ds.StringMap;

@:forward(get, exists)
abstract Spritesheet(StringMap<Tile>) {
	
	public function new() {
		this = new StringMap();
	}
	
	public function loadTexturePackerData(sheet:Image, jsonString:String, sheetRef:String = "") {
		
		var sheetTile = sheet.toTile();
		var tpData:TexturePackerData = Json.parse(jsonString);
		
		if (sheetRef.length > 0) this.set(sheetRef, sheetTile); // add the whole sheet rect to the spritesheet, for ref
		
		for (tpt in tpData.frames) {
			tpt.pivot ??= { x : 0, y : 0 };
			this.set(tpt.filename, sheetTile.sub(tpt.frame.x, tpt.frame.y, tpt.frame.w, tpt.frame.h, tpt.spriteSourceSize.x - tpt.pivot.x * tpt.sourceSize.w, tpt.spriteSourceSize.y - tpt.pivot.y * tpt.sourceSize.h));
		}
		
		return this;
	}
	
	public function loadSingle(sheet:Image, name:String) {
		this.set(name, sheet.toTile());
		return this;
	}
	
	public function loadAnimation(sheet:Image, animBaseName:String, numRows:Int, numCols:Int, from:Int = 0, count:Int = -1) {
		
		var sheetTile = sheet.toTile();
		var ww = Std.int(sheetTile.width / numCols);
		var hh = Std.int(sheetTile.height / numRows);
		var i = 0, j = 0;
		
		for (rr in 0...numRows) {
			for (cc in 0...numCols) {
				
				if (i < from) {
					i++;
					continue;
				}
				
				if (count > -1 && j >= count) break;
				
				this.set('${animBaseName}${j}', sheetTile.sub(cc * ww, rr * hh, ww, hh));
				i++; j++;
			}
		}
	}
	
	public function map(names:Array<String>):Array<Tile> {
		return names.map(this.get);
	}
	
	public function dispose() {
		
		for (tile in this) {
			tile.dispose();
		}
		
		this.clear();
	}
}