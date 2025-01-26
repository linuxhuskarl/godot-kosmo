class_name Ship extends RigidBody2D


@onready var raycasty: Node2D = $Raycasty


func check_enemy_and_deter(ray: RayCast2D) -> void:
	var body = ray.get_collider()
	if (body as Enemy): # or (body as Cthulhu):
		body.deter(global_position)


func _process(delta: float) -> void:
	for ray in raycasty.get_children():
		check_enemy_and_deter(ray)
