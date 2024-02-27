extends KinematicBody2D


export (int) var speed = 400
export (int) var GRAVITY = 1200
export (int) var jump_speed = -600

const UP = Vector2(0,-1)

var velocity = Vector2()
var double_jump = true
var dashing = false
var double_tap_right = false
var double_tap_left = false

func get_input():
	velocity.x = 0
	if is_on_floor() and Input.is_action_just_pressed('up'):
		$AnimatedSprite.play("Jump")
		velocity.y = jump_speed
		double_jump = true
	if !is_on_floor() and Input.is_action_just_pressed('up') and double_jump == true:
		$AnimatedSprite.play("Jump")
		velocity.y = jump_speed
		double_jump = false
		
	if Input.is_action_pressed('right'):
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("Walk")
		velocity.x += speed
	
	if Input.is_action_pressed('left'):
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("Walk")
		velocity.x -= speed
		
	if Input.is_action_pressed("crouch"):
		$AnimatedSprite.play("Crouch")
		speed = 50
		jump_speed = 0
	else:
		$AnimatedSprite.stop()
		speed = 400
		jump_speed = -600
	

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	get_input()
	velocity = move_and_slide(velocity, UP)

func _process(delta):
	if Input.is_action_just_pressed('left'):
		if double_tap_left == true:
			dashing = true
			
	if Input.is_action_just_pressed('right'):
		if double_tap_right == true:
			dashing = true
			
	if Input.is_action_just_released('left'):
		$AnimatedSprite.stop()
		if dashing == true:
			dashing = false
		double_tap_left = true
		$Timer.start()
		
	if Input.is_action_just_released('right'):
		$AnimatedSprite.stop()
		if dashing == true:
			dashing = false
		double_tap_right = true
		$Timer.start()
	
	if dashing == true:
		speed = 1000
	elif dashing == false:
		speed = 400
	

func _on_Timer_timeout():
	double_tap_right = false
	double_tap_left = false
	
