extends Node

@onready var pipes_scene = preload("res://entities/pipes.tscn")
var pipes_array = []

@onready var bird = $Bird

var score = 0

var paused = true

func _ready() -> void:
	get_tree().get_root().size_changed.connect(set_up)
	set_up()
	bird.has_died.connect(pause)
	bird.point_collected.connect(add_point)

func _physics_process(_delta: float) -> void:
	$UI/press_to_start.visible = true if paused and bird.alive else false
	if paused and Input.is_action_just_released("jump"):
		if bird.alive == false:
			get_parent().change_scene("game")
		paused = false
		bird.get_node("Sprite").play("flop")
		$UI/ground.material.set_shader_parameter("paused",false)
		return
	if paused: return
	bird.move()
	if len(pipes_array) == 0:
		spawn_pipes()
	if $pipes_spawn.position.x - pipes_array[len(pipes_array)-1].position.x >= 400:
		spawn_pipes()
	for pipes in pipes_array:
		if pipes.position.x <= -200:
			pipes_array.erase(pipes)
			pipes.queue_free()
			continue
		pipes.move()


func spawn_pipes():
	var pipes = pipes_scene.instantiate()
	pipes.position = $pipes_spawn.position
	randomize()
	pipes.position.y += randi_range(-get_parent().window_height/5,get_parent().window_height/5)
	pipes_array.append(pipes)
	add_child(pipes)

func pause():
	paused = true
	$UI/ground.material.set_shader_parameter("paused",true)
	bird.get_node("Sprite").pause()
	$UI/final_screen/container/score.text = "Score\n" + String.num_int64(score)
	if score > Highscore.highscore:
		Highscore.highscore = score
		$UI/final_screen/container/best_score.text = "Highscore\n" + String.num_int64(score)
	else:
		$UI/final_screen/container/best_score.text = "Highscore\n" + String.num_int64(Highscore.highscore)
	$UI/final_screen.visible = true
	$UI/score.visible = false

func add_point():
	score += 1
	$UI/score.text = String.num_int64(score)


func _on_button_button_down() -> void:
	get_parent().change_scene("menu")

func set_up():
	bird.position.y = get_parent().window_height/2
	$UI/ground.position.y = get_parent().window_height - 40
	$pipes_spawn.position.y = get_parent().window_height/2
	$pipes_spawn.position.x = get_parent().window_width + 40
