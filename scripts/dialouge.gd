@tool
@icon("res://assets/placeholder")
extends Control

@export var dialogue_items: Array[DialogueItem] = []:
	set = set_dialogue_items

@onready var rich_text_label: RichTextLabel = $MarginContainer/VBoxContainer/RichTextLabel
#@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var body: TextureRect = $Container/Body
@onready var expression: TextureRect = $Container/Expression
@onready var action_buttons_v_box_container: VBoxContainer = $MarginContainer/VBoxContainer/ActionButtonsVBoxContainer

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	show_text(0)
	

var current_item = null

func show_text(current_item_index: int) -> void:
	var buttons = action_buttons_v_box_container.get_children()
	if buttons.size() > 0:
		for button in buttons:
			button.queue_free()

	current_item = dialogue_items[current_item_index]
	rich_text_label.visible_ratio = 0.0
	rich_text_label.text = current_item.text
	expression.texture = current_item.expression
	body.texture = current_item.character
	
	var tween := create_tween()
	var text_appearing_duration := (current_item["text"] as String).length() / 50.0
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)
	#var sound_max_offset := audio_stream_player.stream.get_length() - text_appearing_duration
	#var sound_start_position := randf() * sound_max_offset
	#audio_stream_player.play(sound_start_position)
	#tween.finished.connect(audio_stream_player.stop)
	tween.finished.connect(_on_tween_end)
	slide_in()

func _on_tween_end():
	create_buttons(current_item.choices)

func create_buttons(buttons_data: Array[DialogueChoice]) -> void:
	for button in action_buttons_v_box_container.get_children():
		button.queue_free()
	for choice in buttons_data:
		var button := Button.new()
		button.size_flags_horizontal = Control.SIZE_SHRINK_END
		action_buttons_v_box_container.add_child(button)
		button.text = choice.text
		var ending = choice.ending
		if choice.is_quit:
			button.pressed.connect(_finish_interview.bind(ending))
		else:
			var target_line_id := choice.target_line_idx
			#print("This btn goes to ", target_line_id)
			#button.connect("mouse_entered", Callable(func ():
				#print("Mouse entered button!")
			#))
			button.pressed.connect(show_text.bind(target_line_id))

func slide_in() -> void:
	var slide_tween := create_tween()
	slide_tween.set_ease(Tween.EASE_OUT)
	body.position.x = get_viewport_rect().size.x / 7
	slide_tween.tween_property(body, "position:x", 0, 0.3)
	body.modulate.a = 0
	slide_tween.parallel().tween_property(body, "modulate:a", 1, 0.2)

func _get_configuration_warnings() -> PackedStringArray:
	if dialogue_items.is_empty():
		return ["You need at least one dialogue item for the dialogue system to work."]
	return []
	
func set_dialogue_items(new_dialog_items: Array[DialogueItem]) -> void:
	for index in new_dialog_items.size():
		if new_dialog_items[index] == null:
			new_dialog_items[index] = DialogueItem.new()
	dialogue_items = new_dialog_items
	update_configuration_warnings()

func _finish_interview(outcome: String):
	print("Finishing interview, outcome:", outcome)
	WinStateManager.end_interview(outcome)
	CutsceneManager.go_to_apt()
