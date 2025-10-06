extends Control
@onready var deleon_amount: Label = $VBoxContainer/Deleon/Amount
@onready var action_amount: Label = $VBoxContainer/Action/Amount
@onready var social_amount: Label = $VBoxContainer/Deleon3/Amount

func _ready() -> void:
	PlayerStatistics.on_stats_change.connect(_update_ui)
	
func _update_ui() -> void:
	deleon_amount.text = "%s" % PlayerStatistics.deleons
	action_amount.text = "%s" % PlayerStatistics.actions
	social_amount.text = "%s" % PlayerStatistics.socials
