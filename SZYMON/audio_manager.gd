class_name AudioManagerClass extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer

var current_track: String = ""
# Funkcja zmieniająca muzykę z przejściem
func change_music_to(track: String):
	print("zmieniam muze na ", track)
	if track == current_track:
		print("Ten utwór już gra: ", track)
		return
	
	# Aktualizuj utwór i zmieniaj muzykę
	current_track = track
	if track:
		music_player.set("parameters/switch_to_clip", track)
		if not music_player.playing:
			print("Nie grało, więc włączyłem: ", track)
			music_player.play()
		else:
			print("Muzyka gra, zmieniono utwór na: ", track)
	else:
		print("Stopuję muzykę")
		music_player.stop()
		current_track = ""
