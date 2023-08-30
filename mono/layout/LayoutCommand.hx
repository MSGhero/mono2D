package mono.layout;

import ecs.Entity;

enum LayoutCommand {
	ENFORCE_ALL;
	ENFORCE_FOR(entity:Entity);
}