extends Node2D

@onready var bubble: Node2D = $"."

var speed := 100
var direction := 1
var oxygen_increase := 1

func _physics_process(delta: float) -> void:
	position.y -= speed * delta * direction

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is Bullet:
		Events.emit_signal("add_oxygen", oxygen_increase)
		bubble.queue_free()
	if area is Player:
		Events.emit_signal("add_oxygen", oxygen_increase)
		bubble.queue_free()

