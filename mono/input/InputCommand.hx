package mono.input;

enum InputCommand {
     ADD_INPUT(mapping:Input, tag:String);
     ENABLE_INPUT(tag:String);
     DISABLE_INPUT(tag:String);
}