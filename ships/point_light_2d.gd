extends PointLight2D

var look_at := Vector2()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	if not direction.is_zero_approx():
		look_at = direction
		rotation = look_at.angle() + deg_to_rad(135) - get_parent().rotation
	else:
		rotation = rotate_toward(rotation, deg_to_rad(45), 3 * delta)
