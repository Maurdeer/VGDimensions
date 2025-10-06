extends Control
@onready var deleon_amount: Label = $VBoxContainer/Deleon/Amount
@onready var action_amount: Label = $VBoxContainer/Action/Amount
@onready var social_amount: Label = $VBoxContainer/Deleon3/Amount
@onready var message: Label = $VBoxContainer/message


func _ready() -> void:
	PlayerStatistics.on_stats_change.connect(_update_ui)
	PlayerStatistics.on_resource_spend_fail.connect(_on_player_stats_resource_spend_fail)
	call_deferred("_after_ready")
	
func _after_ready() -> void:
	pass
	
func _update_ui() -> void:
	deleon_amount.text = "%s" % PlayerStatistics.deleons
	action_amount.text = "%s" % PlayerStatistics.actions
	social_amount.text = "%s" % PlayerStatistics.socials
	
func _on_player_stats_resource_spend_fail(type: PlayerStatistics.ResourceType):
	match(type):
		PlayerStatistics.ResourceType.DELEON:
			message.text = "Not enough deleons"
		PlayerStatistics.ResourceType.ACTION:
			message.text = "Not enough actions"
		PlayerStatistics.ResourceType.SOCIAL:
			message.text = "Not enough social"
			
	message.visible = true
	await get_tree().create_timer(3).timeout
	message.visible = false
