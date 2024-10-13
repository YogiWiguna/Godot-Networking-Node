extends CharacterBody3D

@onready var camera = $Camera3D
@onready var multiplayer_synchronizer = $MultiplayerSynchronizer

const speed = 5.0
var mouse_sensitivity = 0.5
const JUMP_VELOCITY = 4.5

func _ready():
	add_to_group("player_characters")
	multiplayer_synchronizer.set_multiplayer_authority(str(name).to_int())
	camera.current = multiplayer_synchronizer.is_multiplayer_authority()

func _physics_process(delta):
	if multiplayer_synchronizer.is_multiplayer_authority():
		var direction = Vector3.ZERO
		if Input.is_key_pressed(KEY_W): direction -= global_transform.basis.z
		elif Input.is_key_pressed(KEY_S): direction += global_transform.basis.z
		if Input.is_key_pressed(KEY_A): direction -= global_transform.basis.x
		elif Input.is_key_pressed(KEY_D): direction += global_transform.basis.x
		
		global_position += direction.normalized() * speed * delta
		multiplayer_synchronizer.position = global_position


func _input(event):
	if multiplayer_synchronizer.is_multiplayer_authority():
		if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
		if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-deg_to_rad(event.relative.x) * mouse_sensitivity)
			multiplayer_synchronizer.y_rotation = rotation.y
			camera.rotate_x(-deg_to_rad(event.relative.y) * mouse_sensitivity)
