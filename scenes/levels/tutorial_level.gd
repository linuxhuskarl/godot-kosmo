extends Node2D

@onready var ending: Area2D = $Ending
@onready var canvas_modulate: CanvasModulate = $CanvasModulate

func _ready() -> void:
	ending.body_entered.connect(func(body):
		var bubble := body as Bubble
		if bubble:
			Input.start_joy_vibration(0, 0.5, 0.0, 1.0)
			var tween = get_tree().create_tween()
			tween.tween_property(canvas_modulate, "color", Color(12,12,12), 1.5)
			await tween.finished
			get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
	)
