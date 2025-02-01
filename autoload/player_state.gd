class_name PlayerStateClass extends Node

var time_passed_ms: int = -1
var _timer_started: int = -1

func restart_timer() -> void:
    time_passed_ms = -1
    _timer_started = Time.get_ticks_msec()

func stop_timer() -> void:
    if _timer_started != -1:
        time_passed_ms = Time.get_ticks_msec() - _timer_started
        _timer_started = -1

func get_time_ms() -> int:
    if _timer_started != -1:
        return Time.get_ticks_msec() - _timer_started
    return time_passed_ms
