extends Control

var player_name = ""

func _on_TextName_text_changed():
	var text = $TextName.text
	print("Changed to: " + text)
	player_name = text

func _on_LobbyJoin_pressed():
	if player_name == "":
		print("hehe")
		return
	Network.connect_to_server(player_name)
	_load_game()

func _on_LobbyCreate_pressed():
	if player_name == "":
		print("HEHE")
		return
	Network.create_server(player_name)
	_load_game()

func _load_game():
	get_tree().change_scene('res://Scenes/Game.tscn')