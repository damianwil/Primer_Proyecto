extends CharacterBody2D

var SPEED:int = 150
var SPEED_FOLLOW:int = 250
var FOLLOW:bool = false
var gravity : int = 700

func _ready():
	$AnimatedSprite2D.play("run")
	velocity.x = -SPEED
		
func _physics_process(delta):
	velocity.y += gravity*delta
	detectar()
	if !FOLLOW:
		if is_on_wall():
			if !$AnimatedSprite2D.flip_h:
				velocity.x = SPEED
			else:
				velocity.x = -SPEED
		if  velocity.x < 0:
			$AnimatedSprite2D.flip_h = false
			$CollisionShape2D.position.x = 108
		elif velocity.x > 0:
			$AnimatedSprite2D.flip_h = true
			$CollisionShape2D.position.x = 90
	move_and_slide()
func detectar():
	if $Right.is_colliding():
		$CollisionShape2D.position.x = 90
		var obj = $Right.get_collider()
		if obj.is_in_group("Player"):
			FOLLOW = true
			velocity.x = SPEED_FOLLOW
			$AnimatedSprite2D.flip_h = true
		else:
			FOLLOW = false

	if $Left.is_colliding():
		var obj = $Left.get_collider()
		$CollisionShape2D.position.x = 108
		if obj.is_in_group("Player"):
			FOLLOW = true
			velocity.x = -SPEED_FOLLOW
			$AnimatedSprite2D.flip_h = false
		else:
			FOLLOW = false
			
			
func dead():
	$death.play()
	set_physics_process(false)
	$AnimatedSprite2D.play("dead")
	await ($AnimatedSprite2D.animation_finished)
	await ($death.finished)
	queue_free()
