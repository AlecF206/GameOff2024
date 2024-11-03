extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var ui: Control = $CanvasLayer/GameUi

@export_category("movment")
@export var acceleration := 100
@export var decceleration := 100
@export var speed = 400.0
@export var jump_velocity = -650.0
@export var gravity := Vector2(0, 980)
@export var max_fall_speed := 1000
@export var jump_buffer_time := 0.2

var max_health := 100.0

var jump_buffer_counter := 0.0

var health := 100.0:
	set(val):
		health = val
		ui.set_health(val)
		print(health)

func _ready() -> void:
	health = max_health

func _physics_process(delta: float) -> void:
	if jump_buffer_counter > 0:
		jump_buffer_counter -= delta

	if not is_on_floor():
		velocity += gravity * delta
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed

	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = jump_buffer_time

	if jump_buffer_counter > 0:
		if is_on_floor() or !coyote_timer.is_stopped():
			velocity.y = jump_velocity
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

func take_damage(dmg: float):
	health -= dmg
	sprite.play("Hurt")
