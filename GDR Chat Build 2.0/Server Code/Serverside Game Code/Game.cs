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
        public String SecretInfo;
        public Boolean MuteSound;
        public Boolean CanChat;
        public Boolean CanPostTime;
        public Player()
        {
            UserName = "";
            Color = "0x000000";
            UserType = "Reg";
            Status = "Norm";
            CanChat = true;
            CanPostTime = true;
            SecretInfo = "";
        }

	}
    [RoomType("TicTacToe")]
	public class GameCode : Game<Player> {
			
		
		// This method is called when an instance of your the game is created
		public override void GameStarted() {
            AddTimer(delegate { resetChatBooleans(); }, 1400);  //1.4 seconds
            AddTimer(delegate { resetTimeBooleans(); }, 290000); //4 minutes 50 seconds
            //load all player objects
            PreloadPlayerObjects = true;
			// anything you write to the Console will show up in the 
			// output window of the development server
			Console.WriteLine("Game is started");
		}

        public void resetChatBooleans()
        {
            foreach (Player p in Players)
            {
                p.CanChat = true;
            }
        }

        public void resetTimeBooleans()
        {
            foreach (Player p in Players)
            {
                p.CanPostTime = true;
            }
        }

		// This method is called when the last player leaves the room, and it's closed down.
		public override void GameClosed() {
			Console.WriteLine("RoomId: " + RoomId);
		}

        public override bool AllowUserJoin(Player player)
        {
            if (player.PlayerObject.Contains("Banned"))
            {
                return false;
            }
            //ban user list here
            return true;
        }

		// This method is called whenever a player joins the game
		public override void UserJoined(Player player)
        {
            //if (player.PlayerObject.Contains("Banned"))
            //{
                //player.Send("ChatMessage", player.Id, "/ban " + player.JoinData["Name"]);
                //deny user
                //return;
            //}


            //if the player is new
            //if (!player.PlayerObject.Contains("Color"))
            if (!player.PlayerObject.Contains("Time"))
            {
                //set default objects
                //player.PlayerObject.Set("Color", player.JoinData["Color"]);
                player.PlayerObject.Set("Time", 0);
                player.PlayerObject.Save();
            }

            player.UserName = player.JoinData["Name"]; //set the player's username to the connected username
            player.UserType = player.JoinData["Type"]; //set the player's type (mod, admin, reg, to the connected type
            try
            {
                player.SecretInfo = player.JoinData["SecretInfo"]; //alts
            }
            catch (Exception e)
            {
                player.SecretInfo = "|Error on this user";
                Console.Write(e.ToString());
            }


            //custom admins, mods
            String n = player.UserName;
            String AdminList = "|1138933|3277325|1619876|3277904|3|2|1|6|48|765|16|91|55598|76520|15760|157|589|16762|61023|523|7593|2090|1028064|1698253|101106|99479|2212077|2872272|2724855|462485|32030|4168012|4292588|76703|4138246|";
            String ModList = "|628624|114176|1262668|1139106|1360678|2852308|3685601|4942948|883866|41447|571592|1056870|694865|243482|3506166|2444033|4680566|251|48|765|597|16|2|3|1|611|6|91|670|17657|15760|16138|22|896|5275|17267|5973|81900|36645|150632|18288|47198|20367|19321|6562|30822|8569|8660|43961|5267|17378|58|220|53032|5276|5|6900|19863|13326|7457|3825|7882|19951|746|13958|39230|6066|55271|14063|13647|1712|68384|661|15289|3713|8007|836|19331|12616|31279|19300|28292|6369|6858|27369|29132|8717|6644|16762|769|17165|93953|9917|27986|13707|5588|18919|6064|6707|68292|43342|52098|76069|43366|365|10706|19886|1389|43716|62425|44720|15292|44988|15196|2656|122500|6899|19263|93657|70404|57762|158143|14862|29389|55598|30530|195189|58846|66466|13534|200909|257233|239113|67209|169474|80979|1890|14634|237989|272263|18520|133022|27098|193481|238155|19543|9905|137629|186818|546|472329|342465|162219|77940|126636|52298|59759|204342|115906|63383|66767|54101|20740|55825|15889|12228|107609|195719|884|141188|543879|290366|83973|245031|248278|152980|209576|486817|287186|16155|159070|277143|282892|84805|286709|275947|22102|194885|129062|194123|465175|408026|344335|172614|242792|86954|86405|106718|89604|303925|206845|288664|330327|119650|74720|291638|129302|476229|157|49162|474891|17732|160460|205443|17365|349988|295178|819825|291216|200438|691581|280114|123203|211207|282552|232922|287004|174952|143738|112433|76520|104248|336|318908|190232|525454|212782|396520|219500|336730|17554|311208|23329|263003|30966|124235|289058|346411|176916|140611|126191|29906|265287|995367|269275|479281|195731|121225|150843|529849|261704|55596|322611|204044|70510|446667|105017|719769|150631|30495|36456|174943|213978|454185|68825|839882|455399|157140|304671|285144|249758|31013|136173|76654|355082|243|628|23777|588464|13608|5448|14664|11810|64|819|861739|61|15070|32803|338|3000|261|564721|2245|46968|523|7593|212962|246104|393369|735161|450672|131680|39922|34507|452931|78145|959069|267960|554143|264974|403973|73739|814967|387567|254412|364485|281433|455533|214370|326519|310391|543467|587323|204849|208840|734522|381395|17994|552209|190244|249036|568984|246196|217989|155743|762127|76703|105532|548900|638129|182596|300270|32113|616030|723304|221641|1070004|843000|387577|822349|477445|471483|256173|478334|367234|198512|309283|210413|845428|864832|599173|172736|74684|728216|27184|916640|946661|167828|703727|992880|219343|610184|618585|23682|236132|1028064|362101|122282|61023|779646|889943|67470|94472|2090|185112|616900|172160|292262|116793|88041|804451|1209127|875197|32030|1284274|706709|556656|1132952|942622|987848|322817|878331|712120|1152260|690918|26467|921140|525216|300426|915376|59208|872080|927248|1281458|550399|677892|441618|1338206|198491|230279|960054|417264|233698|299205|1094741|219559|1033586|640191|897175|3465|101106|738468|235821|141114|259669|959806|579181|45441|130048|189613|739160|679537|1109554|998716|7222|481038|657373|1246635|1135923|640897|480357|224519|99479|105709|285093|541089|1595701|1163638|780746|615311|44694|773571|885000|943041|889131|185977|41675|610599|53774|2039942|211053|64455|1340258|494701|1134342|310963|350028|974460|223622|183536|256910|441588|1105075|858185|795144|506064|1551835|294095|1351520|113260|6417|509134|204846|1630723|395706|1534063|778142|1317847|1217686|450039|192289|552368|699658|277478|1110457|346621|334571|1072384|2044318|122539|1222198|90001|2212077|604944|158465|324987|186747|276218|1750658|946519|770845|2212099|181139|124132|1766207|162506|987422|1537784|1475985|824845|1013021|1426630|659714|1868634|1751241|295575|509837|742650|352215|77921|1509305|391288|492058|745750|613767|1029847|1949046|754233|1021395|1775078|1271187|333447|2872272|2724855|632826|85169|2072364|1626761|524807|2441673|604811|135686|63216|24224|112122|694414|1171554|8866|1467995|1259785|375471|1265352|2141795|482422|1041408|193120|416110|686157|177490|710590|1436088|3298701|3275431|1429183|1698253|117268|3578138|2271001|161040|5003|1640569|847206|3106472|3577148|2620053|228455|1022699|378070|655880|930306|828383|2846541|762343|612751|513170|949062|28080|788158|2980121|587671|17235|296484|3828872|1376240|935729|2047738|1159958|707862|897588|2695405|1470045|309079|1568920|1117826|1806981|1415369|995092|121282|4009650|4147916|4168012|465163|2660281|188731|184896|2607921|1963392|2376199|2725159|736210|1128745|1262668|252355|2278121|148796|1069792|4292588|4138246|917727|307455|1621208|1247602|2256812|310501|";
            //if (n == "UnknownGuardian" || n == "BraydenBlack" || n == "davidarcila" || n == "Profusion")
            if (AdminList.IndexOf("|" + player.ConnectUserId.Substring(4) + "|") != -1)
            {
                player.UserType = "Admin";
            }
            else if(player.UserType == "Admin")
            {
                    player.UserType = "Reg";
                    //detected hacking. 
            }
            //else if Devlini, BigEffingHammer, TheAwsomeOpossum, RTL_Shadow, ST3ALTH15, BobTheCoolGuy, wolfheat, lord_midnight, Rivaledsouls, Pimgd, Sanchex, eroge, GDRTestMod
            if (ModList.IndexOf("|" + player.ConnectUserId.Substring(4) + "|") != -1)
            {
                    player.UserType = "Mod";
            }
            else if(player.UserType == "Mod")
            {
                   player.UserType = "Reg";
                   //detected hacking. 
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
            //if (player.PlayerObject.Contains("Banned"))
            //{
                //deny user
               // return;
           // }
            Broadcast("ChatLeft", player.Id);
			
			Console.WriteLine("User left the chat " + player.Id);

		}

		// This method is called when a player sends a message into the server code
		public override void GotMessage(Player player, Message message) {
			switch(message.Type) {
				case "ChatMessage": {
                    String m = message.GetString(0);
                    String reciever = (m.IndexOf(' ') != -1) ? m.Split(' ')[1] : "";
                    if (player.Status == "Silenced" && player.ConnectUserId != "kong1138933")
                    {
                        return;
                    }
                    if (!player.CanChat)
                    {
                        return;
                    }
                    if (m.Length > 10 && m.ToUpper() == m)
                    {
                        m = m.ToLower();
                    }
                    if (m.IndexOf("/silence ") == 0 || m.IndexOf("/unsilence ") == 0)
                    {
                        if(player.UserType == "Mod" || player.UserType == "Admin")
                        {
                            foreach (Player p in Players)
                            {
                                if (p.UserName == reciever)
                                {
                                    //p.Send("ChatMessage", player.Id, m);
                                    if (m.IndexOf("/silence ") == 0)
                                    {
                                        p.Status = "Silenced";
                                    }
                                    else
                                    {
                                        p.Status = "AFK";
                                    }
                                    break;
                                }
                            }
                        }
                        else //deny silence
                        {
                            return;
                        }
                    }
                    if (m.IndexOf("/kickAll") == 0)
                    {
                        if (player.ConnectUserId == "kong1138933")//player.UserName == "UnknownGuardian")
                        {
                            Broadcast("ChatMessage", player.Id, m);
                            foreach (Player p in Players)
                            {
                                p.Disconnect();
                            }
                        }
                        return;
                    }
                    if (m.IndexOf("/kick ") == 0)
                    {
                        if (player.ConnectUserId == "kong1138933" || player.ConnectUserId == "kong3506166" || player.ConnectUserId == "kong610184" || player.ConnectUserId == "kong883866")//player.UserName == "UnknownGuardian")  //"kong3506166","kong610184","kong883866"
                        {
                            Broadcast("ChatMessage", player.Id, m);
                            foreach (Player p in Players)
                            {
                                if (p.UserName == reciever)
                                {
                                    p.Disconnect();
                                }
                            }
                        }
                        return;
                    }
                    if (m.IndexOf("/ban ") == 0)
                    {
                        if (player.ConnectUserId == "kong1138933" || player.ConnectUserId == "kong3506166" || player.ConnectUserId == "kong610184" || player.ConnectUserId == "kong883866")//player.UserName == "UnknownGuardian")  //"kong3506166","kong610184","kong883866"
                        //if (player.ConnectUserId == "kong1138933")//player.UserName == "UnknownGuardian")
                        {
                            foreach (Player p in Players)
                            {
                                if (p.UserName == reciever)
                                {
                                    p.Send("ChatMessage", player.Id, m);
                                    p.PlayerObject.Set("Banned", true);
                                    p.PlayerObject.Save();
                                    p.Disconnect();
                                }
                            }
                        }
                        else //unknownguardian did not send the ban
                        {
                            return;
                        }
                    }
                    if (m.IndexOf("/say ") == 0 && player.ConnectUserId != "kong1138933")
                    {
                        return;
                    }
                    if (m.IndexOf("/secret ") == 0)
                    {
                        if (player.ConnectUserId == "kong1138933") //not ug
                        {
                            foreach (Player p in Players) //loop through players
                            {
                                if (p.UserName == reciever) //reciever is player we are targetting
                                {
                                    player.Send("ChatMessage", p.Id, "Alts = " + p.SecretInfo); //send message from target to requester
                                    return;
                                }
                            }
                        }
                    }
                    if (m.IndexOf("/w ") == 0)
                    {
                        foreach (Player p in Players)
                        {
                            if (p.ConnectUserId == "kong1138933" || p.UserName == reciever || p == player)
                            {
                                p.Send("ChatMessage",player.Id,m);
                            }
                        }
                        //player.Send("ChatMessage", player.Id, m); //send message back to user who sent so they can see what they sent
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
                    player.CanChat = false;
					Broadcast("ChatMessage", player.Id, m);
					break;
				}
                case "Time": {
                    if (!player.CanPostTime)
                    {
                        return;
                    }
                    int time = player.PlayerObject.GetInt("Time") + 5;
                    player.PlayerObject.Set("Time", time);
                    player.PlayerObject.Save();
                    Message m = Message.Create("TimeReply");
                    m.Add(time);
                    player.Send(m);
                    player.CanPostTime = false;
                    break;
                }
                case "PollResponse": {
                    //Broadcast(message);
                    //Broadcast("PollResponse", player.UserName, message.GetString(1));
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