extends ConfirmationButton

func confirm():
	get_parent().queue_free()
