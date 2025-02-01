extends Node2D

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var ending: Area2D = $AreasOfEffect/Ending

func _ready() -> void:
	PlayerState.restart_timer()
	var bubble: Bubble = get_tree().get_first_node_in_group("bubble")
	assert(bubble, "This level requires a Bubble in the SceneTree")

	bubble.died.connect(func():
		var blackout_tween = get_tree().create_tween()
		blackout_tween.tween_property(canvas_modulate, "color", Color(-1,-1,-1), 1.5)
		await blackout_tween.finished
		get_tree().change_scene_to_file("res://scenes/menu_screens/fail_screen.tscn")
	)
	ending.body_entered.connect(func(body):
		if is_instance_of(body, Bubble):
			PlayerState.stop_timer()
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
