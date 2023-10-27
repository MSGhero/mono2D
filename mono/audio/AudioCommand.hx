package mono.audio;

import mono.audio.AudioInfo;
import hxd.res.Sound;
import mono.audio.AudioType;

enum AudioCommand {
	PLAY(snd:Sound, info:AudioInfo);
	STOP_BY_TYPE(type:AudioType);
	STOP_BY_TAG(tag:String);
	SET_ON_AUDIO_END(tag:String, onEnd:()->Void);
	RESET_VOLUME;
	FADE(duration:Float, initVolume:Float, finalVolume:Float, ease:Float->Float, tag:String);
}