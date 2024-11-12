class_name Player
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var ui: Control = $CanvasLayer/GameUi
@onready var camera: Camera2D = $Camera2D
@onready var lose_message: RichTextLabel = $CanvasLayer/RichTextLabel

@export_category("movment")
@export var acceleration := 100
@export var decceleration := 100
@export var speed = 400.0
@export var jump_velocity = -650.0
@export var gravity := Vector2(0, 980)
@export var max_fall_speed := 1000
@export var jump_buffer_time := 0.2

@export var wall_climb := false
var max_health := 100.0

var can_control: bool = true 

var jump_buffer_counter := 0.0

var health := 100.0:
	set(val):
		health = clamp(val, 0, 100)
		ui.set_health(val)

func _ready() -> void:
	health = max_health

func _physics_process(delta: float) -> void:
	if not can_control:return
	
	if jump_buffer_counter > 0:
		jump_buffer_counter -= delta

	if not is_on_floor():
		velocity += gravity * delta
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed

	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = jump_buffer_time

	if jump_buffer_counter > 0 and velocity.y >= 0:
		if is_on_floor() or !coyote_timer.is_stopped() or is_on_wall() and wall_climb:
			velocity.y += jump_velocity
			jump_buffer_counter = 0
			sprite.play("Jump")

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		if sprite.animation == "Idle":
			sprite.play("Run")
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, decceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		if velocity.x == 0 and sprite.animation == "Run":
			sprite.play("Idle")
	if velocity.x > 0 and sprite.flip_h:
		sprite.flip_h = false
	elif velocity.x < 0 and !sprite.flip_h:
		sprite.flip_h = true


	var was_on_floor = is_on_floor()

	move_and_slide()

	if is_on_floor() != was_on_floor:
		coyote_timer.start()

func _on_animated_sprite_2d_animation_finished() -> void:
	if velocity.x != 0:
		sprite.play("Run")
	else:
		sprite.play("Idle")

func reset_player() -> void:
	var level = get_parent()
	global_position = level.level_start_pos.position
	can_control= true
	visible = true
	health = max_health
	lose_message.hide()

func take_damage(dmg: float):
	health -= dmg
	sprite.play("Hurt")
	if health <= 0:
		print("player is dead")
		visible = false
		can_control = false
		
		var tween = create_tween()
		tween.tween_property(camera, "global_position", get_parent().level_start_pos.position, 2.5).set_ease(Tween.EASE_OUT)
		lose_message.show()
		
		await get_tree().create_timer(3).timeout
		reset_player()
