package mono.timing;

class Replenisher extends Updater {
	
	public var rechargeRate:Float;
	
	public function new(duration:Float, rechargeRate:Float) {
		super(duration, -1, false);
		
		this.rechargeRate = rechargeRate;
	}
	
	override public function update(dt:Float) {
		
		if (isActive) {
			
			if (triggered && isTimeLeft) {
				decrementCounter(dt * rechargeRate);
				if (counter < 0) counter = 0;
			}
			
			else if (isReady) {
				
				counter = duration;
				
				if (callback != null) callback();
				if (onComplete != null) onComplete();
			}
			
			else {
				incrementCounter(dt);
			}
		}
	}
}