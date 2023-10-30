package mono.input;

import mono.input.Input.InputMapping;
import input.Action;
import haxe.ds.Vector;

abstract class InputDevice {
	
	public var name(default, null):String;
	
	var mapping:InputMapping;
	var isComplex:Vector<Bool>;
	
	public function new(name:String, mapping:InputMapping, isComplex:Vector<Bool> = null) {
		this.name = name;
		this.mapping = mapping;
		this.isComplex = isComplex == null ? new Vector(ActionMacros.count(Action)) : isComplex;
	}
	
	public function getStatus(action:Action):Bool {
		
		if (!isComplex[action])
			return areAnyDown(mapping[action]);
		
		var actions = mapping[action];
		
		for (aa in actions) {
			if (!getStatus(aa)) return false;
		}
		
		return true;
	}
	
	public function reset() { }
	
	abstract function isButtonDown(buttonCode:Int):Bool;
	
	function areAllDown(buttonCodes:Array<Int>):Bool {
		
		if (buttonCodes == null) return false;
		
		for (button in buttonCodes) {
			if (!isButtonDown(button)) return false;
		}
		
		return true;
	}
	
	function areAnyDown(buttonCodes:Array<Int>):Bool {
		
		if (buttonCodes == null) return false;
		
		for (button in buttonCodes) {
			if (isButtonDown(button)) return true;
		}
		
		return false;
	}
}