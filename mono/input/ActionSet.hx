package mono.input;

class ActionSet {

	public var justReleased:ActionList;
	public var justPressed:ActionList;
	public var pressed:ActionList;

	public function new() {
		justReleased = new ActionList();
		justPressed = new ActionList();
		pressed = new ActionList();
	}
	
	public function copyFrom(as:ActionSet) {
		justReleased.copyFrom(as.justReleased);
		justPressed.copyFrom(as.justPressed);
		pressed.copyFrom(as.pressed);
	}
	
	public function updateJust(prev:ActionSet) {
		
		for (i in 0...justReleased.length) {
			justReleased[i] = !pressed[i] && prev.pressed[i];
			justPressed[i] = !prev.pressed[i] && pressed[i];
		}
	}
}