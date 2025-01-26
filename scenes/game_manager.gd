extends Node2D

@onready var bubble: Bubble = $Ship/Bubble
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var ending: Area2D = $AreasOfEffect/Ending

@onready var time_started_ms : int

func _ready() -> void:
	time_started_ms = Time.get_ticks_msec()
	PlayerState.time_passed = 0
	bubble.died.connect(func():
		var tween = get_tree().create_tween()
		tween.tween_property(canvas_modulate, "color", Color(0.0, 0.0, 0.0), 1.5)
		await tween.finished
		get_tree().change_scene_to_file("res://kubon/fail_screen.tscn")
	)
	ending.body_entered.connect(func(body):
		var bubble := body as Bubble
		if bubble:
			PlayerState.time_passed = (Time.get_ticks_msec() - time_started_ms) / 1000
			Input.start_joy_vibration(0, 0.5, 0.0, 1.0)
			var tween = get_tree().create_tween()
			tween.tween_property(canvas_modulate, "color", Color(12, 12, 12), 1.5)
			await tween.finished
			get_tree().change_scene_to_file("res://kubon/end_screen.tscn")
	)
