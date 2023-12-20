extends ParallaxBackground

var speed := -75
var target_velocity := speed

func _ready() -> void:
	Events.connect("set_scroll", stop_scroll)

func _process(delta: float) -> void:
	if speed == target_velocity:
		scroll_offset.x += speed * delta
	else:
		speed = lerp(speed, 0, 0.01 * delta)
		scroll_offset.x += speed * delta

func stop_scroll():
	target_velocity = 0
