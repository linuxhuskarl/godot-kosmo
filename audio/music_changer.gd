extends Area2D

@export var target_track: String  # Ustaw, który utwór ma być odtwarzany w tym obszarze

func _on_body_entered(body: Node2D) -> void:
	var ship := body as Ship
	if ship:
		AudioManager.change_music_to(target_track)
