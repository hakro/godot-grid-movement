extends Sprite

onready var ray = $RayCast2D

var speed = 256 # big number because it's multiplied by delta
var tile_size = 64 # size in pixels of tiles on the grid

var last_position = position # last idle position
var target_position = position # desired position to move towards
var movedir = Vector2(0,0) # move direction

func _ready():
	position = position.snapped(Vector2(tile_size, tile_size)) # make sure player is snapped to grid

func _process(delta):
	# IDLE STATE
	if position == target_position:
		get_movedir()
		last_position = position # record the player's current idle position
		target_position += movedir * tile_size # if key is pressed, get new target (also shifts to moving state)
	
	# MOVING STATE
	else:
		if ray.is_colliding():
			position = last_position
			target_position = last_position
		else:
			position += speed * movedir * delta
		
			# PREVENT PLAYER FROM MOVING TOO FAR
			var distance = (position - last_position).abs().length() # how far the player moved from their last idle position
			if distance > tile_size - speed * delta: # subtracts speed * delta so there's no breaks in movement
				position = target_position

# GET DIRECTION THE PLAYER WANTS TO MOVE
func get_movedir():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	
	movedir.x = -int(LEFT) + int(RIGHT) # if pressing both directions this will return 0
	movedir.y = -int(UP) + int(DOWN)
	
	if movedir.x != 0 && movedir.y != 0: # prevent diagonals
		movedir = Vector2.ZERO
	if movedir != Vector2.ZERO:
		ray.cast_to = movedir * tile_size / 2