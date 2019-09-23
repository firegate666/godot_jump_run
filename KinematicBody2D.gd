extends KinematicBody2D

const GRAVITY = 20
const ACCELERATION = 25
const MAX_MOVE_SPEED = 200
const JUMP_SPEED = 550
const UP = Vector2(0, -1)
const FRICTION_GROUND = 0.2
const FRICTION_AIR = 0.05
var motion = Vector2()

func min_max(value, lower, upper):
	value = min(value, upper)
	return max (value, lower)

func _physics_process(delta):

	motion.y += GRAVITY
	var friction = false

	if Input.is_action_pressed("ui_right"):
		motion.x += ACCELERATION
		$Sprite.flip_h = false
		$Sprite.play("Run")
	elif Input.is_action_pressed("ui_left"):
		motion.x -= ACCELERATION
		$Sprite.flip_h = true
		$Sprite.play("Run")
	else:
		friction = true
		$Sprite.animation = "Idle"

	motion.x = min_max(motion.x, -MAX_MOVE_SPEED, MAX_MOVE_SPEED)

	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_SPEED
			$Sprite.animation = "Jump"
		if friction:
			motion.x = lerp(motion.x, 0, FRICTION_GROUND)
	else:
		if friction:
			motion.x = lerp(motion.x, 0, FRICTION_AIR)
		if motion.y > 60:
			$Sprite.animation = "Fall"
		elif motion.y >= -60 and motion.y <= 60:
			$Sprite.animation = "JumpIdle"
		else:
			$Sprite.animation = "Jump"

	# build in update motion after collide
	motion = move_and_slide(motion, UP)
	pass
