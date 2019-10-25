extends Control

var player_name = "Player"
var target_ip = DEFAULT_IP
const DEFAULT_IP = '127.0.0.1'

func _on_IPText_text_changed(new_text):
#	var text = $JoinContainer/IPText.text
	print("Name changed to: " + new_text)
	player_name = new_text

func _on_NameText_text_changed(new_text):
#	var text = $NameContainer/NameText.text
	print("Target address changed to: " + new_text)
	target_ip = new_text

func _on_LobbyJoin_pressed():
	if player_name == "":
		print("Player name field is empty")
		return
	if target_ip == "":
		print("IP field empty")
		return
	Network.connect_to_server(player_name, target_ip)
	_load_game()
	

func _on_LobbyCreate_pressed():
	if player_name == "":
		print("HEHE")
		return
	Network.create_server(player_name)
	print("Server created")
	_load_game()

func _load_game():
	get_tree().change_scene('res://Scenes/Game.tscn')

func _on_BackButton_pressed():
	get_tree().change_scene('res://Scenes/MainMenu.tscn')
