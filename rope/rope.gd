extends Node2D

@export var body_A: PhysicsBody2D = null
@export var body_B: PhysicsBody2D = null
@export_range(0.0, 0.9) var joint_bias : float = 0 :
	set(value):
		joint_bias = value
		for joint in joints_created:
			joint.bias = joint_bias

var segments_created: Array[RopeSegment] = []
var joints_created: Array[PinJoint2D] = []


@onready var rope_start: Marker2D = $RopeStart
@onready var rope_end: Marker2D = $RopeEnd

const ROPE_SEGMENT = preload("res://rope/rope_segment.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_rope_segments()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_pin_joint(body_A: PhysicsBody2D, body_B: PhysicsBody2D, pin_position: Vector2) -> void:
	var joint := PinJoint2D.new()
	add_child(joint)
	joints_created.append(joint)
	joint.global_position = pin_position
	joint.node_a = body_A.get_path()
	joint.node_b = body_B.get_path()
	joint.bias = joint_bias

func generate_rope_segments() -> void:
	var rope_length: float = rope_start.global_position.distance_to(rope_end.global_position)
	var direction_angle: float = rope_start.global_position.angle_to_point(rope_end.global_position)
	var temp_segment: RopeSegment = ROPE_SEGMENT.instantiate()
	add_child(temp_segment)
	var segment_length : float = temp_segment.length()
	temp_segment.queue_free()
	var segment_count : int = ceili(rope_length / segment_length)
	var real_segment_length : float = rope_length / segment_count
	for i in range(segment_count):
		var segment_start = lerp(rope_start.global_position, rope_end.global_position, float(i)/segment_count)
		var segment: RopeSegment = ROPE_SEGMENT.instantiate()
		add_child(segment)
		segments_created.append(segment)
		segment.global_position = segment_start - segment.segment_start.position
		segment.rotation = direction_angle
	
	create_pin_joint(body_A, segments_created[0], rope_start.global_position)
	for i in range(1, segment_count):
		create_pin_joint(segments_created[i-1], segments_created[i], segments_created[i].segment_start.global_position)
	create_pin_joint(segments_created[-1], body_B, rope_end.global_position)
	
	
