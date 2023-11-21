extends Node

@onready var player = $".."
@onready var animationPlayer: AnimationPlayer = $"../AnimationPlayer"

@onready var animationTree: AnimationTree = $"../AnimationTree"
@onready var animationState = animationTree.get("parameters/playback")
var idlePosition


func _ready() -> void:
	
	pass


func _process(delta: float) -> void:
	if player.idPath.size() > 1:
		_updateAnimationTree()
	pass
	
func _updateAnimationTree():
	var from = player.tileMap.local_to_map(player.idPath[0])
	var to = player.tileMap.local_to_map(player.idPath[1])
	var walkVector = Vector2(to - from)
	
	if walkVector != Vector2.ZERO:
		idlePosition = walkVector
	
	#if !animationPlayer.is_playing():
		#if walkVector.y < 0:
			#animationPlayer.play("walkNorth")
		#elif walkVector.y > 0:
			#animationPlayer.play("walkSouth")
		#elif walkVector.x > 0:
			#animationPlayer.play("walkRight")
		#elif walkVector.x < 0:
			#animationPlayer.play("walkLeft")
		#elif idlePosition.y < 0:
			#animationPlayer.play("idleNorth")
		#elif idlePosition.y > 0:
			#animationPlayer.play("idleSouth")
		#elif idlePosition.x > 0:
			#animationPlayer.play("idleRight")
		#elif idlePosition.x < 0:
			#animationPlayer.play("idleLeft")
	Debug.update("123123123123", "Idle" + str(idlePosition) + ", " )
	Debug.update("1231231231231233", "walk " + str(walkVector) + ", " )
		
	#animationTree.set('parameters/Idle/blend_position', walkVector.normalized())
	#animationState.travel("Idle")
	#if player.velocity != Vector2.ZERO:
		#
		#
		#animationState.travel("Idle")
	#else:
		#animationState.travel("Idle")
