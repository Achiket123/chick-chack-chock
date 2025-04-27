package model

type MessageModel struct {
	Message string `json:"message"`
	Sender  string `json:"sender"`
	Event   string `json:"event"`
	IsMe    bool   `json:"isMe"`
}
