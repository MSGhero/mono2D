package mono.animation;

class AnimParser {
	
	public static function parseText(text:String) {
		
		final crlf = ~/[\r\n]+/g;
		final lines = crlf.split(text);
		var spaceIndex = -1, bracketIndex = -1, rbIndex = -1, prefix = "", name = "", frames = "", frameIndex = -1, loop = false, fps = -1, state = FIND_PREFIX, line = "";
		var i = 0;
		
		var reqs:Array<AnimRequest> = [];
		
		while (i < lines.length) {
			line = StringTools.rtrim(lines[i]); // could be reworked
			if (line.length <= 0) continue;
			
			switch (state) {
				
				case FIND_PREFIX:
					
					if (line.charCodeAt(0) != '\t'.code) {
						
						spaceIndex = line.indexOf(" ");
						
						if (spaceIndex < 0) {
							prefix = line;
							i++;
						}
						
						else prefix = line.substring(0, spaceIndex);
					}
					
					// else keep old prefix
					spaceIndex = -1;
					state = FIND_NAME;
					
				case FIND_NAME:
					
					if (spaceIndex < 0) {
						if (line.charCodeAt(0) != '\t'.code) {
							// error
						}
						
						else spaceIndex = 0; // fake value
					}
					
					bracketIndex = line.indexOf("[", spaceIndex);
					if (bracketIndex == spaceIndex + 1) name = "default";
					else {
						name = line.substring(spaceIndex + 1, bracketIndex - 1);
					}
					
					frames = "";
					frameIndex = bracketIndex + 1;
					state = FIND_FRAMES;
					
				case FIND_FRAMES:
					
					rbIndex = line.indexOf("]", bracketIndex);
					
					if (rbIndex < 0) {
						// see if there's anything on the line
						if (line.length > frameIndex) {
							if (frames.length > 0) frames += ',';
							frames += line.substring(frameIndex);
						}
						
						bracketIndex = -1;
						frameIndex = 2;
						i++;
					}
					
					else if (rbIndex < frameIndex) {
						// end
						state = FIND_LOOP;
					}
					
					else {
						
						if (bracketIndex > -1) {
							if (frames.length > 0) frames += ',';
							frames += line.substring(bracketIndex + 1, rbIndex);
							state = FIND_LOOP;
						}
						
						else {
							// weird edge case, don't feel like thinking
						}
					}
				
				case FIND_LOOP:
					spaceIndex = line.indexOf(" ", rbIndex + 1);
					loop = line.substr(spaceIndex + 1, 4) == "loop"; // loop or true tbh
					state = FIND_FPS;
				
				case FIND_FPS:
					if (loop) spaceIndex = line.indexOf(" ", spaceIndex + 1);
					
					if (spaceIndex < 0) fps = 1;
					else fps = Std.parseInt(line.substring(spaceIndex));
					
					state = FIND_PREFIX;
					i++;
					
					reqs.push({
						name : prefix + "_" + name,
						frameNames : parseRanges(frames.split(",")),
						loop : loop,
						fps : fps
					});
			}
		}
		
		return reqs;
	}
	
	public static function parseRanges(list:Array<String>) {
		
		var ranges;
		final res = [];
		final digitReg = ~/\d+-\d+/g;
		var left, right, prevLeft = "", iters;
		
		for (str in list) {
			ranges = str.split(",");
			for (r in ranges) {
				
				// doesn't account for xN at the end of a single frame...
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
		final lenMin = arr[0].length;
		final lenMax = arr[1].length;
		
		if (min < max) {
			for (i in min...max + 1) {
				a.push(prefix + StringTools.lpad(Std.string(i), "0", lenMin));
			}
		}
		
		else {
			var i = min + 1;
			while (i-- > max) {
				a.push(prefix + StringTools.lpad(Std.string(i), "0", lenMax));
			}
		}
	}
}

private enum abstract ParseState(Int) {
	var FIND_PREFIX;
	var FIND_NAME;
	var FIND_FRAMES;
	var FIND_LOOP;
	var FIND_FPS;
}