using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;
using System.Collections;
using PlayerIO.GameLibrary;
using System.Drawing;

namespace MyGame {
	//Player class. each player that join the game will have these attributes.
	public class Player : BasePlayer {
        public String UserName;
        public String Color;
        public String UserType;
        public String Status;
        public Boolean MuteSound;
        public Player()
        {
            UserName = "";
            Color = "0x000000";
            UserType = "Reg";
            Status = "Norm";
        }

	}
	public class GameCode : Game<Player> {
			
		
		// This method is called when an instance of your the game is created
		public override void GameStarted() {
            //load all player objects
            PreloadPlayerObjects = true;
			// anything you write to the Console will show up in the 
			// output window of the development server
			Console.WriteLine("Game is started");
		}

		// This method is called when the last player leaves the room, and it's closed down.
		public override void GameClosed() {
			Console.WriteLine("RoomId: " + RoomId);
		}

        public override bool AllowUserJoin(Player player)
        {
            /*
            foreach (Player t in Players)
            {
                Console.WriteLine("Player = " + t.JoinData["Name"]);

                if (t.JoinData["Name"] == player.JoinData["Name"])
                {
                    Console.WriteLine("Denied Player = " + player.JoinData["Name"]);
                    player.Disconnect();
                }
            }*/
             
            return base.AllowUserJoin(player);
            
        }

		// This method is called whenever a player joins the game
		public override void UserJoined(Player player) {

            
            if (player.JoinData["Name"] != "UnknownGuardian")
            {
                int count = 0;
                foreach (Player t in Players)
                {
                    if (t.JoinData["Name"] == player.JoinData["Name"])
                    {
                        count++;
                        if (count >= 2)
                        {
                            Console.WriteLine("UserLeft Message prevented on Player = " + player.JoinData["Name"]);
                            player.Disconnect();
                            return; //already found twice, so disconnect without sending join message
                        }
                    }
                }
            }
            
            
            //if the player is new
            if (!player.PlayerObject.Contains("Color"))
            {
                //set default objects
                player.PlayerObject.Set("Color", player.JoinData["Color"]);
                player.PlayerObject.Set("MuteSound", false);
                player.PlayerObject.Save();
            }


            player.UserName = player.JoinData["Name"]; //set the player's username to the connected username
            player.UserType = player.JoinData["Type"]; //set the player's type (mod, admin, reg, to the connected type
            player.Color = player.PlayerObject.GetString("Color", "0x000000"); //set the color to the selected color, or black on default.


			//Send info about all already connected users to the newly joined users chat
			Message m = Message.Create("ChatInit");
			m.Add(player.Id);

			foreach(Player p in Players) {

                ////m.Add(p.Id, p.JoinData["Name"],p.JoinData["Type"]);
                //m.Add( (p.Id.ToString() + "|" + p.UserName + "|" + p.UserType + "|" + p.Color + "|" + p.Status) as String); //adds id, name, type, color about other users to send to this one
                m.Add(p.Id, p.UserName, p.UserType, p.Color, p.Status);
			}
            player.Send(m);


            ////Broadcast("ChatJoin", player.Id, player.JoinData["Name"],player.JoinData["Type"]);
            //Broadcast("ChatJoin", (player.Id.ToString() + "|" + player.UserName + "|" + player.UserType + "|" + player.Color + "|" + player.Status) as String); //send info about this player to other players
            Broadcast("ChatJoin", player.Id, player.UserName, player.UserType, player.Color, player.Status); //send info about this player to other players
            Console.WriteLine((player.Id.ToString() + "|" + player.UserName + "|" + player.UserType + "|" + player.Color + "|" + player.Status) as String);
		}

		// This method is called when a player leaves the game
		public override void UserLeft(Player player) {
			//Tell the chat that the player left.
            
            bool stillExists = false; //for players that tried a new tab
            if (player.JoinData["Name"] != "UnknownGuardian")
            {
                foreach (Player t in Players)
                {
                    if (t.JoinData["Name"] == player.JoinData["Name"])
                    {
                        Console.WriteLine("UserLeft Message prevented on Player = " + player.JoinData["Name"]);
                        stillExists = true;
                    }
                }
            }

            
            if (!stillExists)
            {
                Broadcast("ChatLeft", player.Id);
            }
			
			Console.WriteLine("User left the chat " + player.Id);

		}

		// This method is called when a player sends a message into the server code
		public override void GotMessage(Player player, Message message) {
			switch(message.Type) {
				case "ChatMessage": {
						Broadcast("ChatMessage", player.Id, message.GetString(0));
						break;
					}
			}
		}
	}
}