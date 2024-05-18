package mono.app;

import ecs.Universe;

abstract class AMono {
	
	var stage:Stage;
	var ecsRef:Universe;
	
	public function new(stage:Stage) {
		this.stage = stage;
		prepECS();
	}
	
	abstract function prepECS():Void;
	abstract function postInit():Void;
	
	public function update(dt:Float) {
		stage.update(dt);
		ecsRef.update(dt);
	}
	
	public function render() {
		stage.render();
	}
}