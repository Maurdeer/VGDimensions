extends EventResource
class_name TargetSqaureGainResourceEvent

@export var amounts: Array[int]
@export var types: Array[PlayerStatistics.ResourceType]
@export var maxes: Array[int]
@export var target: CardResource.CardType
@export var selection_type: SelectionEventResource.SelectionType = SelectionEventResource.SelectionType.RIFT

const target_card_at: int = 0
func on_execute() -> bool: #Y x X. 
	if GameManager.Instance.is_my_turn():
		var selected_card_pos = m_card_refs[target_card_at].grid_pos
		var positions = [selected_card_pos + Vector2i(0, -1), selected_card_pos + Vector2i(0, 1), selected_card_pos + Vector2i(-1, 0), selected_card_pos + Vector2i(1, 0)]
		var count = 0
		for position in positions:
			if (position.x >= RiftGrid.Instance.rift_grid_height || position.x < 0) || (position.y >= RiftGrid.Instance.rift_grid_width || position.y < 0):
				continue
			var card = RiftGrid.Instance.get_top_card(position)
			if card.resource.type == target:
				count += 1
		
		for i in range(types.size()):
			var amount = amounts[i] * count
			amount = min(maxes[i], amount)
			PlayerStatistics.modify_resource(types[i], amount)
	
	return false
'''
[
	[Deck, Deck, Deck], Row0
	[Deck, Deck, Deck], Row1
	[Deck, Deck, Deck]	Row2
]

'''
	
func required_events() -> Array[EventResource]:
	var selection: SelectionEventResource = SelectionEventResource.new()
	selection.store_at = target_card_at
	selection.type = selection_type
	return [selection]
	
	
