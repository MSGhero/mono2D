package mono.timing;

import ecs.Entity;
import mono.timing.Updater;

enum TimingCommand {
     ADD_UPDATER(entity:Entity, updater:Updater);
	CALL(func:Void->Void);
}