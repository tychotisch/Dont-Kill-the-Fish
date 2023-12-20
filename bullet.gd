extends Area2D
class_name Bullet

var speed := 200
var direction := 0
var damage := 1

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is Fish:
		queue_free()
		if area.has_method("set_health"):
			area.set_health(damage)
