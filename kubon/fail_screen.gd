extends Control

@onready var back: Button = $VBoxContainer/Back

func _ready() -> void:
	back.grab_focus()
	get_tree().create_tween().tween_property(self, "modulate", Color.WHITE, 0.5).from(Color.BLACK)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://kubon/start_screen.tscn")
