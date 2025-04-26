extends Node

var bird_starting_position = Vector2.ZERO
@onready var bird = $Bird

func _ready() -> void:
	get_tree().get_root().size_changed.connect(set_up)
	set_up()
	bird.alive = false
	bird.get_node("Sprite").play("flop")

func _physics_process(delta: float) -> void:
	move_bird()

func move_bird():
	bird.move()
	if bird.position.y > bird_starting_position.y:
		bird.jump()


func _on_start_button_up() -> void:
	get_parent().change_scene("game")


func _on_exit_button_up() -> void:
	get_tree().quit()

func set_up():
	$UI/ground.position.y = get_parent().window_height - 40
	bird.position.y = get_parent().window_height/2
	bird.position.x = get_parent().window_width/8
	bird_starting_position = bird.position
