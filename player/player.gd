extends CharacterBody2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

@export var acceleration = 600
@export var friction = 1500
@export var max_speed = 100

var direction = Vector2.ZERO
var speed = 50

var last_direction = 0


func _process(delta):
	var angle_to_mouse = global_position.angle_to_point(get_global_mouse_position())
	if abs(angle_to_mouse) < PI / 2:
		sprite.flip_h = false
	else:
		sprite.flip_h = true


func _physics_process(delta):
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction = direction.normalized()
	
	if direction.x != 0:
		last_direction = direction.x
	
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
		animation_player.play("player/run")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		animation_player.play("player/idle")
	
	move_and_slide();


func _play_footstep():
	FootstepSoundManager.play_footstep(global_position)
