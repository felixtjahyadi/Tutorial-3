extends KinematicBody2D

var speed = 50
var velocity = Vector2()
var direction = 1

func _ready():
	$AnimatedSprite.play("walk")

	
func _physics_process(delta):
	
	if is_on_wall():
		direction = direction*-1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
	
	velocity.y += 20
	
	velocity.x = speed * direction
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_TopCheck_body_entered(body):
	$SoundBounce.play()
	speed = 0
	body.bounce()


func _on_TopCheck_body_exited(body):
	$AnimatedSprite.play("walk")
	speed = 50


func _on_SideCheck_body_entered(body):
	get_tree().change_scene("res://scenes/Main.tscn")
