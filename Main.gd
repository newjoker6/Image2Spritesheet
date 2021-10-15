extends Control




##### Used Variables #####

var tex
var sheet_name = ""

##### Shorthand Path #####

var Background_Colour
var PanelColour

var SpriteSheet
var SpriteBack
var FileBrowse

var ViewControl
var ViewWidth
var ViewPort
var ViewContainer

var VBox
var MaxColumnsLabel
var MaxColumnsCount
var SaveButton
var WidthLabel
var AddSpriteButton
var SpriteScaleLabel
var SpriteScale
var SpriteSheetName
var LocationLabel





##### Code Start #####

func _ready():
	setup()





##### Initial Setup #####

func setup():
	create_scene()
	set_variables()
	set_properties()
	set_colours()
	adjust_object_sizes()
	connect_signals()


func create_scene(): #Name:String, Class, Position:Vector2, Parent = self, Size:Vector2 = Vector2.ZERO
	create_item("BGColour", ColorRect)
	create_item("SideColour", ColorRect, Vector2(789,0), self, Vector2(300, 1024))
	
	create_item("ViewportContainer", ViewportContainer, Vector2.ZERO, self, Vector2(861,1024))
	create_item("Viewport", Viewport, Vector2.ZERO, $ViewportContainer, Vector2(861,1024))
	create_item("Control", Control, Vector2.ZERO, $ViewportContainer/Viewport)
	create_item("ColorRect", ColorRect, Vector2.ZERO, $ViewportContainer/Viewport/Control, Vector2(266,963))
	create_item("ItemList", ItemList, Vector2.ZERO, $ViewportContainer/Viewport/Control, Vector2(861,30))
	
	create_item("FileDialog", FileDialog, Vector2.ZERO, self, Vector2(834,486))
	
	create_item("VBoxContainer", VBoxContainer, Vector2(835,50), self, Vector2(130,338))
	create_item("ScaleLabel", Label, Vector2.ZERO, $VBoxContainer, Vector2(130,14))
	create_item("Scale", SpinBox, Vector2(0,34), $VBoxContainer, Vector2(130,24))
	create_item("WidthLabel", Label, Vector2(0,78), $VBoxContainer, Vector2(130,14))
	create_item("ViewWidth", SpinBox, Vector2(0,112), $VBoxContainer, Vector2(130,24))
	create_item("ColumnsLabel", Label, Vector2(0,156), $VBoxContainer, Vector2(130,14))
	create_item("MaxColumns", SpinBox, Vector2(0,190), $VBoxContainer, Vector2(130,24))
	create_item("AddSprite", Button, Vector2(0,234), $VBoxContainer, Vector2(130,20))
	create_item("SpritesheetName", LineEdit, Vector2(0,274), $VBoxContainer, Vector2(130,24))
	create_item("Save", Button, Vector2(0,318), $VBoxContainer, Vector2(130,20))
	create_item("LocationLabel", Label, Vector2(0,362), $VBoxContainer, Vector2(140,14))


func set_variables():
	Background_Colour = $BGColour
	PanelColour = $SideColour
	ViewContainer = $ViewportContainer
	ViewPort = $ViewportContainer/Viewport
	ViewControl = $ViewportContainer/Viewport/Control
	SpriteBack = $ViewportContainer/Viewport/Control/ColorRect
	SpriteSheet = $ViewportContainer/Viewport/Control/ItemList
	VBox = $VBoxContainer
	WidthLabel = $VBoxContainer/WidthLabel
	ViewWidth = $VBoxContainer/ViewWidth
	MaxColumnsLabel = $VBoxContainer/ColumnsLabel
	MaxColumnsCount = $VBoxContainer/MaxColumns
	SaveButton = $VBoxContainer/Save
	AddSpriteButton = $VBoxContainer/AddSprite
	SpriteScaleLabel = $VBoxContainer/ScaleLabel
	SpriteScale = $VBoxContainer/Scale
	SpriteSheetName = $VBoxContainer/SpritesheetName
	LocationLabel = $VBoxContainer/LocationLabel
	FileBrowse = $FileDialog


func connect_signals():
	SaveButton.connect("pressed", self, "save_pressed")
	AddSpriteButton.connect("pressed", self, "open_files")
	SpriteSheetName.connect("text_changed", self, "_on_SpritesheetName_text_changed")
	MaxColumnsCount.connect("value_changed", self, "_on_MaxColumns_value_changed")
	ViewWidth.connect("value_changed", self, "_on_ViewWidth_value_changed")
	SpriteScale.connect("value_changed", self, "_on_Scale_value_changed")
	SpriteSheet.connect("resized", self, "_on_ItemList_resized")
	FileBrowse.connect("files_selected", self, "_on_FileDialog_files_selected")
	FileBrowse.connect("visibility_changed", self, "_on_FileDialog_visibility_changed")


func set_colours():
	PanelColour.color = Color("333b4f")
	Background_Colour.color = Color("e5b083")
	SpriteBack.color = Color("426e5d")


