class_name RopeSegment extends RigidBody2D

@onready var segment_start: Marker2D = $SegmentStart
@onready var segment_end: Marker2D = $SegmentEnd

func length() -> float:
	return segment_start.global_position.distance_to(segment_end.global_position)
