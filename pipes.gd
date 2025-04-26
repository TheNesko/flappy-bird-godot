extends CharacterBody2D

const speed = 300

func move():
	velocity.x = -speed
	move_and_slide()
