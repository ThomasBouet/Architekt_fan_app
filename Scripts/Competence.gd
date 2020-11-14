extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Description_visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(comp):
	get_node("TextureButton/Nom").text = comp["Nom"]
	get_node("Description").bbcode_text = comp["Description"]
	return self
	
func resize_self():
	if Description_visible:
		get_node(".").rect_min_size = Vector2(get_node("ColorRect").rect_size.x, get_node("ColorRect").rect_size.y + get_node("Description").rect_size.y)
	else:
		get_node(".").rect_min_size = get_node("ColorRect").rect_size
		
func _on_LinkButton_pressed():
	Description_visible = !Description_visible
	get_node("Description").visible = Description_visible
	resize_self()

#var pressdown_position = Vector2()
#var press_threshold = 20
#func _on_LinkButton_gui_input(event):
#	if event is InputEventMouseButton : #with InputEventTouch it didn't want to work well
#		print(event.position.distance_to(pressdown_position))
#		if event.pressed:
#			pressdown_position = event.position
#		elif event.position.distance_to(pressdown_position) <= press_threshold:
#			on_LinkButton_pressed() #call the function you want the buttonpress to call


func _on_TextureButton_pressed():
	Description_visible = !Description_visible
	get_node("Description").visible = Description_visible
	resize_self()
