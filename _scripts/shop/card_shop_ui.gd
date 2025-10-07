extends Control
class_name CardShopUI

@onready var grid_container: GridContainer = $GridContainer

func display_cards(cards_to_display: Array[Card]) -> void:
	for child in grid_container.get_children():
		child.queue_free()
		
	for card_instance in cards_to_display:
		var card_slot_wrapper = CenterContainer.new()
		card_slot_wrapper.name = "CardSlot_" + str(grid_container.get_child_count())
		card_slot_wrapper.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card_slot_wrapper.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card_slot_wrapper.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		# remove from any previous parent first
		if card_instance.get_parent():
			card_instance.get_parent().remove_child(card_instance)
		
		card_slot_wrapper.add_child(card_instance)
		grid_container.add_child(card_slot_wrapper)
		# only when card is added as a child of obj, then card_sm is created so we can transition to IN_SHOP state
		card_instance.card_sm.transition_to_state(CardStateMachine.StateType.IN_SHOP)
	print("CardShopUI: Grid display updated with ", grid_container.get_child_count(), " cards.")

func on_card_purchased(card_node_to_remove: Card) -> void:
	card_node_to_remove.queue_free()
	print("CardShop_UI: Visually removed and freed card node.")
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CardShop.card_purchased.connect(on_card_purchased)
	call_deferred("_setup_shop_cards")
	
func _setup_shop_cards() -> void:
	var initial_cards: Array[Card] = CardShop.return_six_cards()
	print("initial cards", initial_cards)
	display_cards(initial_cards)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
