extends Control

# Store if actions have been done before
# When an action is done, calculate new available activities

var cv_updates = 0

var practice_interviews = 0

var tbd_emails = [
	{"delivered": 2, "message": "Hey, hows it going?"}
]

var emails = []

var first_interviews = [
	# Interview 1 with Company 1 
	{"req_cv": 2, "role_close_date": 5},
	# Interview 1 with Company 2
	{"req_cv": 4, "role_close_date": 9},
]

var second_interviews = [
	# Interview 2 with Company 1
	{"req_practice": 2, },
	# Interview 2 with Company 2
	{"req_practice": 4, },
]

func _ready() -> void:
	TimeManager.day_updated.connect(_on_day_updated)
	
func _process(delta: float) -> void:
	# REMOVE LATER FOR TESTING
	if Input.is_action_pressed("testCV"):
		cv_updates += 1
		
	if Input.is_action_pressed("testInterview"):
		practice_interviews += 1

func check_job_stats():
	for i in range(first_interviews.size()):
		if TimeManager.current_day < first_interviews[i]["role_close_date"] and cv_updates > first_interviews[i]["req_cv"]:
			# Secured first email invite
			# TESTING Please change this later
			print("Adding an email to be delivered...")
			add_email(TimeManager.current_day + 2, "Company "+str(i)+": Introductory Call")
			first_interviews.remove_at(i)
			return
			
func add_email(delivery_day: int, message):
	print("EMAILS: Scheduling an email for day ", delivery_day, ", ", message)
	tbd_emails.append({"delivered": delivery_day, "message": message})
	
func _on_day_updated(current_day):
	for e in tbd_emails:
		if "delivered" in e and "message" in e:
			print(e["delivered"]," ",e["message"], " is scheduled")
			if int(current_day) >= int(e["delivered"]) and e["message"] not in emails:
				print("Added ", e["message"], " to inbox")
				emails.append(e["message"])
