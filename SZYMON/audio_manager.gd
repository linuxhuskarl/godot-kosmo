class_name AudioManagerClass extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var engine_player: AudioStreamPlayer = $EngineSounds

var engine_on := false
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


func _process(delta):
	var btn_press = Input.is_action_pressed("left") or Input.is_action_pressed("right") \
		or Input.is_action_pressed("left_reverse") or Input.is_action_pressed("right_reverse")
	if not engine_on and btn_press:
		EngineOn();
	elif engine_on and not btn_press:
		EngineOff();

func EngineOn():
	engine_on = true
	print("Wciśnięto klawisze lewo albo prawo!");
	engine_player.set("parameters/switch_to_clip", "EngineOn");

func EngineOff():
	engine_on = false
	print("Puszczony klawisz A/D");
	engine_player.set("parameters/switch_to_clip", "EngineOff");
