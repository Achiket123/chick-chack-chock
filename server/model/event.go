package model

type Event struct {
	Event           string          `json:"event"`
	Message         MessageModel    `json:"message"`
	Play            Play            `json:"play"`
	Room            Room            `json:"room"`
	PlayerConnected PlayerConnected `json:"player_connected"`
}
