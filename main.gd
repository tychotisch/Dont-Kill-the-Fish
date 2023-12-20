extends Node2D

@onready var oxygen_label: Label = $Background/UI/OxygenBar/OxygenLabel
@onready var oxygen_bar: ProgressBar = $Background/UI/OxygenBar
@onready var oxygen_timer: Timer = $OxygenTimer

var max_oxygen = 20
var oxygen = max_oxygen

func _ready() -> void:
	Events.connect("add_oxygen", increase_oxygen)
	Events.connect("deplete_oxygen", remove_oxygen)
	set_oxygen_ui()

func set_oxygen_ui():
	oxygen_bar.max_value = max_oxygen
	set_oxygen_label()
	set_oxygen_bar()

func set_oxygen_label():
	oxygen_label.text = "Oxygen: %s" % oxygen

func set_oxygen_bar():
	oxygen_bar.value = oxygen

func deplete_oxygen() -> void:
	oxygen -= 1
	set_oxygen_ui()
	if oxygen <= 0:
		oxygen = 0
		oxygen_timer.stop()
		Events.emit_signal("set_alive")
		Events.emit_signal("set_scroll")

func remove_oxygen(value):
	oxygen -= value
	set_oxygen_ui()
	if oxygen <= 0:
		oxygen = 0
		oxygen_timer.stop()
		Events.emit_signal("set_alive")
		Events.emit_signal("set_scroll")
	
func increase_oxygen(value):
	if oxygen > 0:
		oxygen += value
		set_oxygen_label()
		set_oxygen_bar()

func _on_oxygen_timer_timeout() -> void:
	deplete_oxygen()
