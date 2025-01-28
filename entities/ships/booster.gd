class_name Booster extends CollisionShape2D

@export var force := 2000
@export var action := &"no_input"
@export var reverse_action := &"no_input"

@onready var emitter: CPUParticles2D = $Particles


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	var parent := get_parent() as RigidBody2D
	if not parent:
		return


	var input := Input.get_axis(reverse_action, action)
	if input != 0.0:
		parent.apply_force(
			Vector2.from_angle(global_rotation) * input * force,
			global_position - parent.global_position
		)
		emitter.direction.x = -1 if input > 0 else 1
		emitter.emitting = true
	else:
		emitter.emitting = false
