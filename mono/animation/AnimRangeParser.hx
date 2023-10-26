package mono.animation;

class AnimRangeParser {
	
	public static function parseRanges(list:Array<String>) {
		
		var ranges;
		final res = [];
		final digitReg = ~/\d+(-\d+)?/g;
		var left, right, prevLeft = "", iters;
		
		for (str in list) {
			ranges = str.split(",");
			for (r in ranges) {
				
				if (digitReg.match(r)) {
					
					left = digitReg.matchedLeft();
					right = digitReg.matchedRight();
					
					iters = right.length > 0 && right.charCodeAt(0) == 'x'.code ? Std.parseInt(right.substr(1)) : 1;
					
					for (i in 0...iters) {
						if (left.length > 0) {
							appendRange(res, left, digitReg.matched(0));
							prevLeft = left;
						}
						
						else {
							appendRange(res, prevLeft, digitReg.matched(0));
						}
					}
				}
				
				else if (r.length > 0) {
					appendRange(res, r);
				}
			}
		}
		
		return res;
	}
	
	static function appendRange(a:Array<String>, prefix:String, range:String = "") {
		
		if (range.length == 0) {
			a.push(prefix);
			return;
		}
		
		final dashes = ~/[-–—]/g;
		
		if (!dashes.match(range)) {
			a.push(prefix + range);
			return;
		}
		
		final arr = dashes.split(range);
		final min = Std.parseInt(arr[0]);
		final max = Std.parseInt(arr[1]);
		
		if (min < max) {
			for (i in min...max + 1) {
				a.push(prefix + i);
			}
		}
		
		else {
			var i = min + 1;
			while (i-- > max) {
				a.push(prefix + i);
			}
		}
	}
}