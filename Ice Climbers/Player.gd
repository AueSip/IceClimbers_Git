extends KinematicBody2D

enum State {NORMAL,CLIMBING}

# All default values
var DEFAULT_JUMP_HEIGHT = 300
var DEFAULT_WALL_JUMP_PUSH = 400
var MAX_VERTICAL_SPEED = 100
var DEFAULT_GLIDE_HORIZONTAL_ACCELERATION = 250
var DEFAULT_GLIDE_HORIZONTAL_SPEED = 155
var DEFAULT_GRAVITY = 450
var MAX_HORIZONTAL_SPEED = 200
var DEFAULT_JUMP_SPEED = 300
var DEFAULT_HORIZONTAL_ACCELERATION = 2000

# All the player Variables
var wallJumpHeight = DEFAULT_JUMP_HEIGHT
var wallJumpPush = DEFAULT_WALL_JUMP_PUSH
var touchingWall = false
var climbing = false
var maxverticalSpeed = MAX_VERTICAL_SPEED
var glideHorizontalAcceleration = DEFAULT_GLIDE_HORIZONTAL_ACCELERATION
var glideHorizontalSpeed = DEFAULT_GLIDE_HORIZONTAL_SPEED
var gravity = DEFAULT_GRAVITY
var velocity = Vector2.ZERO
var maxHorizontalSpeed = MAX_HORIZONTAL_SPEED
var jumpSpeed = DEFAULT_JUMP_SPEED
var horizontalAcceleration = DEFAULT_HORIZONTAL_ACCELERATION
var jumpTerminationMultiplier = 4
var currentState = State.NORMAL
var isStateNew = true
var inWindGust = false
var windStrength = 0
var windDirection = Vector2.ZERO

onready var leftRay = $Position2D/RayLeft
onready var rightRay = $Position2D/RayRight


func default_values():
		gravity = DEFAULT_GRAVITY
		maxHorizontalSpeed = MAX_HORIZONTAL_SPEED
		horizontalAcceleration = DEFAULT_HORIZONTAL_ACCELERATION

func _physics_process(delta):
	if climbing == false:
		velocity.y += gravity * delta
	if climbing == true:
		velocity.y = 0
		can_climb()
		
func _process(delta):
	
	if Input.is_action_just_pressed("left_click"):
		$AnimationPlayer.play("Swing")
		
	match currentState:
		State.NORMAL:
			process_normal(delta)
			
	#how to let the script know that a state has been changed 
func change_state(newState):
	currentState = newState	
	isStateNew = true
	
	#movement stated for Vector.x and Vector.y

var againstWindVelocity = 0
func process_normal(delta):
	var moveVector = get_movement_vector()
	
	var wasOnFloor = is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if inWindGust && $AnimatedSprite.animation == "Glide":
		var xVel0 = -maxHorizontalSpeed + (windStrength * windDirection.x)
		var xVel1 = maxHorizontalSpeed + (windStrength * windDirection.x)

		velocity.x = clamp(velocity.x, xVel0, xVel1)
		
		if windDirection.y == -1:
			velocity.y -= 100
			velocity.y = clamp(velocity.y, -windStrength, windStrength)
	else:
		velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	velocity.x += moveVector.x * horizontalAcceleration * delta
	if (moveVector.x == 0):
		if !$AnimatedSprite.animation == "Glide":
			velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
		else:
			velocity.x = lerp(0, velocity.x, pow(2, -2.5*delta))
		
	if (moveVector.y < 0 && (is_on_floor() || !$CoyoteTimer.is_stopped())):
		velocity.y = moveVector.y * jumpSpeed
		
	if (velocity.y < 0 && !Input.is_action_pressed("jump") && !$AnimatedSprite.animation == "Glide"):
		velocity.y = moveVector.y * jumpSpeed * jumpTerminationMultiplier * delta
	else:
		_physics_process(delta)
	
	#Stating that if the character was on the floor and now is not that it will start both timers
	if (wasOnFloor && !is_on_floor()):
		$CoyoteTimer.start()
		$GlideWaitTimer.start()
		
	if (climbing && Input.is_action_pressed("jump")):
		velocity.y = moveVector.y * jumpSpeed
		climbing = false
		$WallJumpTimer.start()
	
	# If detected that Jump is held in the air it will activate glide and change these parameters... else it stays the same
	if (!is_on_floor() && Input.is_action_pressed("jump") && $GlideWaitTimer.is_stopped() && !climbing && $WallJumpTimer.is_stopped()):
		gravity = 1600	
		horizontalAcceleration = glideHorizontalAcceleration
		maxHorizontalSpeed = lerp(glideHorizontalSpeed, maxHorizontalSpeed, pow(2, -delta))
		if windDirection.y == 0:
			velocity.y = +gravity * delta
	else:
		default_values()
	
		
	update_animation()


	

	#The game getting the inputs for movement
func get_movement_vector():
	var moveVector = Vector2.ZERO
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return moveVector
	
	#Animations for the character to be played during certain circumstances
func update_animation():
	var moveVec = get_movement_vector()
	if (!is_on_floor() && gravity != 450):
		$AnimatedSprite.play("Glide")
	elif (!is_on_floor() && velocity.x != 0):
		$AnimatedSprite.play("Jump")
	elif (moveVec.x != 0):
		$AnimatedSprite.play("Walk")
	else:
		$AnimatedSprite.play("default")	
	if (moveVec.x != 0):
		$AnimatedSprite.flip_h = true if moveVec.x < 0 else false
		
func can_climb():
	if Input.is_action_pressed("up"):
		velocity.y = -maxverticalSpeed
	if Input.is_action_pressed("down"):
		velocity.y = maxverticalSpeed
	


