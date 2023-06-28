extends Sprite3D


var lastdirection = "right"

func _process(delta):
	
	if Input.is_action_pressed("left"):
		rotation_degrees = Vector3(0, -15, 0)
		lastdirection = "left"
	if Input.is_action_pressed("right"):
		rotation_degrees = Vector3(0, 15, 0)
		lastdirection = "right"

	if not Input.is_action_pressed("left") && not Input.is_action_pressed("right"):
		rotation_degrees = Vector3(0, 0, 0)


	if  $"..".is_on_floor():
		rotation_degrees.x = 0
	if not $"..".is_on_floor():
		rotation_degrees.x = -15

	if lastdirection == "left":
		$".".scale = Vector3(-1.2, 1.2, 1.2)
	if lastdirection == "right":
		$".".scale = Vector3(1.2, 1.2, 1.2)
