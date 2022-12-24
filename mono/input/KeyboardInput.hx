package mono.input;

import haxe.ds.Vector;
import mono.input.Input.InputMapping;
import hxd.Key;

class KeyboardInput extends InputDevice {
	
	public function new(mappings:InputMapping, isComplex:Vector<Bool> = null) {
		super("kb", mappings, isComplex);
	}
	
	function isButtonDown(buttonCode:Int) {
		return Key.isDown(buttonCode);
	}
}