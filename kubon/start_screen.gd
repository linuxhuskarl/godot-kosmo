extends Control

@onready var play: Button = $MarginContainer/VBoxContainer/MarginContainer2/Play

func _ready() -> void:
	play.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test_ground.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
