class_name LoadingScreen extends CanvasLayer

signal midpoint

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

func _ready() -> void:
	progress_bar.visible = false

func start_transition(t_type: int = SceneManager.TransitionType.FADE_BLACK) -> void:
	match t_type:
		SceneManager.TransitionType.FADE_BLACK:
			animation_player.play("fade_to_black")
		SceneManager.TransitionType.FADE_WHITE:
			animation_player.play("fade_to_white")
		_:
			animation_player.play("fade_to_black")
	timer.start()
	animation_player.animation_finished.connect(func(): midpoint.emit())

func finish_transition(t_type: int = SceneManager.TransitionType.FADE_BLACK) -> void:
	timer.stop()
	match t_type:
		SceneManager.TransitionType.FADE_BLACK:
			animation_player.play("fade_from_black")
		SceneManager.TransitionType.FADE_WHITE:
			animation_player.play("fade_from_white")
		_:
			animation_player.play("fade_from_black")
	# Remove the loading screen after the transition finishes
	animation_player.animation_finished.connect(func(): queue_free())

func _on_timer_timeout() -> void:
	progress_bar.visible = true