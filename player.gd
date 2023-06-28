extends CharacterBody3D

var direction = (transform.basis * Vector3(0, 0, 0))
var input_dir = Input.get_vector("left", "right", "ui_up", "ui_down")
var impulseForce = Vector3.ZERO
@onready var di = $dialoguebox
const ogspeed = 8
var speed = 8
const jumpPower = 9
const jump2power = 10
var walljump = false

var idle = false
var running = false
var jumping = false
var inair = false
# grav  reference
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var jumps = 2

func jump():
	velocity.y = jumpPower
	jumps -= 1
	speed = ogspeed * 0.75
func textset(name, text):
	$dialoguebox/box/Name.text = name
	$dialoguebox/box/Chat.text = text
	$dialoguebox.visible = true
func _physics_process(delta):
	if Input.is_anything_pressed():
		$dialoguebox.visible = false
#anim detects
	if is_on_floor(): 
		jumping = false
		inair = false
		walljump = true
	if Input.is_action_just_pressed("jump"):
		jumping = true
	elif not is_on_floor() && Input.is_action_just_pressed("jump"):
		jumping = true
	if is_on_wall():
		jumping = false
	if not is_on_floor():
		inair = true
	if is_on_floor() and not Input.is_anything_pressed():
		idle = true
		running = false
	elif Input.is_anything_pressed():
		idle = false
	if direction:
		running = true

	#print("idle: ", idle, " | running: ", running, " | jumping: ", jumping, " | inair: ", inair, " | walljump: ", walljump, " | direction: ", direction)
# anim plays

	if idle:
		$Sprite3D/AnimationPlayer.play("idle")
	if inair:
		$Sprite3D/AnimationPlayer.play("midair")
	elif running:
		$Sprite3D/AnimationPlayer.play("run")
	if Input.is_action_just_pressed("jump"):
		$Sprite3D/AnimationPlayer.play("hop")
	if direction.x == -1:
		$Sprite3D.transform.origin.x *= -1

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if not is_on_floor() && not is_on_wall():
		velocity.y -= gravity * delta 
	if velocity.y < 2 or not Input.is_action_pressed("jump"):
		velocity.y -= gravity * delta * 2

	if is_on_wall():
		if velocity.y > 0:
			velocity.y -= (gravity * delta) * 2
		if velocity.y < 0: 
			velocity.y = (gravity * delta) * -3 

	if is_on_floor(): 
		jumps = 2
		walljump = true
	if inair && not is_on_wall():
		walljump = true

	# jump garbage
	if Input.is_action_just_pressed("jump"):
		if jumps > 0: 
			jump()
		elif is_on_wall() && walljump == true:
			jump()
			walljump = false


	$".".global_transform.origin.z = 0
	if !transform.origin.z == 0:
		$".".global_transform.origin.z = 0
		
	input_dir = Input.get_vector("left", "right", "ui_up", "ui_down")
	direction = (transform.basis * Vector3(input_dir.x, 0, 0))
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
			col.get_collider().apply_central_impulse(-col.get_normal() * 3.5)


func _on_textbox_textvals(nametext, text):
	textset(nametext, text)
