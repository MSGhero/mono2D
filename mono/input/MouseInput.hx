package mono.input;

import hxd.Key;
import haxe.ds.Vector;
import mono.input.Input.InputMapping;

class MouseInput extends InputDevice {
     
	public static var WHEEL:Float = 0; // I don't like this, but hey
	
     public function new(mappings:InputMapping, isComplex:Vector<Bool> = null) {
          super("mouse", mappings, isComplex);
     }
     
	override function reset() {
		super.reset();
		
		WHEEL = 0;
	}
	
     function isButtonDown(buttonCode:Int) {
		
		return switch (buttonCode) {
			case Key.MOUSE_WHEEL_UP:
				WHEEL < 0.0;
			case Key.MOUSE_WHEEL_DOWN:
				WHEEL > 0.0;
			default:
				Key.isDown(buttonCode);
		};
     }
}