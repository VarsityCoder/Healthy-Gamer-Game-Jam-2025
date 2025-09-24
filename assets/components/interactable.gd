extends Area2D

@export var activities: Array[Command]   # List of activities available here

#signal available_actions(activities: Array[Command])
#signal actions_cleared

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		var activityTitles = []
		for a in activities:
			activityTitles.append(a.activity_name)
		print("You can now do:", activityTitles)
		#emit_signal("available_actions", activities)
		ActivityManager.availableActions(activities)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		#emit_signal("actions_cleared")
		ActivityManager.clearActions()
