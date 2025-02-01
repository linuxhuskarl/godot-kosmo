class_name SceneManagerClass extends Node

signal scene_changed

enum TransitionType {
    NONE                = 0,
    FADE_BLACK          = 1,
    FADE_WHITE          = 2,
}

enum TransitionEffect {
    NONE                = 0,
    VIBRATION_WEAK      = 1,
    VIBRATION_STRONG    = 2,
}

class Levels:
    const TUTORIAL = "res://scenes/levels/tutorial_level.tscn"
    const L1 = "res://scenes/levels/level_1.tscn"

class Screens:
    const MAIN_MENU = "res://scenes/menu_screens/start_screen.tscn"
    const FAIL = "res://scenes/menu_screens/fail_screen.tscn"
    const END = "res://scenes/menu_screens/end_screen.tscn"

var loading_screen_scene = preload("res://scenes/menu_screens/loading_screen.tscn")

@warning_ignore("unused_parameter")
func change_scene(scene_name: StringName, t_type: int = TransitionType.NONE, t_effect: int = TransitionEffect.NONE) -> void:
    var loaded_scene := ResourceLoader.load(scene_name) as PackedScene
    assert(loaded_scene)
    get_tree().change_scene_to_packed(loaded_scene)
    scene_changed.emit()
