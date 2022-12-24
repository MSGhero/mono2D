package mono.input;

import haxe.ds.Vector;
import mono.input.Input.InputMapping;
import hxd.Pad;

class PadInput extends InputDevice {
	
	var pad:Pad;
	
	public function new(mappings:InputMapping, isComplex:Vector<Bool> = null) {
		super("pad", mappings, isComplex);
		
		// not robust... what about p2?
		@:privateAccess
		if (Pad.initDone) {
			pad = Pad.pads.iterator().next();
			if (pad == null) {
				trace("null pad");
				pad = Pad.createDummy();
			}
		}
		
		else {
			trace("new pad");
			pad = Pad.createDummy();
			Pad.wait(onPad);
		}
	}
	
	function onPad(pad:Pad) {
		trace('pad connected: ${pad.connected}');
		
		this.pad = pad;
		pad.axisDeadZone = 0.35;
	}
	
	function isButtonDown(buttonCode:Int):Bool {
		
		return switch (buttonCode:PadButtons) {
			case A: pad.buttons[pad.config.A];
			case B: pad.buttons[pad.config.B];
			case X: pad.buttons[pad.config.X];
			case Y: pad.buttons[pad.config.Y];
			case LB: pad.buttons[pad.config.LB];
			case RB: pad.buttons[pad.config.RB];
			case LT: pad.buttons[pad.config.LT];
			case RT: pad.buttons[pad.config.RT];
			case BACK: pad.buttons[pad.config.back];
			case START: pad.buttons[pad.config.start];
			case CLICK_L: pad.buttons[pad.config.analogClick];
			case CLICK_R: pad.buttons[pad.config.ranalogClick];
			case UP_DPAD: pad.buttons[pad.config.dpadUp];
			case DOWN_DPAD: pad.buttons[pad.config.dpadDown];
			case LEFT_DPAD: pad.buttons[pad.config.dpadLeft];
			case RIGHT_DPAD: pad.buttons[pad.config.dpadRight];
			case LEFT_L_VIRTUAL: pad.values[pad.config.analogX] < -pad.axisDeadZone;
			case RIGHT_L_VIRTUAL: pad.values[pad.config.analogX] > pad.axisDeadZone;
			case UP_L_VIRTUAL: -pad.values[pad.config.analogY] < -pad.axisDeadZone;
			case DOWN_L_VIRTUAL: -pad.values[pad.config.analogY] > pad.axisDeadZone;
			case LEFT_R_VIRTUAL: pad.values[pad.config.ranalogX] < -pad.axisDeadZone;
			case RIGHT_R_VIRTUAL: pad.values[pad.config.ranalogX] > pad.axisDeadZone;
			case UP_R_VIRTUAL: -pad.values[pad.config.ranalogY] < -pad.axisDeadZone;
			case DOWN_R_VIRTUAL: -pad.values[pad.config.ranalogY] > pad.axisDeadZone;
		}
	}
}

enum abstract PadButtons(Int) from Int to Int {
	var A;
	var B;
	var X;
	var Y;
	var LB;
	var RB;
	var LT;
	var RT;
	var BACK;
	var START;
	var CLICK_L;
	var CLICK_R;
	var UP_DPAD;
	var DOWN_DPAD;
	var LEFT_DPAD;
	var RIGHT_DPAD;
	var LEFT_L_VIRTUAL;
	var RIGHT_L_VIRTUAL;
	var UP_L_VIRTUAL;
	var DOWN_L_VIRTUAL;
	var LEFT_R_VIRTUAL;
	var RIGHT_R_VIRTUAL;
	var UP_R_VIRTUAL;
	var DOWN_R_VIRTUAL;
}