extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer

@export var speed = 400.0:
	set(val):
		speed = val
		print(val)
var JUMP_VELOCITY = -650.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or !coyote_timer.is_stopped():
			velocity.y = JUMP_VELOCITY
			sprite.play("Jump")

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
		if sprite.animation == "Idle":
			sprite.play("Run")
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
