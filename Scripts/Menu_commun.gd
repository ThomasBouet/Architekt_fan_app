extends Control
	
	
func _on_Liste_Btn_pressed():
	print("Listes")
	get_tree().change_scene("res://Scenes/Liste.tscn")
	
func _on_Profil_Btn_pressed():
	print("Profils")
	get_tree().change_scene("res://Scenes/Profils_Display.tscn")
	
func _on_Accueil_Btn_pressed():
	print("Accueil")
	get_tree().change_scene("res://Scenes/Accueil.tscn")
	
func _on_Regle_Btn_pressed():
	print("Règles")
	get_tree().change_scene("res://Scenes/regles.tscn")
#	get_tree().change_scene("res://Scenes/scenar_disp.tscn")
	
func _on_CaF_Btn_pressed():
	print("CaF")
	get_tree().change_scene("res://Scenes/comp_Display.tscn")
#	get_tree().change_scene("res://Scenes/Sort_display.tscn")
