class_name Cthulhu extends Node2D

enum EnemyState {NONE, IDLE, CHASE, FLEE}

@export var state := EnemyState.IDLE
@export var target: Node2D
@export var fleeing_time: float = 1.0

var _was_in_light: bool = false
var _the_source_of_light: Vector2
var flee_timer: SceneTreeTimer
var hand_tween: Tween
var macka_tween: Tween
var action_completed := true
var already_attacked := false

@onready var bubble_detector: Area2D = $DetectionRange
@onready var macka_idle_target: Marker2D = $IKTargets/MackaIdleTarget
@onready var macka_target: Marker2D = $IKTargets/MackaTarget
@onready var hand_idle_target: Marker2D = $IKTargets/HandIdleTarget
@onready var hand_target: Marker2D = $IKTargets/HandTarget
@onready var skeleton_2d: Skeleton2D = $Body/Skeleton2D

func _ready() -> void:
	macka_target.global_position = macka_idle_target.global_position
	hand_target.global_position = hand_idle_target.global_position

func reset_hand_ik_target():
	if hand_tween:
		hand_tween.kill()
	hand_target.global_position = hand_idle_target.global_position

func reset_macka_ik_target():
	if macka_tween:
		macka_tween.kill()
	macka_target.global_position = macka_idle_target.global_position

func change_state(new_state: EnemyState) -> void:
	print_debug(EnemyState.keys()[new_state])
	match new_state:
		EnemyState.FLEE:
			action_completed = false
			already_attacked = true
			if hand_tween:
				hand_tween.kill()
			hand_tween = get_tree().create_tween()
			hand_tween.set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_BACK)
			hand_tween.tween_property(hand_target, 'global_position', 
					hand_idle_target.global_position, 3.0)
			
			if macka_tween:
				macka_tween.kill()
			macka_tween = get_tree().create_tween()
			hand_tween.set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_BACK)
			macka_tween.tween_property(macka_target, 'global_position', 
					macka_idle_target.global_position, 3.0)
			macka_tween.tween_callback(func(): action_completed = true)
		EnemyState.IDLE:
			_was_in_light = false
			reset_hand_ik_target()
			reset_macka_ik_target()
		EnemyState.CHASE:
			already_attacked = false
			action_completed = false
			if hand_tween:
				hand_tween.kill()
			hand_tween = get_tree().create_tween()
			hand_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
			hand_tween.tween_property(hand_target, 'global_position', 
					target.global_position, 3.0)
			
			if macka_tween:
				macka_tween.kill()
			macka_tween = get_tree().create_tween()
			macka_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
			macka_tween.tween_property(macka_target, 'global_position', 
					target.global_position, 3.0)
			macka_tween.tween_callback(func(): action_completed = true)
	state = new_state

func deter(source: Vector2):
	if state != EnemyState.FLEE and not _was_in_light or state == EnemyState.FLEE:
		change_state(EnemyState.FLEE)

func bubble_in_range() -> Bubble:
	for body in bubble_detector.get_overlapping_bodies():
		var bubble := body as Bubble
		if bubble:
			# print_debug("Found bubble")
			return bubble
	return null

func find_bubble_and_transition_to_chase() -> bool:
	if state == EnemyState.CHASE:
		return false
	var bubble := bubble_in_range()
	if bubble:
		print_debug("Cthulhu found bubble!!!!")
		target = bubble
		change_state(EnemyState.CHASE)
		return true
	return false

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
			elif not bubble_in_range():
				change_state(EnemyState.IDLE)
			elif action_completed:
				change_state(EnemyState.CHASE)
		EnemyState.FLEE:
			if action_completed and not find_bubble_and_transition_to_chase():
					change_state(EnemyState.IDLE)


func _on_macka_grabber_body_entered(body: Node2D) -> void:
	if already_attacked:
		return
	var bubble := body as Bubble
	if bubble:
		# toward mouth
		bubble.apply_central_impulse(-1000 * global_position.direction_to(bubble.global_position))
		change_state(EnemyState.FLEE)
		bubble.hurt(60.0)


func _on_hand_grabber_body_entered(body: Node2D) -> void:
	if already_attacked:
		return
	var ship := body as Ship
	if ship:
		# away from mouth
		ship.apply_central_impulse(-5000 * global_position.direction_to(ship.global_position))
		change_state(EnemyState.FLEE)
	var bubble := body as Bubble
	if bubble:
		# toward mouth
		bubble.apply_central_impulse(-500 * global_position.direction_to(bubble.global_position))
		change_state(EnemyState.FLEE)
		bubble.hurt(80.0)
