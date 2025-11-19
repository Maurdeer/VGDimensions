@abstract
extends State
class_name CardState

@onready var card: Card = $"../../../."
@onready var card_visualizer: CardVisualizer = $"../../../card_visualizer"
@onready var animation_player: AnimationPlayer = $"../../../AnimationPlayer"
@onready var gridcard_visualizer: GridCardVisualizer = $"../../../gridcard_visualizer"
@onready var card_back: Sprite2D = $"../../../card_back"
@onready var gridcard_back: Sprite2D = $"../../../gridcard_back"
@onready var card_shape: Control = $"../../../card_shape"
@onready var gridcard_shape: Control = $"../../../gridcard_shape"

func clicked_on() -> void: pass
