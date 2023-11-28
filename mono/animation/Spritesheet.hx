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
	
	public function loadTexturePackerMini(sheet:Image, minifiedString:String, sheetRef:String = "") {
		
		var sheetTile = sheet.toTile();
		if (sheetRef.length > 0) this.set(sheetRef, sheetTile); // add the whole sheet rect to the spritesheet, for ref
		
		var lines = ~/[\r\n]+/.split(minifiedString);
		
		// name frame(x,y,w,h) offset(x,y) source(w,h) pivot(x,y)
		// pivot optional
		
		var props, name, frames, offset, source, pivot, defaultPivot = ["0", "0"];
		for (line in lines) {
			props = line.split(" ");
			
			name = "";
			frames = offset = source = pivot = null;
			
			for (prop in props) {
				switch (prop) {
					case _.substr(0, 5) => "frame":
						frames = prop.substring(6, prop.length - 1).split(",");
					case _.substr(0, 6) => "offset":
						offset = prop.substring(7, prop.length - 1).split(",");
					case _.substr(0, 6) => "source":
						source = prop.substring(7, prop.length - 1).split(",");
					case _.substr(0, 5) => "pivot":
						pivot = prop.substr(6, prop.length - 1).split(",");
					default:
						name = prop;
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
				Std.parseInt(offset[0]) - Std.parseFloat(pivot[0]) * Std.parseInt(source[0]),
				Std.parseInt(offset[1]) - Std.parseFloat(pivot[1]) * Std.parseInt(source[1])
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