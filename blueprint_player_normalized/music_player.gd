class_name MusicPlayer
extends AudioStreamPlayer

func _init(): set_autoplay(true)

# Both normalized functions recive inputs on whichever
# value, put prefferably its mapped from 0.0 to 1.0,
# thus being called normalized, on godot it makes sense
# calling them up to value of 5.0, whuch would be 23.2...
# decibels, aproaching Godot's limit of 24.
# If the input value is 0.0, then the function will 
# default to mute_db in order to not set the decibel
# levels to negative infinity, as godot would default it
# to, mute_db is customizable, but its the minimum godot
# admits when setting an audio output in decibels.
# The function itslf is a log base 2 value v (for volume)
# times 10 ( log2(v)*10  on Python )
const mute_db:float = -80.0
func get_volume_normalized():
	var vol:float = log(get_volume_db()) / log(2.0)
	return pow(2.0, vol)
func set_volume_normalized(volume:float):
	var vol:float = log(volume)*10.0 / log(2.0)
	set_volume_db( vol if (vol!=-INF) else mute_db )

# warning-ignore:unused_signal
# warning-ignore:unused_signal
signal fading_in
signal faded_in
var fading_in:bool	= false setget set_fading_in
func set_fading_in(f:bool):fading_in = f
func fade_in(time:float):
	if(fading_in):return
	var t:Tween = Tween.new()
# warning-ignore:return_value_discarded
	t.interpolate_method(self, "set_volume_normalized", get_volume_normalized(), 1.0, time)
# warning-ignore:return_value_discarded
# warning-ignore:return_value_discarded
	t.connect("tween_all_completed", self, "emit_signal", ["faded_in"])
	t.connect("tween_all_completed", t, "queue_free")
	
# warning-ignore:return_value_discarded
	connect("faded_in", self, "set_fading_in", [false])
	
# warning-ignore:return_value_discarded
# warning-ignore:return_value_discarded
# warning-ignore:return_value_discarded
	emit_signal("fading_in")
	set_fading_in(true)
	play()
	add_child(t)
# warning-ignore:return_value_discarded
	t.call_deferred("start")
# warning-ignore:unused_signal
# warning-ignore:unused_signal
signal fading_out
signal faded_out
var fading_out:bool	= false setget set_fading_out
func set_fading_out(f:bool):fading_out = f
func fade_out(time:float):
	if(fading_out):return
	var t:Tween = Tween.new()
# warning-ignore:return_value_discarded
	t.interpolate_method(self, "set_volume_normalized", get_volume_normalized(), 0.0, time)
# warning-ignore:return_value_discarded
# warning-ignore:return_value_discarded
	t.connect("tween_all_completed", self, "emit_signal", ["faded_out"])
	t.connect("tween_all_completed", t, "queue_free")
	
# warning-ignore:return_value_discarded
	connect("faded_out", self, "set_fading_out", [false])
	
	emit_signal("fading_out")
	set_fading_out(true)
	add_child(t)
# warning-ignore:return_value_discarded
	t.call_deferred("start")
func fade_out_in(fade_time:float, offset_time:float):
	fade_out(fade_time)
	yield(get_tree().create_timer(offset_time), "timeout")
	fade_in(fade_time)
