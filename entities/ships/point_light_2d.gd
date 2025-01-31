extends PointLight2D

var target_direction := Vector2()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	if not direction.is_zero_approx():
		target_direction = direction
		rotation = target_direction.angle() + deg_to_rad(0) - get_parent().rotation
	else:
		rotation = rotate_toward(rotation, deg_to_rad(-90), 3 * delta)
