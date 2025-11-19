extends Node
# Audio Manager
# TODO Will need further optimizations:
# 1. Currently I use a sound queue system that determines the order of the sfx,
# this alone is fine, but can lead to O(n) operations when dequed from due to array shifting
# Naively, we could change this to a queue system (which I was implementing in queue.gd)
# However if you want a far more efficent solution, doubly linked lists will do much better
# refer to neetcode problem: https://neetcode.io/problems/lru-cache/solution
# It pretty much emulates the LRU behavior I'm looking for this optimization
#
# 2. Now that you have your linked list like data strucutres, the purpose of doing this is that
# any audio stream can be completed regardless of the order they were queued in, thus 
# find a way to return them back to the free_streams array when complete. You'll very likely use
# a courtine to track the completion of an audio stream.
@export var audio_pool_intial: int = 10
var free_streams: Array[AudioStreamPlayer]
var sound_queue: Array[AudioStreamPlayer]
var playing_streams: Dictionary[String, AudioStreamPlayer]
var music_stream_player: AudioStreamPlayer
var sfx: Dictionary[String, AudioStream]
var music: Dictionary[String, AudioStream]
const music_path = "res://audio/music/"
const sfx_path = "res://audio/sfx/"

func _ready() -> void:
	_initialize_audio_streams()
	_intialize_audio_library()
	
func _initialize_audio_streams() -> void:
	for i in audio_pool_intial:
		var asp = AudioStreamPlayer.new()
		asp.max_polyphony = 5
		asp.bus = &"Sfx"
		free_streams.append(asp)
		add_child(asp)
	
	music_stream_player = AudioStreamPlayer.new()
	music_stream_player.bus = &"Music"
	add_child(music_stream_player)
	
func _intialize_audio_library() -> void:
	# Import Music into memory
	_add_audio_from_dir_to_dict(music_path, music)
	
	# Import Sfx into memory
	_add_audio_from_dir_to_dict(sfx_path, sfx)
	
	
func _add_audio_from_dir_to_dict(path, dict):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var absolute_path = "%s/%s" % [path, file_name]
			if dir.current_is_dir(): 
				# Recursive Call
				_add_audio_from_dir_to_dict(absolute_path, dict)
			else:
				if file_name.contains(".wav") or file_name.contains(".mp3"):
					var file_key = file_name.get_basename().get_file()
					dict[file_key] = ResourceLoader.load(absolute_path) as AudioStream
				else:
					push_warning("\"%s\" sound file was not in .wav format" % [file_name])
			file_name = dir.get_next()
				
	else:
		push_warning("AudioManager couldn't find %s file path, please add it!" % dir)
		
func play_sfx(sfx_name: String) -> void:
	if not sfx_name in sfx:
		push_warning("\"%s\" sfx does not exist!")
		return
		
	# Use the same stream to replay the sfx
	if sfx_name in playing_streams:
		playing_streams[sfx_name].play()
		
	if free_streams.is_empty(): 
		sound_queue.pop_front()
		
	var stream = free_streams.back()
	stream.stream = sfx[sfx_name]
	stream.play()
	playing_streams[sfx_name] = stream
	sound_queue.push_back(stream)
	
func play_music(music_name: String) -> void:
	if not music_name in music:
		push_warning("\"%s\" music does not exist!")
		return
	music_stream_player.stream = music[music_name]
	music_stream_player.play()
	
# Manually Created to be cleaner
	
# volume: [0, 1]
func set_master_volume(volume: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(bus_index, clampf(volume, 0, 1))
	
# volume: [0, 1]
func set_sfx_volume(volume: float) -> void:
	var bus_index = AudioServer.get_bus_index("Sfx")
	AudioServer.set_bus_volume_linear(bus_index, clampf(volume, 0, 1))
	
# volume: [0, 1]
func set_music_volume(volume: float) -> void:
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_linear(bus_index, clampf(volume, 0, 1))
