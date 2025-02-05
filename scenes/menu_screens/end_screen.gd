extends Control

@onready var score: Label = $MarginContainer/VBoxContainer/Score
@onready var back: Button = $MarginContainer/VBoxContainer/Back

func _ready() -> void:
	back.grab_focus()
	get_tree().create_tween().tween_property(self, "modulate", Color.WHITE, 1).from(Color(12,12,12))
	# pobranie wyniku gracza i przekazanie do score
	@warning_ignore("integer_division")
	score.text = str(PlayerState.time_passed_ms / 1000)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_screens/start_screen.tscn")
