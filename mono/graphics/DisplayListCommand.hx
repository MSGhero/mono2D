package mono.graphics;

import h2d.Layers;
import h2d.Object;

enum DisplayListCommand {
     ADD_PARENT(parent:Layers, tag:String);
     ADD_TO(child:Object, parent:String, layer:Int);
	REMOVE_FROM_PARENT(child:Object);
}