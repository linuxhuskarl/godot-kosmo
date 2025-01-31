extends Node2D

@onready var bubble: Bubble = $ShipWithBubble/Bubble
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var ending: Area2D = $AreasOfEffect/Ending

@onready var time_started_ms : int

func _ready() -> void:
	time_started_ms = Time.get_ticks_msec()
	PlayerState.time_passed = 0
	bubble.died.connect(func():
		var blackout_tween = get_tree().create_tween()
		blackout_tween.tween_property(canvas_modulate, "color", Color(-1,-1,-1), 1.5)
		await blackout_tween.finished
		get_tree().change_scene_to_file("res://scenes/menu_screens/fail_screen.tscn")
	)
	ending.body_entered.connect(func(body):
		if is_instance_of(body, Bubble):
			@warning_ignore("integer_division")
			PlayerState.time_passed = (Time.get_ticks_msec() - time_started_ms) / 1000
			Input.start_joy_vibration(0, 0.5, 0.0, 1.0)
			var whiteout_tween = get_tree().create_tween()
			whiteout_tween.tween_property(canvas_modulate, "color", Color(12, 12, 12), 1.5)
			await whiteout_tween.finished
			get_tree().change_scene_to_file("res://scenes/menu_screens/end_screen.tscn")
	)
	
	var fadein_tween = get_tree().create_tween()
	fadein_tween.tween_property(canvas_modulate, "color", canvas_modulate.color, 1.5).from(Color(-1,-1,-1))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var fadeout_tween = get_tree().create_tween()
		fadeout_tween.tween_property(canvas_modulate, "color", Color(0, 0, 0), 1.0)
		await fadeout_tween.finished
		get_tree().change_scene_to_file("res://scenes/menu_screens/start_screen.tscn")
		
