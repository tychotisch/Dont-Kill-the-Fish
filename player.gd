extends Area2D
class_name Player

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var spawn_bubble_pos: Marker2D = $SpawnBubble
@onready var spawn_top_pos: Marker2D = $SpawnTop
@onready var bullet_to_instance := preload("res://Bullet/Bullet.tscn")
@onready var bubble_to_instance := preload("res://Objects/bubble.tscn")
@onready var bubble_timer: Timer = $BubbleTimer

var speed := 400
var screen_size 
var max_speed := 450.0
var drag_factor := 0.05
var velocity = Vector2.ZERO
var alive := true

func _ready():
	screen_size = get_viewport_rect().size
	Events.connect("set_alive", set_alive)
	Events.connect("set_alive", start_bubbles)

func _physics_process(delta: float) -> void:
	set_playable_area()
	if alive:
		set_movement(delta)
		if Input.is_action_just_pressed("shoot"):
			shoot()
	else:
		velocity.y -= 0.7 * delta
		position.y -= velocity.y
		if position.y >= screen_size.y - 50:
			Events.emit_signal("game_over")

func set_alive():
	alive = false
	animation.stop()
	velocity.y = 0

func set_movement(delta):
	look_at(get_global_mouse_position())
	rotation = clamp(rotation, -PI/5, PI/5)
	var direction := Input.get_vector("left", "right", "up", "down")
	var desired_velocity = max_speed * direction
	var steering_vector = desired_velocity - velocity
	velocity += steering_vector * drag_factor
	position += velocity * delta

func set_playable_area():
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func shoot():
	var bullet = bullet_to_instance.instantiate()
	get_tree().root.add_child(bullet)
	bullet.speed = 500
	bullet.global_transform = spawn_top_pos.global_transform

func spawn_bubble():
	var bubble = bubble_to_instance.instantiate()
	get_tree().root.add_child(bubble)
	bubble.global_transform = spawn_bubble_pos.global_transform

func start_bubbles():
	for i in 10:
		bubble_timer.start(0.7)
		await bubble_timer.timeout
		spawn_bubble()
