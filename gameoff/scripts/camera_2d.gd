extends Camera2D

@export var shake_fade : float = 3.0

var rng = RandomNumberGenerator.new()
var shake_strength = 0

func _ready():
	Global.screen_shake.connect(apply_shake)

func apply_shake(strength):
	if Global.screenshake:
		shake_strength = strength

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		offset = random_offset()

func random_offset() -> Vector2:
	return(Vector2(rng.randf_range(-shake_strength, shake_strength) , rng.randf_range(-shake_strength, shake_strength)))
