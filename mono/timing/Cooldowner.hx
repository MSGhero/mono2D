package mono.timing;

@:forward @:access(mono.timing.Updater)
abstract Cooldowner (Updater) from Updater to Updater {
	
	// strictly one update at a time
	// counter is forced to 0 after a callback instead of being decremented
	
	public function update(dt:Float) {
		
		if (this.isActive) {
			
			if (!this.isReady) {
				this.incrementCounter(dt);
				if (this.counter > this.duration) this.counter = this.duration;
			}
			
			else if (this.triggered) {
				
				if (this.callback != null) this.callback();
				
				if (this.repetitions > 0) {
					--this.repetitions;
					if (this.repetitions == 0 && this.onComplete != null) this.onComplete();
				}
				
				this.counter = 0;
			}
		}
		
		
	}
}