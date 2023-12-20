extends Area2D
class_name Fish

@export var dash_speed := 200
@export var velocity := 120
@export var health := 3

@onready var bubble_to_instance := preload("res://Objects/bubble.tscn")
@onready var spawn_bubble_pos: Marker2D = $SpawnBubblePos
@onready var player_detection: RayCast2D = $PlayerDetection
@onready var animation: AnimatedSprite2D = $Animations
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_bar: ProgressBar = $Health/HealthBar
@onready var health_label: Label = $Health/HealthBar/HealthLabel
@onready var bubble_timer: Timer = $BubbleTimer

var alive := true
var float_speed := 50
var start_position_y := randi() % 1080
var start_position_x := 2000

func _ready() -> void:
	randomize()
	global_position.y = start_position_y
	global_position.x = start_position_x
	set_health_ui()
	animation.play("swimming")

func set_health_ui():
	health_bar.max_value = health
	set_health_label()
	set_health_bar()

func set_health_label():
	health_label.text = "Health: %s" % health

func set_health_bar():
	health_bar.value = health

func _physics_process(delta: float) -> void:
	if alive:
		position.x -= velocity * delta
		if player_detection.is_colliding():
			set_dashing()
	else:
		position.x -= 75 * delta
		position.y -= float_speed * delta

func _on_bubble_timer_timeout() -> void:
	spawn_bubble()

func spawn_bubble():
	var bubble = bubble_to_instance.instantiate()
	get_tree().root.add_child(bubble)
	bubble.global_transform = spawn_bubble_pos.global_transform

func set_dashing():
	velocity = dash_speed
	animation.play("dashing")

#set health is called by the bullet
func set_health(damage):
	if health > 0:
		health -= damage
		set_health_bar()
		set_health_label()
	if health == 0 and alive:
		set_death()

func set_death():
	alive = false
	health_bar.hide()
	health_label.hide()
	bubble_timer.stop()
	animation.speed_scale = 0 
	animation_player.play("death")
	Events.emit_signal("deplete_oxygen", 5)

func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		set_dashing()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
