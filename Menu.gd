extends Control

@onready var menu: Control = $"."

func _ready() -> void:
	Events.connect("game_over", game_over)
	show_menu()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		show_menu()

func _on_start_button_pressed() -> void:
	hide_menu()

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	menu.show()

func _on_quit_pressed() -> void:
	get_tree().quit()

func game_over():
	show_menu()

func show_menu():
	menu.visible = true
	get_tree().paused = true
	
func hide_menu():
	menu.visible = false
	get_tree().paused = false






