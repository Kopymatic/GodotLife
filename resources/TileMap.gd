extends TileMap

const TILE_SIZE = 16

export(int) var width
export(int) var height

var playing = false

var tempField

var prevCell

func _ready():
	var widthPx = width * TILE_SIZE
	var heightPx = height * TILE_SIZE
	
	var cam = $Camera2D
	
	cam.position = Vector2(widthPx, heightPx)/2
	cam.zoom = Vector2(widthPx, heightPx) / Vector2(1920, 1080)
	
	tempField = []
	for x in range(width):
		var temp = []
		for y in range(height):
			set_cell(x, y, 0)
			temp.append(get_cell(x,y))
		tempField.append(temp)

func _input(event):
	if event.is_action_pressed("toggle_simulation"):
		playing = !playing
	if Input.is_action_pressed("click"):
		var pos = (get_local_mouse_position()/TILE_SIZE).floor()
		if prevCell == pos:
			pass
		else: 
			prevCell = pos
			set_cellv(pos, 1-get_cellv(pos))
	if Input.is_action_just_released("click"):
		prevCell = null
		
func _process(delta):
	updateField()
	
func updateField():
	if !playing: return
	
	for x in range(width):
		for y in range(height):
			var liveNeighbors = 0
			for xOff in [-1, 0, 1]:
				for yOff in [-1, 0, 1]:
					if xOff != yOff or xOff != 0:
						if get_cell(x + xOff, y + yOff) == 1:
							liveNeighbors += 1
			if get_cell(x, y) == 1:
				if liveNeighbors in [2,3]: tempField[x][y] = 1
				else: tempField[x][y] = 0
			else:
				if liveNeighbors == 3: tempField[x][y] = 1
				else: tempField[x][y] = 0
	#update current tileset
	for x in range(width):
		for y in range(height):
			set_cell(x, y, tempField[x][y])

