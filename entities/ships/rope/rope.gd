class_name Rope extends Node2D

@export var body_A: PhysicsBody2D
@export var body_B: PhysicsBody2D
@export var anchor_A: Node2D
@export var anchor_B: Node2D

@export_range(0.0, 0.9) var joint_bias : float = 0 :
	set(value):
		joint_bias = value
		for joint in joints_created:
			joint.bias = joint_bias

var segments_created: Array[RopeSegment] = []
var joints_created: Array[PinJoint2D] = []

const ROPE_SEGMENT = preload("res://entities/ships/rope/rope_segment.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not anchor_A:
		anchor_A = body_A
	if not anchor_B:
		anchor_B = body_B
	generate_rope_segments()

func create_pin_joint(pin_body_A: PhysicsBody2D, pin_body_B: PhysicsBody2D, pin_position: Vector2) -> void:
	var joint := PinJoint2D.new()
	add_child(joint)
	joints_created.append(joint)
	joint.global_position = pin_position
	joint.node_a = pin_body_A.get_path()
	joint.node_b = pin_body_B.get_path()
	joint.bias = joint_bias

func add_segment(rope_segment: RopeSegment) -> void:
	add_child(rope_segment)
	segments_created.append(rope_segment)

func generate_rope_segments() -> void:
	var rope_length: float = anchor_A.global_position.distance_to(anchor_B.global_position)
	var direction_angle: float = anchor_A.global_position.angle_to_point(anchor_B.global_position)
	
	var segment: RopeSegment = ROPE_SEGMENT.instantiate()
	add_segment(segment)
	segment.global_position = anchor_A.global_position - segment.segment_start.position
	segment.rotation = direction_angle
	
	var segment_count : int = ceili(rope_length / segment.length())
	for i in range(1, segment_count):
		var segment_start = lerp(anchor_A.global_position, anchor_B.global_position, float(i)/segment_count)
		segment = ROPE_SEGMENT.instantiate()
		add_segment(segment)
		segment.global_position = segment_start - segment.segment_start.position
		segment.rotation = direction_angle
	
	create_pin_joint(body_A, segments_created[0], anchor_A.global_position)
	for i in range(1, segment_count):
		create_pin_joint(segments_created[i-1], segments_created[i], segments_created[i].segment_start.global_position)
	create_pin_joint(segments_created[-1], body_B, anchor_B.global_position)
	
	
