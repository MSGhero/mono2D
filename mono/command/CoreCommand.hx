package mono.command;

import mono.command.Command;

enum CoreCommand {
	REGISTER(type:Command, callback:Command->Void);
}