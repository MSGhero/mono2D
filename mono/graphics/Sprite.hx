package mono.graphics;

import IDs.BatchID;
import h2d.Tile;
import h2d.SpriteBatch.BatchElement;

class Sprite extends BatchElement {
	
	public var batchID:BatchID;
	
	public function new(t:Tile, batchID:BatchID) {
		super(t);
		
		this.batchID = batchID;
	}
}