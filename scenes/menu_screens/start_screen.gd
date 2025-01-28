extends Control

@onready var play: Button = $MarginContainer/VBoxContainer/MarginContainer2/Play

func _ready() -> void:
	play.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/tutorial_level.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_play_skip_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
