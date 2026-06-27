extends RigidBody2D

@export var canvas_item : CanvasItem

var mouse_over : bool = false
var drag_success : bool = false

var impulse_dir : Vector2 = Vector2.ZERO
var impulse_force : float = 0

func cursor_position():
	"""Rename 'cause the method name is way too stupidly long"""
	return get_global_mouse_position()

func calculate_impulse_force():
	return position.distance_to(cursor_position())

func calculate_impulse_direction():
	return -position.direction_to(cursor_position())

func throw(dir : Vector2, force : float) -> void:
	self.apply_central_impulse(dir * force)

func drag():
	if mouse_over:
		drag_success = true
	
func release():
	drag_success = false
	throw(calculate_impulse_direction(), calculate_impulse_force())

func _process(delta: float) -> void:
	if drag_success:
		queue_redraw()

func _on_mouse_entered() -> void:
	mouse_over = true
	canvas_item.self_modulate = Color.WHITE

func _on_mouse_exited() -> void:
	mouse_over = false
	canvas_item.self_modulate = Color.WHITE_SMOKE
	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("drag"):
			drag()
			
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_released("drag"):
			release()

func _draw() -> void:
	if drag_success:
		draw_line(position, cursor_position(), Color.BLUE, 1)
