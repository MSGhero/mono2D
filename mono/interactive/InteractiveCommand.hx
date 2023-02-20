package mono.interactive;

import ecs.Entity;

enum InteractiveCommand {
	DISABLE_INTERACTIVE(entity:Entity);
	ENABLE_INTERACTIVE(entity:Entity);
}