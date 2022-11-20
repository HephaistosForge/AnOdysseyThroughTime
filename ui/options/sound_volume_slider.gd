extends HSlider


func _process(_delta):
	value = AudioServer.get_bus_volume_db(2)


func _on_value_changed(_value):
	AudioServer.set_bus_volume_db(2, _value)
