extends ConfirmationButton

func confirm():
	owner.queue_free()
	Toolbox.ui_mode = false
