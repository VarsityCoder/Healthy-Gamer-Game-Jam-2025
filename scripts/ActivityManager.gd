extends Node

@onready var player = get_tree().get_root().get_node("Apartment/Player")
@onready var ui_manager = get_tree().get_root().get_node("Apartment/CanvasLayer/Ui")

var past_actions = []
var current_time_since_all = {}
var prereqs = {
	"Eat Meal": 1,
	"Yoga":1
}

func _ready() -> void:
	past_actions.append({
		"Activity": "Eat",
		"Time": TimeManager.game_time,
	})
	past_actions.append({
		"Activity": "Shower",
		"Time": TimeManager.game_time,
	})
	past_actions.append({
		"Activity": "Yoga",
		"Time": TimeManager.game_time,
	})

func perform(command: Command) -> void:
	command.execute()
	var action_name = command.activity_name
	if "Eat" in command.activity_name:
		action_name = "Eat"
		
	past_actions.append({
		"Activity": action_name,
		"Time": TimeManager.game_time,
	})

func time_since(activity_name: Array[String]):
	for action in past_actions.reversed():
		if action["Activity"] in activity_name:
			return TimeManager.game_time - action["Time"]

func time_since_all():
	var result = {}
	if len(past_actions) != 0:
		for i in range(len(past_actions)-1,-1, -1):
			#print(past_actions[i])
			if past_actions[i]["Activity"] not in result:
				result[past_actions[i]["Activity"]] = TimeManager.game_time - past_actions[i]["Time"]
	current_time_since_all = result
	return result

func availableActions(actions):
	ui_manager.show_actions(actions)
	
func clearActions():
	ui_manager._clear_actions()
