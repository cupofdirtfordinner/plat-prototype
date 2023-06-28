extends CharacterBody3D

var direction = (transform.basis * Vector3(0, 0, 0))
var input_dir = Input.get_vector("left", "right", "ui_up", "ui_down")

const ogspeed = 8
var speed = 8
const jumpPower = 15
const jump2power = 18
var walljump = true

var idle = false
var running = false
var jumping = false

# grav  reference
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var jumps = 2

func _physics_process(delta):

#anim detects
	if is_on_floor(): 
		jumping = false
	if Input.is_action_just_pressed("jump"):
		jumping = true
	elif not is_on_floor() && Input.is_action_just_pressed("jump"):
		jumping = true

	if is_on_floor() and not Input.is_anything_pressed():
		idle = true
		running = false
	elif Input.is_anything_pressed():
		idle = false
		running = true

# anim plays
	if running == true:
		$Sprite3D/AnimationPlayer.play("run")
	if idle == true:
		$Sprite3D/AnimationPlayer.play("idle")

	if direction.x == -1:
		$Sprite3D.transform.origin.x *= -1

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if not is_on_floor() && not is_on_wall():
		velocity.y -= gravity * delta 
	if velocity.y < 4 or not Input.is_action_pressed("jump"):
		velocity.y -= gravity * delta * 1

	if is_on_wall():
		if velocity.y > 0:
			velocity.y -= (gravity * delta) * 2
		if velocity.y < 0: 
			velocity.y = (gravity * delta) * -3 

	if is_on_floor(): 
		jumps = 2

	# jump garbage
	if Input.is_action_just_pressed("jump"):
		if jumps == 2: 
			velocity.y = jumpPower
			jumps -= 1
			speed = ogspeed * 0.75
			#transform.basis.apply_impulse(Vector3(0,0,0))
		elif jumps == 1: 
			velocity.y = jump2power
			velocity.x *= jump2power
			jumps -= 1
			speed = ogspeed * 0.55

	$".".global_transform.origin.z = 0
	if !transform.origin.z == 0:
		$".".global_transform.origin.z = 0
		
	input_dir = Input.get_vector("left", "right", "ui_up", "ui_down")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	for col_idx in get_slide_collision_count():
		var col := get_slide_collision(col_idx)
		if col.get_collider() is RigidBody3D:
			col.get_collider().apply_central_impulse(-col.get_normal() * 2.5)
			col.get_collider().apply_impulse(-col.get_normal() * 0, col.get_position())
