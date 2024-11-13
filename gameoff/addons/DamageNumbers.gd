extends Node

func display_number(value: float, position: Vector2, size: float, crit: bool = false):
	var number = Label.new()
	number.global_position = position
	number.text = str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	var size_mult := 12
	var color = "#FFF"
	if value == 0:
		color = "FFF8"
	if crit:
		color = "FF0000"
		size_mult = 18
	number.label_settings.font_color = color
	number.label_settings.font_size = size_mult * size
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1
	call_deferred("add_child", number)
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y - 24, 0.25
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_OUT).set_delay(0.5)
	await tween.finished
	number.queue_free()

func display_label(text: String, position, size := 2):
	var label = Label.new()
	label.global_position = position
	label.text = text
	label.z_index = 5
	label.label_settings = LabelSettings.new()
	var size_mult := 12
	var color = "#FFF"
	label.label_settings.font_color = color
	label.label_settings.font_size = size_mult * size
	label.label_settings.outline_color = "#000"
	label.label_settings.outline_size = 1
	call_deferred("add_child", label)
	await label.resized
	label.pivot_offset = Vector2(label.size / 2)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		label, "position", label.position - Vector2(200, 40), 2.5
	).set_ease(Tween.EASE_OUT)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(
		label, "modulate:a", 0.5, 2.5
	).set_ease(Tween.EASE_OUT)
	#tween.tween_property(
		#label, "position:y", label.position.y, 0.5
	#).set_ease(Tween.EASE_IN).set_delay(0.25)
	#tween.tween_property(
		#label, "scale", Vector2.ZERO, 0.25
	#).set_ease(Tween.EASE_OUT).set_delay(0.5)
	await tween.finished
	label.queue_free()
