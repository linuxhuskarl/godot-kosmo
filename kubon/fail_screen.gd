extends Control

func _ready() -> void:
	get_tree().create_tween().tween_property(self, "modulate", Color.WHITE, 0.5).from(Color.BLACK)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://kubon/start_screen.tscn")
