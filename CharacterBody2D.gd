extends CharacterBody2D

var SPEED : int = 250
var JUMP : int = 330
var gravity : int = 700
var attack:bool = false
@onready var sprite2d = $anim

var cont_jump:int=0
var max_jump:int=2

func _ready():
	$Area2D/CollisionShape2D.disabled = true

func _physics_process(delta):
	velocity.y += gravity*delta
	if !attack:
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
				
		if Input.is_action_just_pressed("attack") and is_on_floor():
			attack = true
		move_and_slide()
	else:
		sprite2d.play("attack")
		$Area2D/CollisionShape2D.disabled = false
		await (sprite2d.animation_finished)
		$Area2D/CollisionShape2D.disabled = true
		attack = false
	animaciones()
	
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


func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		body.dead()
	
