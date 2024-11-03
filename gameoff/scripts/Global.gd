extends Node

signal update_secrets

var secrets_found := 0:
	set(val):
		secrets_found = val
		update_secrets.emit()

var time_parts := {"clock": false}
