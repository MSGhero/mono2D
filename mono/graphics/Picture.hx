package mono.graphics;

import h2d.Bitmap;
import IDs.BatchID;
import h2d.Tile;

class Picture extends Bitmap {
	
	public var parentID:ParentID;
	public var layerID:LayerID;
	
	public function new(?t:Tile, parentID:ParentID, layerID:IDs.LayerID) {
		super(t);
		
		this.parentID = parentID;
		this.layerID = layerID;
	}
}