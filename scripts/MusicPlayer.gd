extends Node

const SONG_DIRECTORY = "res://assets/sounds/music/"
var audio_player : AudioStreamPlayer

func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	audio_player.bus = "Music"
	self.add_child.call(audio_player)
	var stream = AudioStreamOggVorbis.load_from_file(SONG_DIRECTORY + "daysong.ogg")
	audio_player.stream = stream
	audio_player.play()