func adjust_object_sizes():
	Background_Colour.rect_size.x = 789
	Background_Colour.rect_size.y = OS.get_screen_size().y
	PanelColour.rect_size.y = OS.get_screen_size().y
	SpriteSheet.rect_size.x = ViewWidth.value
	SpriteSheet.rect_size.y = 147


func set_properties():
	var SheetTheme = load("res://Image2Sprite/SpriteSheetTheme.tres")
	var ContainerTheme = load("res://Image2Sprite/VBoxTheme.tres")
	var EditorTheme = load("res://Image2Sprite/EditorTheme.tres")
	var dir = OS.get_system_dir(OS.SYSTEM_DIR_PICTURES)

	
	FileBrowse.mode = 1
	FileBrowse.access = 2
	FileBrowse.set_filters(PoolStringArray(["*.png"]))
	FileBrowse.window_title = "Add Sprites"
	FileBrowse.set_theme(EditorTheme)
	FileBrowse.set_current_dir(dir)
	
	AddSpriteButton.text = "Add Sprite"
	SaveButton.text = "Save Sheet"

	WidthLabel.text = "Spritesheet Width"
	WidthLabel.set_align(1)
	SpriteScaleLabel.text = "Sprite Scale"
	SpriteScaleLabel.set_align(1)
	MaxColumnsLabel.text = "Max Columns"
	MaxColumnsLabel.set_align(1)
	LocationLabel.autowrap = true
	
	SpriteSheet.auto_height = true
	SpriteSheet.max_columns = 8
	SpriteSheet.same_column_width = true
	SpriteSheet.set_theme(SheetTheme)
	SpriteSheet.icon_scale = 3
	SpriteSheet.fixed_icon_size = Vector2(32,49)
	
	SpriteSheetName.placeholder_text = "Spritesheet Name"
	
	ViewPort.set_transparent_background(true)
	
	VBox.set_theme(ContainerTheme)
	VBox.alignment = 1

	SpriteScale.max_value = 3
	SpriteScale.min_value = 1
	SpriteScale.value = 3
	ViewWidth.max_value = 789
	ViewWidth.value = SpriteSheet.rect_size.x
	MaxColumnsCount.max_value = 24
	MaxColumnsCount.min_value = 1
	MaxColumnsCount.value = 8





##### Reusable #####

func create_item(Name:String, Class, Position:Vector2 = Vector2.ZERO, Parent = self, Size:Vector2 = Vector2.ZERO):
	var obj = Class.new()
	obj.set_name(Name)
	if !obj.name == "Viewport":
		obj.rect_position = Position
		obj.rect_size = Size
	Parent.add_child(obj)


func create_texture(image_path: String):
	var img = Image.new()
	img.load(image_path)
	var texture = ImageTexture.new()
	texture.create_from_image(img)
	SpriteSheet.add_item("", texture)






##### Program Functions #####

func save(SpritesheetName: String = "spritesheet"):
	SpriteSheet.unselect_all()
	yield(get_tree(),"idle_frame")
	var img = ViewPort.get_texture().get_data()
	img.convert(Image.FORMAT_RGBA8)
	img.flip_y()
	img.resize(img.get_width(), img.get_height())
	img.save_png("user://" + SpritesheetName + ".png")
	LocationLabel.text = "%s has been saved at %s" %[SpritesheetName, OS.get_user_data_dir()]





##### Received Signals #####

func open_files():
	SpriteSheet.mouse_filter = 0
	FileBrowse.popup_centered()


func _on_FileDialog_files_selected(paths):
	SpriteSheet.mouse_filter = 0
	for file in paths:
		if file.get_extension().to_lower() == "png":
			create_texture(file)


func _on_FileDialog_visibility_changed():
	if SpriteSheet.mouse_filter == 0:
		SpriteSheet.mouse_filter = 2
		SpriteBack.mouse_filter = 2
	else:
		SpriteSheet.mouse_filter = 0
		SpriteBack.mouse_filter = 0


func _on_SpritesheetName_text_changed(new_text):
	sheet_name = new_text


func save_pressed():
	if sheet_name == "":
		SpriteBack.visible = false
		yield(get_tree(),"idle_frame")
		save()
		yield(get_tree(),"idle_frame")
		SpriteBack.visible = true
	else:
		SpriteBack.visible = false
		yield(get_tree(),"idle_frame")
		save(sheet_name)
		yield(get_tree(),"idle_frame")
		SpriteBack.visible = true


func _on_ViewWidth_value_changed(value):
	SpriteSheet.rect_size.x = value
	ViewPort.size.x = value
	_on_ItemList_resized()


func _on_MaxColumns_value_changed(value):
	_on_ItemList_resized()
	SpriteSheet.max_columns = value


func _on_ItemList_resized():
	SpriteSheet.rect_size.y = 0
	SpriteBack.rect_size = SpriteSheet.rect_size
	ViewPort.size = SpriteSheet.rect_size
	ViewContainer.rect_size = SpriteSheet.rect_size


func _on_Scale_value_changed(value):
	SpriteSheet.icon_scale = value
	_on_ItemList_resized()
