extends EventResource
class_name SelectionEventResource

enum SelectionType {
	SELF,
	RIFT,
	PLAYER_HAND,
	PLAYER_DRAW_PILE,
	PLAYER_DISCARD_PILE,
	OPPONENT_HAND,
	OPPONENT_DRAW_PILE,
	OPPONENT_DISCARD_PILE,
}
@export var type: SelectionType
@export var store_at: int

func on_execute() -> bool:
	return false
	
func select(card_invoker: Card) -> Card:
	match (type):
		SelectionType.SELF:
			return card_invoker
		SelectionType.RIFT:
			return await RiftCardSelector.Instance.player_select_card()
	return null
