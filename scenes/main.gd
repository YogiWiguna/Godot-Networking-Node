extends Node3D

@onready var menu = $Menu
@onready var port = $Menu/VBoxContainer/port
@onready var join_button = $Menu/VBoxContainer/join_button
@onready var host_button = $Menu/VBoxContainer/host_button

const PLAYER = preload("res://scenes/player.tscn")
var multiplayer_peer = ENetMultiplayerPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	join_button.connect("pressed", _on_join_button_pressed)
	host_button.connect("pressed", _on_host_button_pressed)

func _on_join_button_pressed():
	print("pressed join")
	var port = str(port.text).to_int()
	multiplayer_peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = multiplayer_peer
	menu.visible = false

func _on_host_button_pressed():
	var port = str(port.text).to_int()
	multiplayer_peer.create_server(port)
	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer_peer.peer_connected.connect(func(id): add_player_character(id))
	menu.visible = false
	add_player_character()

func add_player_character(id=1):
	var character = PLAYER.instantiate()
	character.name = str(id)
	add_child(character)
