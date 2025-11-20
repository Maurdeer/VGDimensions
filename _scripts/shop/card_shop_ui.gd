extends Control
class_name CardShopUI

@onready var grid_container: GridContainer = $background/GridContainer
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var button: Button = $Button
@onready var card_shop_ui: Control = $".."

var is_shown: bool = false
var is_hovering: bool = true


func display_cards(cards_to_display: Array[Card]) -> void:
	for child in grid_container.get_children():
		child.queue_free()
		
	for card_instance in cards_to_display:
		var card_slot_wrapper = CenterContainer.new()
		card_slot_wrapper.name = "CardSlot_" + str(grid_container.get_child_count())
		card_slot_wrapper.mouse_filter = Control.MOUSE_FILTER_PASS
		card_slot_wrapper.size_flags_horizontal = Control.SIZE_SHRINK_CENTER + Control.SIZE_EXPAND
		card_slot_wrapper.size_flags_vertical = Control.SIZE_SHRINK_CENTER + Control.SIZE_EXPAND
		
		# remove from any previous parent first
		if card_instance.get_parent():
			card_instance.get_parent().remove_child(card_instance)
		
		card_slot_wrapper.add_child(card_instance)
		grid_container.add_child(card_slot_wrapper)
		# only when card is added as a child of obj, then card_sm is created so we can transition to IN_SHOP state
		card_instance.card_sm.transition_to_state(CardStateMachine.StateType.IN_SHOP)
	print("CardShopUI: Grid display updated with ", grid_container.get_child_count(), " cards.")
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("_after_ready")
	
func _after_ready() -> void:
	# Clearing temp stuff
	hide_card_shop()
	for child in grid_container.get_children():
		child.queue_free()
	GameManager.Instance.on_start_of_turn.connect(_fill_shop_with_cards.rpc)

@rpc("any_peer", "call_local", "reliable")
func _fill_shop_with_cards() -> void:
	var initial_cards: Array[Card] = CardShop.return_cards()
	print("initial cards", initial_cards)
	display_cards(initial_cards)

func show_card_shop() -> void:
	if animation_player.is_playing(): return
	if is_shown: return
	animation_player.play("show")
	await animation_player.animation_finished
	button.text = "<"
	is_shown = true
	
func hide_card_shop() -> void:
	if animation_player.is_playing(): return
	if not is_shown: return
	animation_player.play("hide")
	await animation_player.animation_finished
	button.text = ">"
	is_shown = false
	
func toggle_card_shop() -> void:
	if is_shown: hide_card_shop()
	else: show_card_shop()
	
func _on_button_pressed() -> void:
	toggle_card_shop()

func _on_background_mouse_entered() -> void:
	if is_hovering: return
	is_hovering = true

func _on_background_mouse_exited() -> void:
	print("Got in here")
	if not is_hovering: return
	is_hovering = false
	hide_card_shop()


#func _on_grid_container_mouse_exited() -> void:
	#if not is_hovering: return
	#is_hovering = false
	#hide_card_shop()
#
#
#func _on_grid_container_mouse_entered() -> void:
	#if is_hovering: return
	#is_hovering = true


func _on_button_mouse_entered() -> void:
	show_card_shop()
