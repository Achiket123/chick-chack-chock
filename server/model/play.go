package model

type Play struct {
	RoomId string `json:"room_id"`
	Player string `json:"player"`
	Play   []int  `json:"play"`
}
