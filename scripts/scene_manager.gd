extends Node

var scenes = {
	"menu": preload("res://scenes/main_menu_scene.tscn"),
	"game": preload("res://scenes/game_scene.tscn")
}


func _ready() -> void:
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
