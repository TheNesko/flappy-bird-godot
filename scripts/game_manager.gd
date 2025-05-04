class_name GameManager
extends Node

enum STATE {
	Menu,
	Playing,
	Died
}

signal game_started
signal player_died(score)
signal add_score(score)

var bird_starting_position = Vector2.ZERO
var score = 0
var current_state = STATE.Menu

@onready var pipes_scene = preload("res://entities/pipes.tscn")
@onready var bird : Bird = $Bird
@onready var window_height = get_window().size.y
@onready var window_width = get_window().size.x


func _ready() -> void:
	get_tree().get_root().size_changed.connect(window_resized)
	get_tree().get_root().size_changed.connect(set_up)
	set_up()
	bird.get_node("Sprite").play("flop")
	bird.has_died.connect(pause)
	bird.point_collected.connect(add_point)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		if current_state == STATE.Menu:
			# START GAME
			current_state = STATE.Playing
			game_started.emit()
		if current_state == STATE.Playing:
			bird.jump()
		elif current_state == STATE.Died:
			# RESTART GAME
			reset()
			game_started.emit()
			current_state = STATE.Playing
		

func _physics_process(delta: float) -> void:
	match current_state:
		STATE.Menu:
			move_bird()
		STATE.Playing:
			process()
		STATE.Died:
			pass

func move_bird() -> void:
	bird.move()
	if bird.position.y > bird_starting_position.y:
		bird.jump()

func exit_game() -> void:
	get_tree().quit()

func set_up() -> void:
	#$UI/ground.position.y = get_parent().window_height - 40
	bird.position.y = window_height/2
	bird.position.x = window_width/8
	bird_starting_position = bird.position

func window_resized() -> void:
	window_height = get_window().size.y
	window_width = get_window().size.x

func process() -> void:
	bird.get_node("Sprite").play("flop")
	bird.move()
	var pipes = get_tree().get_nodes_in_group("Pipes")
	if len(pipes) == 0:
		spawn_pipes()
	elif $pipes_spawn.position.x - pipes[len(pipes)-1].position.x >= 400:
		spawn_pipes()
	for pipe in get_tree().get_nodes_in_group("Pipes"):
		if pipe.position.x <= -200:
			pipe.queue_free()
			continue
		pipe.move()


func spawn_pipes():
	var pipes = pipes_scene.instantiate()
	pipes.position = $pipes_spawn.position
	randomize()
	pipes.position.y += randi_range(-window_height/5,window_height/5)
	add_child(pipes)

func pause():
	current_state = STATE.Died
	player_died.emit(score)
	bird.get_node("Sprite").pause()

func add_point():
	score += 1
	add_score.emit(score)

func reset():
	for pipe in get_tree().get_nodes_in_group("Pipes"):
		pipe.queue_free()
	bird.position = bird_starting_position
	score = 0
	add_score.emit(score)
