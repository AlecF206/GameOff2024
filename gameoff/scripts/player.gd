class_name Player
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var ui: Control = $CanvasLayer/GameUi
@onready var camera: Camera2D = $Camera2D
@onready var lose_message: RichTextLabel = $CanvasLayer/RichTextLabel
@onready var trail_particles: CPUParticles2D = $CPUParticles2D

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

	if is_on_floor() and velocity != Vector2(0,0):
		trail_particles.emitting = true
		if velocity.x > 0:
			trail_particles.direction.x = -1
		if velocity.x < 0:
			trail_particles.direction.x = 1
	else:
		trail_particles.emitting = false

	if not is_on_floor():
		velocity += gravity * delta
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed

	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = jump_buffer_time

	if jump_buffer_counter > 0 and velocity.y >= 0:
		if is_on_floor() or !coyote_timer.is_stopped() or is_on_wall() and wall_climb:
			velocity.y += jump_velocity
			$Jump.play()
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
	global_position = level.level_start_pos.global_position
	camera.global_position = global_position
	can_control= true
	visible = true
	health = max_health
	lose_message.hide()

func take_damage(dmg: float):
	health -= dmg
	Global.screen_shake.emit(25)
	sprite.play("Hurt")
	LabelSpawns.display_number(dmg, global_position, 2)
	$AudioStreamPlayer2D.play()
	if health <= 0:
		visible = false
		can_control = false
		velocity *= 0
		
		var tween = create_tween()
		tween.tween_property(camera, "global_position", get_parent().level_start_pos.global_position, 2.5).set_ease(Tween.EASE_OUT)
		lose_message.show()
		
		await get_tree().create_timer(3).timeout
		reset_player()
