class_name Bird
extends CharacterBody2D

const JUMP_POWER : int = 600
const GRAVITY : int = 40
const JUMP_ROTATION = deg_to_rad(-30)
const ROTATION_SPEED = deg_to_rad(3)

signal has_died
signal point_collected

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		jump()

func jump():
	velocity.y = -JUMP_POWER
	$Sprite.rotation = JUMP_ROTATION
	$jump_audio.play()

func move():
	velocity.y += GRAVITY
	move_and_slide()
	if velocity.y >= 0:
		$Sprite.rotation += ROTATION_SPEED
		if $Sprite.rotation_degrees >= 90: $Sprite.rotation_degrees = 90
	if position.y <= 0 or position.y >= get_window().size.y-40:
		velocity.y = 0
		$hit_audio.play()
		has_died.emit()


func _on_hitbox_body_entered(body: Node2D) -> void:
	velocity.y = 0
	has_died.emit()
	$hit_audio.play()


func _on_hitbox_area_entered(area: Area2D) -> void:
	point_collected.emit()
