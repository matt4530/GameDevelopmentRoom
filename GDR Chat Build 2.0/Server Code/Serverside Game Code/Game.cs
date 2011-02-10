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
    [RoomType("TicTacToe")]
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

		// This method is called whenever a player joins the game
		public override void UserJoined(Player player)
        {
            
            //if the player is new
            //if (!player.PlayerObject.Contains("Color"))
            if (!player.PlayerObject.Contains("Color"))
            {
                //set default objects
                //player.PlayerObject.Set("Color", player.JoinData["Color"]);
                player.PlayerObject.Set("Time", 0);
                player.PlayerObject.Save();
            }

            player.UserName = player.JoinData["Name"]; //set the player's username to the connected username
            player.UserType = player.JoinData["Type"]; //set the player's type (mod, admin, reg, to the connected type

            //custom admins, mods
            String n = player.UserName;
            if (n == "UnknownGuardian" || n == "BraydenBlack" || n == "davidarcila" || n == "Profusion")
            {
                player.UserType = "Admin";
            }
            else if (n == "ST3ALTH15" || n == "BobTheCoolGuy" || n == "wolfheat" || n == "lord_midnight" || n == "Rivaledsouls" || n == "Pimgd" || n == "Sanchex" || n == "Disassociative" || n == "eroge" || n == "GDRTestMod")
            {
                player.UserType = "Mod";
            }

            //get, set colors
            if (player.UserType == "Admin")
            {
                player.Color = "0xCC0033";
            }
            else if (player.UserType == "Mod")
            {
                player.Color = "0xD77A41";
            }
            else if (player.UserType == "Dev")
            {
                player.Color = "0x0098FF";
            }
            else
            {
                player.Color = "0x000000";
            }

            //player.Color = player.PlayerObject.GetString("Color", "0x000000"); //set the color to the selected color, or black on default.


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

            Broadcast("ChatLeft", player.Id);
			
			Console.WriteLine("User left the chat " + player.Id);

		}

		// This method is called when a player sends a message into the server code
		public override void GotMessage(Player player, Message message) {
			switch(message.Type) {
				case "ChatMessage": {
                    String m = message.GetString(0);

                    if (player.Status == "Silenced" && player.UserName != "UnknownGuardian")
                    {
                        return;
                    }
                    if (m.Length > 10 && m.ToUpper() == m)
                    {
                        m = m.ToLower();
                    }
                    if (m.IndexOf("/silence ") == 0 || m.IndexOf("/unsilence ") == 0)
                    {
                        if(player.UserType != "Mod" || player.UserType != "Admin")
                        {
                            return;
                        }
                        else //accepted silence
                        {
                            String reciever = m.Split(' ')[1];
                            foreach (Player p in Players)
                            {
                                if (p.UserName == reciever)
                                {
                                    p.Send("ChatMessage", player.Id, m);
                                    if (m.IndexOf("/silence ") == 0)
                                    {
                                        p.Status = "Silenced";
                                    }
                                    else
                                    {
                                        p.Status = "AFK";
                                    }
                                    return;
                                }
                            }
                        }
                    }
                    if (m.IndexOf("/kickAll") == 0 && player.UserName == "UnknownGuardian")
                    {
                        Broadcast("ChatMessage", player.Id, m);
                        foreach (Player p in Players)
                        {
                            p.Disconnect();
                        }
                        return;
                    }
                    if (m.IndexOf("/kick ") == 0 && player.UserName == "UnknownGuardian")
                    {
                        Broadcast("ChatMessage", player.Id, m);
                        String reciever = m.Split(' ')[1];
                        foreach (Player p in Players)
                        {
                            if (p.UserName == reciever)
                            {
                                p.Disconnect();
                            }
                        }
                        return;
                    }
                    if (m.IndexOf("/ban ") == 0 && player.UserName != "UnknownGuardian")
                    {
                        return;
                    }
                    if (m.IndexOf("/w ") == 0)
                    {
                        String reciever = m.Split(' ')[1];
                        foreach (Player p in Players)
                        {
                            if (p.UserName == "UnknownGuardian" || p.UserName == reciever)
                            {
                                p.Send("ChatMessage",player.Id,m);
                            }
                        }
                        player.Send("ChatMessage", player.Id, m); //send message back to user who sent so they can see what they sent
                        return;
                    }

                    if (m.IndexOf("/afk") == 0)
                    {
                        player.Status = "AFK";
                    }
                    else if (m.IndexOf("/back") == 0 || player.Status == "AFK")
                    {
                        player.Status = "Norm";
                    }
                    else if (m.IndexOf("/setColor") == 0 && m.Length == 18)
                    {
                        //player.Color = m.Substring(m.IndexOf(" ") + 1);
                    }

					Broadcast("ChatMessage", player.Id, m);
					break;
				}
                case "Time": {
                    int time = player.PlayerObject.GetInt("Time") + 5;
                    player.PlayerObject.Set("Time", time);
                    player.PlayerObject.Save();
                    Message m = Message.Create("TimeReply");
                    m.Add(time);
                    player.Send(m);
                    break;
                }
                case "PollResponse": {
                    foreach (Player p in Players)
                    {

                        if (p.Id == message.GetInt(0))
                        {
                            p.Send(message);
                            break;
                        }
                    }
                    break;
                }
                case "PollCreate":
                {
                    Broadcast("PollCreate", player.Id, message.GetString(0));
                    break;
                }
			}
		}
	}
}