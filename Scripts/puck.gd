extends RigidBody2D

var mouse_over : bool = false
var drag_success : bool = false

func _process(delta: float) -> void:
	if drag_success:
		position.x = get_global_mouse_position().x
		position.y = get_global_mouse_position().y

func drag():
	if mouse_over:
		drag_success = true
	
func release():
	drag_success = false

func _on_mouse_entered() -> void:
	mouse_over = true

func _on_mouse_exited() -> void:
	mouse_over = false
	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("drag"):
			drag()
			
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_released("drag"):
			release()
