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
	
	public function loadTexturePackerData(sheet:Image, data:String, sheetRef:String = "") {
		return
			if (data.charCodeAt(0) == '{'.code) loadTexturePackerJson(sheet, data, sheetRef);
			else loadTexturePackerMini(sheet, data, sheetRef);
	}
	
	public function loadTexturePackerJson(sheet:Image, jsonString:String, sheetRef:String = "") {
		
		var sheetTile = sheet.toTile();
		var tpData:TexturePackerData = Json.parse(jsonString);
		
		if (sheetRef.length > 0) this.set(sheetRef, sheetTile); // add the whole sheet rect to the spritesheet, for ref
		
		for (tpt in tpData.frames) {
			tpt.pivot ??= { x : 0, y : 0 };
			this.set(tpt.filename, sheetTile.sub(tpt.frame.x, tpt.frame.y, tpt.frame.w, tpt.frame.h, Math.ceil(tpt.spriteSourceSize.x - tpt.pivot.x * tpt.sourceSize.w), Math.ceil(tpt.spriteSourceSize.y - tpt.pivot.y * tpt.sourceSize.h)));
		}
		
		return this;
	}
	
	public function loadTexturePackerMini(sheet:Image, minifiedString:String, sheetRef:String = "") {
		
		var sheetTile = sheet.toTile();
		if (sheetRef.length > 0) this.set(sheetRef, sheetTile); // add the whole sheet rect to the spritesheet, for ref
		
		var lines = ~/[\r\n]+/g.split(minifiedString);
		
		// name frame(x,y,w,h) offset(x,y) source(w,h) pivot(x,y)
		// pivot optional
		// // comments within the file
		
		var props, name, frames, offset, source, pivot, defaultPivot = ["0", "0"];
		for (line in lines) {
			
			if (line.charCodeAt(0) == '/'.code) continue; // comment
			if (line.length <= 0) continue;
			
			name = line.substring(line.indexOf('"') + 1, line.indexOf('"', 1));
			props = line.substr(name.length + 3).split(" ");
			
			frames = offset = source = pivot = null;
			
			for (prop in props) {
				switch (prop) {
					case _.charCodeAt(0) => 'f'.code:
						frames = prop.substring(2, prop.length - 1).split(",");
					case _.charCodeAt(0) => 'o'.code:
						offset = prop.substring(2, prop.length - 1).split(",");
					case _.charCodeAt(0) => 's'.code:
						source = prop.substring(2, prop.length - 1).split(",");
					case _.charCodeAt(0) => 'p'.code:
						pivot = prop.substr(2, prop.length - 1).split(",");
				}
			}
			
			if (name.length == 0) {
				// throw
			}
			
			if (!(frames?.length > 0)) {
				// throw
			}
			
			if (!(offset?.length > 0)) {
				// throw
			}
			
			if (!(source?.length > 0)) {
				// throw
			}
			
			if (!(pivot?.length > 0)) {
				pivot = defaultPivot;
			}
			
			this.set(name, sheetTile.sub(
				Std.parseInt(frames[0]), Std.parseInt(frames[1]),
				Std.parseInt(frames[2]), Std.parseInt(frames[3]),
				Math.ceil(Std.parseInt(offset[0]) - Std.parseFloat(pivot[0]) * Std.parseInt(source[0])),
				Math.ceil(Std.parseInt(offset[1]) - Std.parseFloat(pivot[1]) * Std.parseInt(source[1]))
			));
		}
		
		return this;
	}
	
	public function loadSingle(sheet:Image, name:String) {
		this.set(name, sheet.toTile());
		return this;
	}
	
	public inline function loadAnimation(sheet:Image, animBaseName:String, numRows:Int, numCols:Int, from:Int = 0, count:Int = -1) {
		loadSubTiles(sheet.toTile(), animBaseName, numRows, numCols, from, count);
	}
	
	public function loadSubTiles(sheetTile:Tile, animBaseName:String, numRows:Int, numCols:Int, from:Int = 0, count:Int = -1) {
		
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