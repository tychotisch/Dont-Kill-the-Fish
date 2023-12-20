extends Node2D

#Fish
@onready var fish_blue := preload("res://Fish/fish.tscn")
@onready var fish_types := [fish_blue]

@onready var spawn_timer: Timer = $SpawnTimer

func spawn_fish():
	var fish_type = fish_types[randi() % fish_types.size()]
	var fish_to_spawn = fish_type.instantiate()
	add_child(fish_to_spawn)

func _on_spawn_timer_timeout() -> void:
	spawn_fish()
