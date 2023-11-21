extends CharacterBody2D

var SPEED : int = 250
var JUMP : int = 330
var gravity : int = 700
var attack:bool = false
@onready var sprite2d = $anim

var cont_jump:int=0
var max_jump:int=2
var hitplayer = false

func _ready():
	hit()
	$Area2D/CollisionShape2D.disabled = true

func _physics_process(delta):
	velocity.y += gravity*delta
	if !hitplayer:
		if Input.is_action_pressed("right"):
			$CollisionShape2D.position.x = -40.5
			$Area2D.position.x = 96
			velocity.x = SPEED
			sprite2d.flip_h = false
		elif Input.is_action_pressed("left"):
			$CollisionShape2D.position.x = -13
			$Area2D.position.x = -2
			velocity.x = -SPEED
			sprite2d.flip_h = true
		else:
			velocity.x = 0
			
		if is_on_floor():
			cont_jump= 0
			if Input.is_action_just_pressed("jump"):
				cont_jump+=1
				velocity.y = -JUMP
				
		else:
			if Input.is_action_just_pressed("jump") and max_jump > cont_jump:
				cont_jump+=1
				velocity.y = -JUMP
				
			if Input.is_action_just_released("jump"):
				velocity.y += 1800*delta
			
		move_and_slide()
		
		
		animaciones()
	
	
func _input(event):
	if Input.is_action_just_pressed("attack") and !hitplayer:
		set_physics_process(false)
		sprite2d.play("attack")
		$Area2D/CollisionShape2D.disabled = false
		await sprite2d.animation_finished
		$Area2D/CollisionShape2D.disabled = true
		set_physics_process(true)


func animaciones():
	if is_on_floor():
		if velocity.x !=0:
			sprite2d.play("run")
		else:
			sprite2d.play("idle")
			
	else:
		if velocity.y <0:
			sprite2d.play("jump")
		else:
			sprite2d.play("fall")

func hit():
	hitplayer = true
	velocity = Vector2.ZERO
	
	if !sprite2d.flip_h:
		velocity = Vector2(-100,-200)
		
	else:
		velocity = Vector2(100,-200)
	
	sprite2d.play("hit")
	await sprite2d.animation_finished
	velocity = Vector2.ZERO
	hitplayer = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		body.dead()
