extends Node2D

@export var max_boids := 20
@export var delay := 0.2
@export var boid_scene := preload("res://entities/boids/boid.tscn")

var timer: Timer = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = false
	timer.wait_time = delay
	timer.timeout.connect(spawn_boid)
	timer.start()

func spawn_boid() -> void:
	if get_child_count() < max_boids:
		var boid = boid_scene.instantiate()
		add_child(boid)
