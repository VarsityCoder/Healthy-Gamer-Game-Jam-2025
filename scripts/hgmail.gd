extends Node

@onready var email_list = $CanvasLayer/screen/MarginContainer/VBoxContainer2/emailList


var spam_subjects = [
	"QuickBite Eats: Student Promo - 40% Off Your First 3 Orders",
	"CampusCart Grocery: Midnight Delivery Now Available Near You",
	"PixelPlay Games: Preorder Bonus Code Inside",
    "SocialCircle: Someone Tagged You in a Photo"
]

var btn_scene = preload("res://assets/components/email.tscn")

func _ready():
	for e in spam_subjects:
		var btn = btn_scene.instantiate()
		
		btn.find_child("Label").text = e
		email_list.add_child(btn)
		email_list.move_child(btn, 0)
		
	for e in WinStateManager.emails:
		var btn = btn_scene.instantiate()
		
		btn.find_child("Label").text = e
		if "Call" in e:
			btn.event_email = e
		email_list.add_child(btn)
		email_list.move_child(btn, 0)


func _on_button_pressed() -> void:
	CutsceneManager.go_to_apt()
