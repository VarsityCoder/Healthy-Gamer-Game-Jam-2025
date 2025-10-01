extends Control

# Store if actions have been done before
# When an action is done, calculate new available activities

var cv_updates = 0

var practice_interviews = 0

var tbd_emails = [
	#{"delivered": 2, "message": "Hey, hows it going?"}
]

# Use the emails array with the dialogue box
var emails = []

var current_interview = 0

var interview_stats = [
	{"intro":"not taken"},
	{"intro":"not taken"}
]

var companies = [
	"Stability Bank",
	"Bleeding Bat"
]

var first_interviews = [
	# Interview 1 with Stability Bank from Narrative Doc
	{"req_cv": 1, "role_close_date": 5, "message": "Stability Bank: Introductory Call"},
	# Interview 1 with Bleeding Bat from Narrative Doc
	{"req_cv": 2, "role_close_date": 9, "message": "Bleeding Bat: Introductory Call"},
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
		print("Updated CV +1 using debug: ", cv_updates)
		
	if Input.is_action_pressed("testInterview"):
		practice_interviews += 1
		print("Practiced Interview +1 using debug: ", practice_interviews)

func check_job_stats():
	for i in range(first_interviews.size()):
		if TimeManager.current_day < first_interviews[i]["role_close_date"] and cv_updates > first_interviews[i]["req_cv"]:
			if interview_stats[i]["intro"] == "not taken":
				send_success_email(i, first_interviews[i]["message"])
				return "passed ATS"
	print("player failed ATS...")
	return "failed ATS"
	
func end_interview(outcome):
	if outcome == "bad":
		add_email(TimeManager.current_day + randi_range(0, 2), companies[current_interview] + ": Unfortunately, we have moved forward with other...")
		print("Added failed interview message to inbox")
	elif outcome == "good":
		add_email(TimeManager.current_day + randi_range(0, 2), companies[current_interview] + ": Congratulations! Click here to...")
		print("Added interview sucess message to inbox")
	
func send_success_email(interview_index, message):
	print("Adding an email to be delivered...")
	add_email(TimeManager.current_day + 2, message)
	#first_interviews.remove_at(0)

func send_default_email():
	var default_emails = [
		"Thank you for applying! We will get back to you soon.",
		"We appreciate you choosing us! If there is a match...",
		"Hi [applicant #" + str(randi_range(426,1234)) + "], Unfortunately we have decided to..."
	]
	print("sending default rejection")
	add_email(TimeManager.current_day + randi_range(0, 2), default_emails.pick_random())
			
func add_email(delivery_day: int, message):
	print("EMAILS: Scheduling an email for day ", delivery_day, ", ", message)
	tbd_emails.append({"delivered": delivery_day, "message": message})
	
func read_email(message):
	var to_remove = -1
	for i in range(emails.size()):
		if message == emails[i]:
			to_remove = i
	if to_remove != -1:
		emails.remove_at(to_remove)
		interview_stats[current_interview]["intro"] = "taken"
		print("Read and discarded the email: ", message)
		print(interview_stats)
		
func get_emails():
	print("Returning ", emails)
	return emails
	
func _on_day_updated(current_day):
	var to_remove = []
	for i in range(tbd_emails.size()):
		var e = tbd_emails[i]
		if "delivered" in e and "message" in e:
			print(e["delivered"]," ",e["message"], " is scheduled")
			if int(current_day) >= int(e["delivered"]) and e["message"] not in emails:
				print("Added ", e["message"], " to inbox")
				emails.append(e["message"])
				to_remove.append(i)
	while to_remove:
		tbd_emails.remove_at(to_remove.pop_back())
	print("TBD Emails is now ",tbd_emails)
	
	if int(current_day) == Globals.total_days:
		SoundManager.stop_all_sounds(0.0)
		CutsceneManager.go_to_game_over_scene()

func reset_game():
	cv_updates = 0
	practice_interviews = 0
	tbd_emails = []
	emails = []
	current_interview = 0
