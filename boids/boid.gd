class_name Boid extends CharacterBody2D

@export var number_of_rays := 30
@export var ray_length := 80.0
@export var ray_span_degrees := 200.0
@export var max_speed := 200.0
@export var separation_weight := 5.0
@export var alignment_weight := 2.0
@export var cohesion_weight := 1.0

var raycasts: Array[RayCast2D] = []
var visible_boids: Array[Boid] = []

@onready var ray_container := $RayContainer
@onready var vision := $Vision

func _ready() -> void:
	velocity = Vector2.RIGHT.rotated(rotation) * max_speed
	for i in range(number_of_rays):
		var ray = RayCast2D.new()
		ray_container.add_child(ray)
		ray.collision_mask = 0b0000_0001_0000_0001
		ray.position = Vector2.ZERO
		ray.target_position = ray_length * Vector2.RIGHT.rotated(
			deg_to_rad(ray_span_degrees) * (randf() - 0.5)
		)
		raycasts.append(ray)

	get_tree().create_timer(0.1).timeout.connect(_initial_boid_vision)

func _initial_boid_vision() -> void:
	for body in vision.get_overlapping_bodies():
		body = body as Boid
		if body and body not in visible_boids:
			visible_boids.append(body)

func _physics_process(delta: float) -> void:
	var acceleration := Vector2(0, 0)

	var boid_count: int = len(visible_boids)

	for ray in raycasts:
		if ray.is_colliding():
			var distance_vector := ray.get_collision_point() - global_position
			var inverse_distance: float = ray_length - distance_vector.length()
			acceleration -= separation_weight * inverse_distance * distance_vector.normalized()

	if boid_count > 0:
		var flock_avg_velocity := Vector2(0, 0)
		var flock_avg_global_position := Vector2(0, 0)
		for boid in visible_boids:
			flock_avg_velocity += boid.velocity
			flock_avg_global_position += boid.global_position

		# Alignment: match the average velocity of nearby boids
		flock_avg_velocity /= boid_count
		acceleration += (flock_avg_velocity - velocity) * alignment_weight

		# Cohesion: steer toward the centre of the flock
		flock_avg_global_position /= boid_count
		var avg_pos_direction = flock_avg_global_position - global_position
		acceleration += avg_pos_direction * cohesion_weight

	velocity = max_speed * (velocity + acceleration * delta).normalized()
	rotation = velocity.angle()
	move_and_slide()


func _on_vision_body_exited(body: Node2D) -> void:
	body = body as Boid
	if body and body not in visible_boids:
		visible_boids.append(body)

func _on_vision_body_entered(body: Node2D) -> void:
	body = body as Boid
	if body and body in visible_boids:
		visible_boids.erase(body)
