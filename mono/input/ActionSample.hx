package mono.input;

enum abstract Action(Int) from Int to Int {
	
	var L;
	var R;
	var U;
	var D;
	
	var SELECT;
	var DESELECT;
	
	var DEBUG;
	var MUTE;
	
	var VOL_UP;
	var VOL_DOWN;
}