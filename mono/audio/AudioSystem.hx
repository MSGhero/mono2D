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

// this one isn't done, but it's decent now
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
	
	@:fullFamily
	var inputs : {
		resources : {
			manager:Manager
		},
		requires : {
			input:Input
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
		
		Command.register(PLAY(MUSIC, "", false, 0, ""), handleAC);
		Command.register(STOP_BY_TYPE(MUSIC), handleAC);
		Command.register(STOP_BY_TAG(""), handleAC);
		Command.register(SET_ON_AUDIO_END("", null), handleAC);
		Command.register(RESET_VOLUME, handleAC);
		Command.register(FADE(0, 0, 0, null, ""), handleAC);
	}
	
	function handleAC(ac:AudioCommand) {
		
		switch (ac) {
			case PLAY(type, resPath, loop, volume, tag):
				setup(audio, {
					
					var snd = Res.load(resPath).toSound();
					var channel:Channel = null;
					var info:AudioInfo = {
						type : type,
						loop : loop,
						volume : volume
					};
					
					var useTag = tag != null && tag.length > 0;
					
					// there's a bug with ECS and exhaustiveness checks, need to submit new issue
					// untyped for now
					untyped switch (type) {
						case MUSIC:
							channel = snd.play(info.loop, info.volume * volumeInfo.musicMult);
							info.tag = useTag ? tag : "music";
							taggedSounds.set(info.tag, channel);
						case VOICE:
							channel = snd.play(info.loop, info.volume * volumeInfo.voiceMult);
							info.tag = useTag ? tag : "voice";
							taggedSounds.set(info.tag, channel);
						case SFX:
							channel = snd.play(info.loop, info.volume * volumeInfo.sfxMult);
							if (useTag) {
								info.tag = tag;
								taggedSounds.set(info.tag, channel);
							}
							else info.tag = "sfx";
						case UI:
							channel = snd.play(info.loop, info.volume * volumeInfo.uiMult);
							if (useTag) {
								info.tag = tag;
								taggedSounds.set(info.tag, channel);
							}
							else info.tag = "ui";
					}
					
					universe.setComponents(universe.createEntity(), channel, info);
				});
			case STOP_BY_TYPE(type):
				switch (type) {
					case MUSIC: taggedSounds.get("music").stop();
					case VOICE: taggedSounds.get("voice").stop();
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
			case RESET_VOLUME:
				// when volumeInfo gets changed, update all existing sounds
			case FADE(duration, initVolume, finalVolume, ease, tag):
				final ch = taggedSounds.get(tag);
				final tw = Timing.tween(duration, f -> {
					ch.volume = initVolume + (finalVolume - initVolume) * f;
				});
				if (ease != null) tw.ease = ease;
				Command.queue(ADD_UPDATER(Entity.none, tw));
		}
	}
	
	override function update(dt:Float) {
		super.update(dt);
		
		setup(inputs, {
			iterate(inputs, {
				if (input.justPressed.MUTE) {
					manager.suspended = !manager.suspended;
				}
				// need to implement vol up/down along with reset vol command
			});
		});
	}
}