package main

import (
	"log"
	"net/http"
	"os"
	"server/model"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{ReadBufferSize: 1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}
var roomSecrets = make(map[string]*model.Room)
var WinningCombinations = [8][3]int{
	{0, 1, 2}, // Horizontal
	{3, 4, 5}, // Horizontal
	{6, 7, 8}, // Horizontal
	{0, 3, 6}, // Vertical
	{1, 4, 7}, // Vertical
	{2, 5, 8}, // Vertical
	{0, 4, 8}, // Diagonal
	{2, 4, 6}, // Diagonal
}

func main() {
	PORT := os.Getenv("PORT")
	server := http.NewServeMux()

	server.HandleFunc("/ws", UpgradeConnection)

	log.Println("Server started on :8081")
	http.ListenAndServe(":"+PORT, server)

}

func UpgradeConnection(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	id := r.URL.Query().Get("id")
	name := r.URL.Query().Get("name")
	if err != nil {
		log.Println("Error while upgrading connection:", err)
		http.Error(w, "Could not upgrade connection", http.StatusBadRequest)
		return
	}
	var room model.Room
	if roomSecrets[id] == nil {
		room.RoomId = id
		room.Player1 = name
		roomSecrets[id] = &room
		roomSecrets[id].Player1Conn = conn
	} else {
		roomSecrets[id].Player2 = name
		roomSecrets[id].Player2Conn = conn
	}

	defer conn.Close()
	log.Println("Client connected ", name, id)
	for {
		NewPlay := &model.Play{}
		err := conn.ReadJSON(NewPlay)
		if err != nil {
			log.Println("Error while reading message:", err.Error())

			roomSecrets[id].Player1Conn.Close()
			roomSecrets[id].Player2Conn.Close()
			delete(roomSecrets, id)
			log.Println("Unexpected close error:", err.Error())

			break
		}
		if roomSecrets[id] == nil {
			log.Println("Room not found")
			break
		}
		if roomSecrets[id].Player1 == NewPlay.Player {
			log.Println("Player 1 play", NewPlay)

			roomSecrets[id].Player2Conn.WriteJSON(NewPlay)
		} else {
			log.Println("Player 2 play", NewPlay)
			roomSecrets[id].Player1Conn.WriteJSON(NewPlay)
		}

	}
}
