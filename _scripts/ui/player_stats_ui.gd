extends Control
@export var deleon_amount: Label
@export var action_amount: Label
@export var social_amount: Label
@export var polariod_amount: Label
@export var message: Label
@export var wins_amount: Label


func _ready() -> void:
	PlayerStatistics.on_stats_change.connect(_update_ui)
	PlayerStatistics.on_resource_spend_fail.connect(_on_player_stats_resource_spend_fail)
	PlayerStatistics.on_resource_spend_success.connect(_on_player_stats_success)
	call_deferred("_after_ready")
	
func _after_ready() -> void:
	pass
	
func _update_ui() -> void:
	deleon_amount.text = "%s" % PlayerStatistics.deleons
	action_amount.text = "%s" % PlayerStatistics.actions
	social_amount.text = "%s" % PlayerStatistics.socials
	polariod_amount.text = "%s" % PlayerStatistics.from_nava_polaroids
	wins_amount.text = "%s" % PlayerStatistics.dimensions_won
	
func _on_player_stats_resource_spend_fail(type: PlayerStatistics.ResourceType):
	match(type):
		PlayerStatistics.ResourceType.DELEON:
			message.text = "Not enough deleons"
		PlayerStatistics.ResourceType.ACTION:
			message.text = "Not enough actions"
		PlayerStatistics.ResourceType.SOCIAL:
			message.text = "Not enough social"
	
	message.visible = true
	
func _on_player_stats_success(_type: PlayerStatistics.ResourceType):
	message.visible = false
