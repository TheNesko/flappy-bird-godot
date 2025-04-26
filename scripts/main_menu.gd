extends Node

var bird_starting_position = Vector2.ZERO

func _ready() -> void:
	bird_starting_position = $Bird.position
	$Bird.alive = false
	$Bird.get_node("Sprite").play("flop")

func _physics_process(delta: float) -> void:
	move_bird()

func move_bird():
	var bird = $Bird
	bird.move()
	if bird.position.y > bird_starting_position.y:
		bird.jump()


func _on_start_button_up() -> void:
	get_parent().change_scene("game")


func _on_exit_button_up() -> void:
	get_tree().quit()
