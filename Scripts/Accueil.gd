extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Json.has_team_saved():
		get_node("VBoxContainer/Mes listes").visible = false
	
func _on_Profils_pressed():
	get_tree().change_scene("res://Scenes/Profils_Display.tscn")
	
func _on_Mes_listes_pressed():
	get_tree().change_scene("res://Scenes/Liste.tscn")
	
func _on_Comptences_pressed():
	get_tree().change_scene("res://Scenes/comp_Display.tscn")
	
func _on_Sorts_pressed():
	get_tree().change_scene("res://Scenes/sort_Display.tscn")
