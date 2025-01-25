extends Control

@onready var score: Label = $MarginContainer/VBoxContainer/Score

func _ready() -> void:
	# pobranie wyniku gracza i przekazanie do score
	score.text = "1000"
