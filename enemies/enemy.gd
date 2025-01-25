class_name Enemy extends CharacterBody2D

enum EnemyState {NONE, IDLE, CHASE, FLEE}

@export var state := EnemyState.IDLE
@export var target: Node2D
@export var max_speed: float = 100
@export var fleeing_time: float = 1.0
@export var min_distance: float = 70.0

var _next_state: EnemyState = EnemyState.NONE
var _was_in_light: bool = false
var _the_source_of_light: Vector2
var flee_timer: SceneTreeTimer
@onready var bubble_detector: Area2D = $BubbleDetector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func change_state(new_state: EnemyState) -> void:
	print_debug(EnemyState.keys()[new_state])
	match new_state:
		EnemyState.FLEE:
			var flee_timer := get_tree().create_timer(fleeing_time)
			flee_timer.timeout.connect(func(): change_state(EnemyState.IDLE))
		EnemyState.IDLE:
			_was_in_light = false
	state = new_state

func deter(source: Vector2):
	if state != EnemyState.FLEE:
		_was_in_light = true
		_the_source_of_light = source
	elif flee_timer and flee_timer.time_left > 0:
		flee_timer.time_left = fleeing_time

func bubble_in_range() -> Bubble:
	for body in bubble_detector.get_overlapping_bodies():
		var bubble := body as Bubble
		if bubble:
			print_debug("FOund bubble")
			return bubble
	return null

func find_bubble_and_transition_to_chase():
	if state == EnemyState.CHASE:
		return
	var bubble := bubble_in_range()
	if bubble:
		print_debug("Found bubble!!!!", bubble)
		target = bubble
		change_state(EnemyState.CHASE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		EnemyState.NONE:
			change_state(EnemyState.IDLE)
		EnemyState.IDLE:
			if _was_in_light: # if in POV of light
				_was_in_light = false
				change_state(EnemyState.FLEE)
			else:
				find_bubble_and_transition_to_chase()
		EnemyState.CHASE:
			if _was_in_light: # if in POV of light
				_was_in_light = false
				change_state(EnemyState.FLEE)
			elif target:
				move_to(delta, target.global_position)
			else:
				change_state(EnemyState.IDLE)
		EnemyState.FLEE:
			move_away(delta, _the_source_of_light)
	move_and_slide()

func move_to(delta, gl_pos: Vector2):
	if gl_pos.distance_to(global_position) > min_distance:
		velocity = velocity.move_toward(global_position.direction_to(gl_pos) * max_speed, 2 * max_speed * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 2 * max_speed * delta)
	velocity = velocity.normalized() * min(max_speed, velocity.length())

func move_away(delta, gl_pos: Vector2):
	velocity = velocity.move_toward(-global_position.direction_to(gl_pos) * max_speed, 2 * max_speed * delta)
	velocity = velocity.normalized() * min(max_speed, velocity.length())
