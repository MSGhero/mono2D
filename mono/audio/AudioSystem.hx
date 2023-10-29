package mono.audio;

import mono.timing.TimingCommand;
import mono.timing.Timing;
import hxd.Res;
import hxd.snd.SoundGroup;
import mono.command.Command;
import haxe.ds.StringMap;
import ecs.Universe;
import ecs.System;
import hxd.snd.Manager;
import hxd.snd.Channel;
import mono.input.Input;
import mono.audio.AudioCommand;
import ecs.Entity;

class AudioSystem extends System {
	
	@:fullFamily
	var audio : {
		resources : {
			manager:Manager,
			volumeInfo:AudioVolume
		},
		requires : {
			channel:Channel,
			info:AudioInfo
		}
	};
	
	var sfxGroup:SoundGroup;
	var uiGroup:SoundGroup;
	
	var taggedSounds:StringMap<Channel>;
	
	public function new(ecs:Universe) {
		super(ecs);
		
		sfxGroup = new SoundGroup("sfx");
		uiGroup = new SoundGroup("ui");
		
		taggedSounds = new StringMap();
		
		ecs.setResources(
			Manager.get(), // sound manager
			({ music : 1 }:AudioVolume) // volume of different audio types
		);
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		Command.register(PLAY(null, null), handleAC);
		Command.register(STOP_BY_TYPE(MUSIC), handleAC);
		Command.register(STOP_BY_TAG(""), handleAC);
		Command.register(SET_ON_AUDIO_END("", null), handleAC);
		Command.register(FADE(0, 0, 0, null, ""), handleAC);
		Command.register(MUTE(false), handleAC);
		Command.register(MUTE_TOGGLE(null), handleAC);
		Command.register(ADJUST_VOLUME(0, null), handleAC);
		Command.register(SET_VOLUME(0, null), handleAC);
	}
	
	function handleAC(ac:AudioCommand) {
		
		switch (ac) {
			case PLAY(snd, info):
				setup(audio, {
					
					var channel:Channel = null;
					
					switch (info.type) {
						case MUSIC:
							channel = snd.play(info.loop, info.volume * volumeInfo.musicMult);
							if (info.tag.length == 0) info.tag = "music";
							taggedSounds.set(info.tag, channel);
						case VOICE:
							channel = snd.play(info.loop, info.volume * volumeInfo.voiceMult);
							if (info.tag.length == 0) info.tag = "voice";
							taggedSounds.set(info.tag, channel);
						case SFX:
							channel = snd.play(info.loop, info.volume * volumeInfo.sfxMult);
							if (info.tag.length > 0) taggedSounds.set(info.tag, channel);
							else info.tag = "sfx";
						case UI:
							channel = snd.play(info.loop, info.volume * volumeInfo.uiMult);
							if (info.tag.length > 0) taggedSounds.set(info.tag, channel);
							else info.tag = "ui";
					}
					
					channel.position = info.position;
					universe.setComponents(universe.createEntity(), channel, info);
				});
			case STOP_BY_TYPE(type):
				switch (type) {
					case MUSIC: if (taggedSounds.exists("music")) taggedSounds.get("music").stop();
					case VOICE: if (taggedSounds.exists("voice")) taggedSounds.get("voice").stop();
					case SFX: setup(audio, { manager.stopByName("sfx"); });
					case UI: setup(audio, { manager.stopByName("ui"); });
				}
			case STOP_BY_TAG(tag):
				taggedSounds.get(tag).stop();
			case SET_ON_AUDIO_END(tag, onEnd):
				final ch = taggedSounds.get(tag);
				ch.onEnd = () -> {
					onEnd();
					ch.onEnd = () -> { };
				};
			case FADE(duration, initVolume, finalVolume, ease, tag):
				final ch = taggedSounds.get(tag);
				final tw = Timing.tween(duration, f -> {
					ch.volume = initVolume + (finalVolume - initVolume) * f;
				});
				if (ease != null) tw.ease = ease;
				Command.queue(ADD_UPDATER(Entity.none, tw));
			case MUTE(mute):
				setup(audio, {
					manager.suspended = volumeInfo.muted = mute;
				});
			case MUTE_TOGGLE(onToggle):
				setup(audio, {
					manager.suspended = volumeInfo.muted = !volumeInfo.muted;
					if (onToggle != null) onToggle(volumeInfo.muted);
				});
			case ADJUST_VOLUME(delta, callback):
				setup(audio, {
					volumeInfo.master = Math.max(0, Math.min(1, volumeInfo.master + delta));
					manager.masterVolume = volumeInfo.master;
					if (callback != null) callback(volumeInfo.master);
				});
			case SET_VOLUME(vol, callback):
				setup(audio, {
					volumeInfo.master = Math.max(0, Math.min(1, vol));
					manager.masterVolume = volumeInfo.master;
					if (callback != null) callback(volumeInfo.master);
				});
		}
	}
}