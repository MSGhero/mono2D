package mono.state;

enum StateCommand {
	REGISTER_STATE(state:State, tag:Int);
	REGISTER_ENTER(to:Int, callback:()->Void);
	REGISTER_EXIT(from:Int, callback:()->Void);
	REGISTER_TRIGGER(type:String, callback:(message:String)->Void);
	ENTER(state:Int);
	EXIT(state:Int);
	TRIGGER(type:String, message:String);
}