package mono.layout;

import ecs.Entity;

enum Align {
	NONE;
	OFFSET(to:Entity, x:Float, y:Float);
}