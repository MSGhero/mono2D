package mono.app;

import hxd.SceneEvents;
import hxd.Window;
import h3d.Engine;
import h2d.Scene;

@:structInit
class Stage {
	public var scenes:Array<Scene>;
	public var engine:Engine;
	public var window:Window;
	public var sceneEvents:SceneEvents;
	public var s2d(get, never):Scene;
	inline function get_s2d() return scenes[0];
	
	public function update(dt:Float) {
		for (scene in scenes) scene.setElapsedTime(dt);
		sceneEvents.checkEvents();
	}
	
	public function render() {
		if (!engine.begin()) return;
		for (scene in scenes) scene.render(engine);
		engine.end();
	}
}