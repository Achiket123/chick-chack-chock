package model

import "github.com/gorilla/websocket"

type Room struct {
	RoomId      string `json:"room_id"`
	Player1     string `json:"player1"`
	Player1Conn *websocket.Conn
	Player2Conn *websocket.Conn
	Player2     string `json:"player2"`
}
