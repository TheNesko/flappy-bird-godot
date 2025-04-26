extends Node

@onready var window_height = get_window().size.y
@onready var window_width = get_window().size.x

var scenes = {
	"menu": preload("res://scenes/main_menu_scene.tscn"),
	"game": preload("res://scenes/game_scene.tscn")
}


func _ready() -> void:
	get_tree().get_root().size_changed.connect(window_resized)
	change_scene("menu")


func change_scene(scene_name: String):
	var scene = scenes[scene_name].instantiate()
	if get_children() == []:
		add_child(scene)
		return
	get_child(0).queue_free()
	add_child(scene)
	get_tree().paused = true
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false

func window_resized():
	window_height = get_window().size.y
	window_width = get_window().size.x
	print(window_width,"  ",window_height)
	
