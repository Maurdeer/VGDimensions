@abstract
extends State
class_name CardState

@onready var card: Card = $"../../."
@onready var card_visualizer: CardVisualizer = $"../../card_visualizer"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var gridcard_visualizer: GridCardVisualizer = $"../../gridcard_visualizer"
@onready var dnd: DragAndDropComponent2D = $"../../drag_and_drop_component2D"

func clicked_on() -> void: pass
