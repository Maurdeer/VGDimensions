extends Card
class_name BreakableWall

func on_end_of_turn():
	if hp > 0:
		hp = _starting_hp
