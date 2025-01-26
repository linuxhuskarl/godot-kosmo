class_name Bubble extends RigidBody2D

signal died

@export var health: float = 100.0
@export var max_health: float = 100.0
@export var health_regen: float = 5.0

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	if health > 0.0 and health < max_health:
		health += health_regen * delta
	point_light_2d.color = Color(Color.BLACK).lerp(Color.WHITE, clampf(health/max_health, 0.0, 1.0))
	if not animation_player.is_playing():
		animation_player.play("default")

func hurt(dmg: float) -> void:
	health -= dmg
	animation_player.play("hit")
	if health < 0.0:
		died.emit()
