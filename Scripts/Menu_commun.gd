extends Control

onready var queue =  get_node('/root/ResourceQueue')
var loading_playing = false
	
func _ready():
	queue.start()
	
func _on_Liste_Btn_pressed():
	load_scene("res://Scenes/Liste.tscn")
	
func _on_Profil_Btn_pressed():
	load_scene("res://Scenes/Profils_Display.tscn")
	
func _on_Accueil_Btn_pressed():
	load_scene("res://Scenes/Accueil.tscn")
	
func _on_Regle_Btn_pressed():
	load_scene("res://Scenes/regles.tscn")
	
func _on_CaF_Btn_pressed():
	load_scene("res://Scenes/Comp_et_Form_Display.tscn")

func loading():
	loading_playing = true
	get_node("icon").loading()
	
func hide_loading():
	loading_playing = true
	get_node("icon").hide_loading()
	
func load_scene(scene):
	queue.queue_resource(scene, true)
	
	while !queue.is_ready(scene):
		if !loading_playing:
			loading()
		yield(get_tree(), 'idle_frame')
#		print(queue.get_progress(scene))
	hide_loading()
		
	var lvl = queue.get_resource(scene)
#	print(lvl)
#	lvl est de type PackedScene
	get_tree().change_scene_to(lvl)


func _on_Comptences_pressed():
	pass # Replace with function body.
