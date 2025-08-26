extends CardResource
class_name RockBlock

func on_enter_tree() -> void:
	on_play_functions.append(on_play_0)
	on_play_functions.append(on_play_1)
	

func on_start_of_turn() -> void:
	print("This is cool and move")
	
func on_play_0() -> void:
	print("On Play 0")
	
func on_play_1() -> void:
	print("On Play 1")
