extends Node

@onready var window_height = ProjectSettings.get_setting("display/window/size/viewport_height")

@onready var pipes_scene = preload("res://entities/pipes.tscn")
var pipes_array = []

@onready var bird_scene = preload("res://entities/bird.tscn")
@onready var bird = null

var score = 0

var paused = true

func _ready() -> void:
	# set ground
	$ground.position.y = window_height - 40
	# spawn bird
	spawn_bird()
	bird.has_died.connect(pause)
	bird.point_collected.connect(add_point)

func _physics_process(_delta: float) -> void:
	$press_to_start.visible = true if paused and bird.alive else false
	if paused and Input.is_action_just_released("jump"):
		if bird.alive == false:
			get_parent().change_scene("game")
		paused = false
		bird.get_node("Sprite").play("flop")
		$ground.material.set_shader_parameter("paused",false)
		return
	if paused: return
	bird.move()
	if len(pipes_array) == 0:
		spawn_pipes()
	if $pipes_spawn.position.x - pipes_array[len(pipes_array)-1].position.x >= 400:
		spawn_pipes()
	for pipes in pipes_array:
		pipes.move()

func spawn_bird():
	bird = bird_scene.instantiate()
	bird.position = $bird_spawn.position
	add_child(bird)

func spawn_pipes():
	var pipes = pipes_scene.instantiate()
	pipes.position = $pipes_spawn.position
	randomize()
	pipes.position.y += randi_range(-window_height/5,window_height/5)
	pipes_array.append(pipes)
	add_child(pipes)

func pause():
	paused = true
	$ground.material.set_shader_parameter("paused",true)
	bird.get_node("Sprite").pause()
	$final_screen/container/score.text = "Score\n" + String.num_int64(score)
	if score > Highscore.highscore:
		Highscore.highscore = score
		$final_screen/container/best_score.text = "Highscore\n" + String.num_int64(score)
	else:
		$final_screen/container/best_score.text = "Highscore\n" + String.num_int64(Highscore.highscore)
	$final_screen.visible = true
	$score.visible = false

func add_point():
	score += 1
	$score.text = String.num_int64(score)


func _on_button_button_down() -> void:
	get_parent().change_scene("menu")
