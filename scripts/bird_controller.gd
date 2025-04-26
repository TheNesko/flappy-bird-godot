extends CharacterBody2D

const JUMP_POWER : int = 600
const GRAVITY : int = 40
#const MAX_SPEED : int = 2000
const JUMP_ROTATION = deg_to_rad(-30)
const ROTATION_SPEED = deg_to_rad(3)

var alive = true
signal has_died
signal point_collected

func move():
	velocity.y += GRAVITY
	if Input.is_action_just_pressed("jump") and alive:
		velocity.y = -JUMP_POWER
		$Sprite.rotation = JUMP_ROTATION
	#velocity.y = clamp(velocity.y,-MAX_SPEED,MAX_SPEED)
	move_and_slide()
	if velocity.y >= 0:
		$Sprite.rotation += ROTATION_SPEED
		if $Sprite.rotation_degrees >= 90: $Sprite.rotation_degrees = 90
	if not alive:
		return
	if position.y <= 0 or position.y >= get_parent().get_node("ground").position.y:
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
