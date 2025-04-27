package model

type Play struct {
	RoomId string `json:"room_id"`
	Player string `json:"player"`
	Play   []int  `json:"play"`
	Event  string `json:"event"`
}

type PlayerConnected struct {
	Player string `json:"player"`
	RoomId string `json:"room_id"`
	Event  string `json:"event"`
}
