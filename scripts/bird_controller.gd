extends CharacterBody2D

const JUMP_POWER : int = 600
const GRAVITY : int = 40
const JUMP_ROTATION = deg_to_rad(-30)
const ROTATION_SPEED = deg_to_rad(3)

var alive = true
signal has_died
signal point_collected

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump") and alive:
		jump()

func jump():
	velocity.y = -JUMP_POWER
	$Sprite.rotation = JUMP_ROTATION

func move():
	velocity.y += GRAVITY
	move_and_slide()
	if velocity.y >= 0:
		$Sprite.rotation += ROTATION_SPEED
		if $Sprite.rotation_degrees >= 90: $Sprite.rotation_degrees = 90
	if not alive:
		return
	if position.y <= 0 or position.y >= get_parent().find_child("ground").position.y:
		alive = false
		velocity.y = 0
		has_died.emit()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if not alive: return
	alive = false
	velocity.y = 0
	has_died.emit()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if not alive: return
	point_collected.emit()
