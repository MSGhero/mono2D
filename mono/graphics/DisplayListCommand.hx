package mono.graphics;

import mono.graphics.LayerID;
import mono.graphics.ParentID;
import h2d.Layers;
import h2d.Object;

enum DisplayListCommand {
     ADD_PARENT(parent:Layers, tag:ParentID);
     ADD_TO(child:Object, parent:ParentID, layer:LayerID);
	REMOVE_FROM_PARENT(child:Object);
}