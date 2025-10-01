extends RiftGrid
class_name NetworkedRiftGrid

func draw_card(draw_to: Vector2i) -> void:
	rpc("_draw_card_rpc", draw_to)
	
@rpc("any_peer","call_local")
func _draw_card_rpc(draw_to: Vector2i) -> void:
	super.draw_card(draw_to)
	
# Security Check if the RiftGrid grid and Draw Deck states are the same in all peers
func integrity_check() -> void:
	pass
		
