class_name Ship extends RigidBody2D


@onready var raycasts: Node2D = $Reflector/Raycasty


func check_enemy_and_deter(ray: RayCast2D) -> void:
	var body: Node2D = ray.get_collider()
	
	if body and body.is_in_group("enemy"):
		body.deter(global_position)


func _process(_delta: float) -> void:
	for ray in raycasts.get_children():
		check_enemy_and_deter(ray)
