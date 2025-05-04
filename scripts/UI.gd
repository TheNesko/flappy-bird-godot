extends CanvasLayer

var playing = false

@onready var start_text = %press_to_start
@onready var game_manager = %GameManager

func _ready() -> void:
	animate_start_text(1)
	game_manager.game_started.connect(start_game)
	game_manager.player_died.connect(pause)
	game_manager.add_score.connect(add_score)
	$Menu_UI.visible = true
	$Game_UI.visible = false

func _physics_process(delta: float) -> void:
	if not playing: return
	$background/ParallaxBackground/ParallaxLayer.motion_offset.x -= 1

func start_game():
	playing = true
	$background/ground.material.set_shader_parameter("paused",false)
	$Menu_UI.visible = false
	$Game_UI.visible = true
	$Game_UI/score.visible = true
	$Game_UI/final_screen.visible = false

func pause(score):
	playing = false
	$background/ground.material.set_shader_parameter("paused",true)
	$Game_UI/final_screen/container/score.text = "Score\n" + String.num_int64(score)
	if score > Highscore.highscore:
		Highscore.highscore = score
		$Game_UI/final_screen/container/best_score.text = "Highscore\n" + String.num_int64(score)
	else:
		$Game_UI/final_screen/container/best_score.text = "Highscore\n" + String.num_int64(Highscore.highscore)
	$Game_UI/final_screen.visible = true
	$Game_UI/score.visible = false

func add_score(score):
	$Game_UI/score.text = String.num_int64(score)


func animate_start_text(time:float):
	start_text.visible_characters = 0
	var total_characters = start_text.get_total_character_count()
	var tween = get_tree().create_tween()
	tween.tween_property(start_text,"visible_characters",total_characters,time)
	tween.play()
	var audio = $Menu_UI/AudioStreamPlayer2D
	for x in total_characters/2:
		audio.pitch_scale = 0.6 + x/total_characters
		audio.play()
		await get_tree().create_timer(time/total_characters*2).timeout
