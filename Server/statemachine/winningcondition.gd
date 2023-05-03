extends "state.gd"

var response_type = "all"

func enter(previous_state : Node, _Server : Node, GameManager : Node):
	
	if GameManager.winning_condition():
		emit_signal("finished", "end_game")
	else:
		print("No Winner yet ...")
		match(previous_state.name):
			"DiceShowValue":
				emit_signal("finished", "pick_card")
			"ActivateCard":
				emit_signal("finished", "end_turn")
