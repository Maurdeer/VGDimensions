extends CardState
class_name InShopCardState

func clicked_on() -> void:
	var can_afford = true
	
	if can_afford:
		CardShop.process_purchase(card)
	else:
		pass
		#print("ShopState: Cannot afford ", card_ref.resource.title)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
