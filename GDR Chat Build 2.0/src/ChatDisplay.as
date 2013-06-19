package  //original
{
	import com.adobe.serialization.json.JSON;
	import fastswf.FastSwfManager;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.net.navigateToURL;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import playerio.DatabaseObject;
	import playerio.Message;
	import playerio.PlayerIOError;
	import ugLabs.net.Kong;
	import ugLabs.net.SaveSystem;
	import ugLabs.util.StringUtil;
	import senekis.MediaHandler;
	import senekis.MediaEvent;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class ChatDisplay extends Sprite
	{
		public var chatBox:TextArea;
		private var tempScroll:Number;
		public var muteButton:MuteSoundToggle;
		public var inputBox:TextInput;
		public var tabCode:Psycode;// TabCode;
		public var tabLinks:LinksTab;
		public var tabMedia:MediaHandler;
		public var userProfilePanel:ProfilePanel;
		public var fastSwf:FastSwfManager;
		public var soundMuted:int = 0; // 0  = all, 1 == name, 2 == none
		//private var userIsSilenced:Boolean = false;
		private var userLostFocus:Boolean = false;
		private var timeOfLastMessage:int = 0;
		private var minMessageInverval:int = 1250;
		
		
		
		
		
		private var poll:Poll;
		private var pollColor:String = "#00CC33";
		private var gotFirstHistory:Boolean = false;
		
		
		
		public function ChatDisplay() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event ):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if (SaveSystem.getCurrentSlot() == null)
			{
				SaveSystem.createOrLoadSlots(["GDR_SaveSystem"]);
				SaveSystem.openSlot("GDR_SaveSystem");
				Main.chatDisplay = this;
			}
			
			
			createUserList();
			createLinksList();
			createChatBox();
			createBorders();
			createHeader();
			createTabs();
			addFocusEvents();
			KongChat.init();
		}
		
		public function createUserList():void
		{
			var b:BackUserList = new BackUserList();
			b.x = 5;
			b.y = 6;
			addChild(b);
			
			Main.playerList = new PlayerList();
			Main.playerList.x = 5;
			Main.playerList.y = 6;
			addChild(Main.playerList);
		}
		public function createLinksList():void
		{			
			userProfilePanel = new ProfilePanel();
			userProfilePanel.x = 460;
			userProfilePanel.y = 100;
			addChild(userProfilePanel);
			
			fastSwf = new FastSwfManager();
			fastSwf.x = 589;
			fastSwf.y = 100;
			addChild(fastSwf);
			
		}
		public function createChatBox():void
		{
			var b:BackText = new BackText();
			b.x = 5;
			b.y = 169;
			addChild(b);
			
			inputBox = new TextInput();
			inputBox.editable = true;
			inputBox.x = b.x;
			inputBox.y = b.y + b.height - inputBox.height;
			inputBox.width = b.width;
			inputBox.drawFocus(false);
			inputBox.addEventListener(KeyboardEvent.KEY_DOWN, kDown);
			addChild(inputBox);
			
			chatBox = new TextArea();
			chatBox.editable = false;
			chatBox.horizontalScrollPolicy = "off";
			chatBox.verticalScrollPolicy = "on";
			chatBox.wordWrap = true;
			chatBox.setStyle("textFormat", new TextFormat("Arial", 13));
			chatBox.x = b.x;
			chatBox.y = b.y;
			chatBox.width = b.width;
			chatBox.height = b.height - inputBox.height;
			chatBox.addEventListener(TextEvent.LINK, textLink);
			chatBox.addEventListener(FocusEvent.FOCUS_OUT, changeFocus,false,9001);
			chatBox.addEventListener(FocusEvent.FOCUS_OUT, changeFocusAgain, false, -9001);
			chatBox.drawFocus(false);
			addChild(chatBox);
			
			muteButton = new MuteSoundToggle();
			muteButton.x = 630;
			muteButton.y = 525;
			addChild(muteButton);
		}
		public function createBorders():void
		{
			var d:Divider = new Divider();
			d.x = -2;
			d.y = 161;
			addChild(d);
		}
		public function createHeader():void
		{
			var profusionLogo:ProfusionLogoBtn = new ProfusionLogoBtn();
			profusionLogo.x = 573;
			profusionLogo.y = 24;
			addChild(profusionLogo);
			profusionLogo.addEventListener(MouseEvent.CLICK, clickProfusionLogo);
			
			var gdrLogo:GDRLogo = new GDRLogo();
			gdrLogo.x = 446;
			gdrLogo.y = 24;
			addChild(gdrLogo);
			
			var playTimer:PlayTimer = new PlayTimer();
			playTimer.x = 342;
			playTimer.y = 24;
			addChild(playTimer);
		}
		public function createTabs():void
		{
			tabLinks = new LinksTab();
			tabLinks.x = stage.stageWidth;
			addChild(tabLinks);
			
			tabCode = new Psycode()//TabCode();
			tabCode.x = stage.stageWidth;
			addChild(tabCode);
			
			tabMedia=new MediaHandler;
			tabMedia.x=stage.stageWidth;
			addChild(tabMedia);		
			tabMedia.addEventListener(MediaEvent.SHARE,shareMedia);
			
			var link:LinksTabIcon = new LinksTabIcon();
			link.x = 633;
			link.y = 226;
			addChild(link);
			link.addEventListener(MouseEvent.CLICK, openLinkTab);
			
			var code:CodeBoxIcon = new CodeBoxIcon();
			code.x = 633;
			code.y = 335;
			addChild(code);
			code.addEventListener(MouseEvent.CLICK, openCodeTab);
			
			var media:MediaTabIcon = new MediaTabIcon();
			media.x = 633;
			media.y = 444;
			addChild(media);
			media.addEventListener(MouseEvent.CLICK, openMediaTab);
			
		}
		
		private function shareMedia(e:MediaEvent):void{
			var m:String;
			if(e.mode=="swf")m="1";
			else if(e.mode==".png")m="2";
			else if(e.mode==".jpg")m="3";
			else if(e.mode==".bmp")m="4";
			else if(e.mode==".gif")m="5";
			inputBox.text+="codeM"+m+tabMedia.url.substring(tabMedia.url.lastIndexOf("/")+1,tabMedia.url.lastIndexOf("."));
		}
		
		public function addFocusEvents():void
		{
			stage.addEventListener(Event.ACTIVATE, gainedFocus);
			stage.addEventListener(Event.DEACTIVATE, lostFocus);
		}
		
		
		
		
		//*********************************
		//*  client and server functions  *
		//*********************************
		public function onInit(m:Message, id:String):void
		{
			playerCreateHelper(m, id, 1);
			//handle user scroll box
			/////////////userManager.onInit(m, id);	
			/*var p:Player;
			//for ( var a:int = 1; a < m.length; a += 5)
			for (var a:int = m.length-m.length%5; a>=1; a-=5)
			{
				var _id:String = m.getString(a);
				var _name:String = m.getString(a+1);
				var _type:String = m.getString(a + 2);
				var _color:String = m.getString(a + 3);
				var _status:String = m.getString(a + 4);
				p = new Player(_id, _name, _type, _color, _status);
				Main.playerList.addPlayer(p);
				//////////////addUser(m.getString(a), m.getString(a + 1), m.getString(a + 2), m.getString(a + 3), m.getString(a + 4))
			}*/
			
			
			trace("[ChatDisplay][onInit] m = " + m + ", id = " + id);
			
			if (chatBox.htmlText.length < 100)
			{
				if (SaveSystem.getCurrentSlot().read("SeenIntro") == undefined)
					displayMessage('<font color="#CC0033">[Profusion Dev Team] Welcome to the Game Developer Chat Room. If you want to know about how to make games or ask questions to developers you are in the right place! If you are here to annoy other users, please save yourself the trouble. Some helpful links can be found in the top right corner. Enjoy your stay, '  + Kong.userName + ".</font>");
					SaveSystem.getCurrentSlot().write("SeenIntro", true);
					SaveSystem.saveCurrentSlot();
				//displayMessage('<font color="#CC0033" size="12">[Profusion Dev Team] Send Code Box Data by just pasting the short-link generated after clicking \"Post Code\"</font>');
				if (Main.roomName == Main.regRoomName)
				Main.chatDisplay.displayEvent("joinRoom", "Regular");
			else if (Main.roomName == Main.collabRoomName)
				Main.chatDisplay.displayEvent("joinRoom","Collabs");
			}
		}
		public function playerCreateHelper(m:Message, id:String, a:int):void
		{
			if (a >= m.length)
			{
				trace("[playerCreateHelper] Base Case",a," ",m.length);
				return;
			}
			playerCreateHelper(m, id, a + 5);
			trace("[playerCreateHelper] a =",a,"==");
			var _id:String = m.getString(a);
			var _name:String = m.getString(a+1);
			var _type:String = m.getString(a + 2);
			var _color:String = m.getString(a + 3);
			var _status:String = m.getString(a + 4);
			var p:Player = new Player(_id, _name, _type, _color, _status);
			trace("[playerCreateHelper] a =",a,"name = ",_name);
			Main.playerList.addPlayer(p);
			
			if (_name == Kong.userName)
			{
				//this is you
				if (_type == "Mod" || _type == "Admin") minMessageInverval = 402;
				if (_type == "Dev") minMessageInverval = 1202;
			}
		}
		public function onHistoryMessage(m:Message = null, message:String = ""):void
		{
			if (gotFirstHistory == true) return;
			gotFirstHistory = true;
			trace("message Dump " + m.toString());
			var stringDump:String = "";
			for (var i:int = 0; i < m.length; i+=3)
			{
				
				
				/*stringDump += getHistoryTimeStamp(Date.parse(m.getString(i)));*/
				/*stringDump += m.getString(i) + " ";*/
				stringDump += " <b>[" + m.getString(i+1) + "]</b> ";
				stringDump += m.getString(i + 2) + "\n";
			}
			displayMessage("Recent Chat History:\n" + stringDump);
		}
		public function onJoin(m:Message, id:String, name:String, type:String, color:String, status:String):void
		{
			//handle user scroll box
			trace("[ChatDisplay][onJoin] m = " + m + ", id = " + id + ", name = " + name + ", type = " + type +", color = " + color + ", status = " + status);
			///////////////userManager.onJoin(m, id, name, type, color, status);
			if (Main.playerList.getPlayerFromID(id) == null)
			{
				var p:Player = new Player(id, name, type, color, status);
				Main.playerList.addPlayer(p);
				displayEvent("join", name);
			}
			else
			{
				trace("[ChatDisplay][onJoin] Duplicate player found");
			}
		}
		public function onLeave(m:Message, id:String):void
		{
			trace("[ChatDisplay][onLeave] m = " + m + ", id = " + id);
			displayEvent("leave", getUserNameFromId(id));
			Main.playerList.removePlayerFromID(id);
			/////////////userManager.onLeave(m, id);
		}
		public function sendMessage(m:String):void
		{
			trace("[ChatDisplay][sendMessage] m = " + m);
			if (Main.playerList.getPlayerFromName(Kong.userName).Status == "Silenced" && Kong.userName != "UnknownGuardian") //don't send if silenced
			{
				inputBox.text = "You cannot chat while silenced";
				return;
			}
			if (getTimer() - timeOfLastMessage < minMessageInverval) //don't send if chatting too fast
			{
				return;
			}
			
			inputBox.text = ""; //clear since message is approved, and will continue
			
			//m = StringUtil.neutralizeHTML(m); //remove any html in the string
			
			switch(m.toLowerCase()) //to handle any special message cases
			{
				case "/clear":
					chatBox.htmlText = "";
					displayEvent("clear","");
					return;
				case "/explain":
				case "/myrevenue":
				case "/mykredrevenue":
				case "/myinfo":
					displayEvent("useTab","");
					//displayMessage('<font size="12"><font color="#CC0033"><b>[' + "GDR" + ']</b></font> ' + "Type this command in the Match tab on the right. -->" + '</font>');
					return;
				case "/afk":
					//displayEvent("toAFK","");
				case "/back":
					//displayEvent("backAFK","");
				/*case "/show":
					chatBox.htmlText = hiddenMessages + chatBox.htmlText;
					hiddenMessages = "";
					numMessagesHidden = 0;
					return;
					*/
			}
			
			if (m.indexOf("/unicorn") == 0) //unicorn
			{
				displayMessage('<font color="#CC0033"><b>[' + "Unicorn" + ']</b></font> ' + "Believe!");
				Kong.stats.submit("UnicornsBelievedIn", 1);
				return;
			}
			if (m.indexOf("/unicron") == 0) //unicron
			{
				displayMessage('<font color="#CC0033"><b>[' + "Unicorn" + ']</b></font> imma firin mah unicron!');
				Kong.stats.submit("UnicronsBelievedIn", 1);
				return;
			}
			if (m.indexOf("/debug") == 0) //debug
			{
				KongChat.init();
				return;
			}
			if (m.indexOf("/dev") == 0) //debug
			{
				displayMessage('<font color="#CC0033"><b>[System]</b></font> Use the Match Tab to get your token. -->');
				return;
			}
			if (m.indexOf("/todo ") == 0)
			{
				var words:Array = m.split(" ");
				words.splice(0, 1);
				Kong.services.privateMessage( {
					content:("//TODO: " + words.join(" "))
				});
				displayMessage('<font color="#CC0033"><b>[System]</b></font> Added to your todo list.');
				return;
			}
			if (m.indexOf("/vote") == 0)
			{
				if (!(isUserMod(Kong.userName) || isUserAdmin(Kong.userName)))
				{
					displayMessage('<font color="'+pollColor+'"><b>[' + "Vote" + ']</b></font> ' + "Only mods and admins can start polls");
					return;
				}
				if (poll)
				{
					displayMessage('<font color="'+pollColor+'"><b>[' + "Vote" + ']</b></font> ' + "You already have a poll in progress");
					return;
				}
				var newPoll:Poll = Poll.parsePoll(m);
				if (newPoll == null)
				{
					displayMessage('<font color="'+pollColor+'"><b>[' + "Vote" + ']</b></font> ' + "Invalid Poll");
					return;
				}
				else
				{
					poll = newPoll;
					Main.connection.send("ChatMessage", "/vote"+poll.getMessage());
				}
				return;
			}
			if (m.indexOf("/endVote") == 0)
			{
				if (poll)
				{
					Main.connection.send("ChatMessage", "/vote"+poll.getResult());
					poll = null;
					return;
				}
				else
				{
					displayMessage('<font color="' + pollColor + '"><b>[' + "Vote" + ']</b></font> ' + "No poll is running");
					return;
				}
			}
			if (m.indexOf("/silence ") == 0 && !(isUserMod(Kong.userName) || isUserAdmin(Kong.userName))) //if a non mod tries to silence
			{
				return;
			}
			if (m.indexOf("/unsilence ") == 0 && !(isUserMod(Kong.userName) || isUserAdmin(Kong.userName))) //if a non mod tries to silence
			{
				return;
			}
			if (m.indexOf("/ban ") == 0 && !isUserAdmin(Kong.userName)) //if a non admin tries to silence
			{
				return;
			}
			if (m.indexOf("/setColor") == 0 && !(isUserAdmin(Kong.userName)||isUserMod(Kong.userName)))// && m.length == 18 && PlayTimer.minutesTime < 2000) //changing a color.
			{
				return;
			}
			if (m.indexOf("/say ") == 0 && !isUserAdmin(Kong.userName)) //if a non admin tries to silence
			{
				return;
			}
			
			if (m.indexOf("/id ") == 0)
			{
				Kong.getJSONFor(m.split(" ")[1],traceUserData);
			}
			if (m.indexOf("/id2 ") == 0)
			{
				Kong.getJSONForID(m.split(" ")[1],traceUserData);
			}
			
			
			/*if (m.indexOf("/del") == 0 && isUserAdmin(Kong.userName))
			{
				for (var r:int = 0; r < 1;r+=5)
					Main.client.bigDB.deleteRange("PlayerObjects", "TimeSort",[r], 0, 150, deleteSuccess, deleteFailure);
			}*/
			
			if (m.indexOf("/join gdr") == 0 && Main.roomName == Main.regRoomName)
			{
				return;
			}
			if (m.indexOf("/join collab") == 0 && Main.roomName == Main.collabRoomName)
			{
				return;
			}
			if (m.indexOf("/join collab") == 0 || m.indexOf("/join gdr") == 0)
			{
				if ((Main.playerList.getPlayerFromName(Kong.userName).isCollaborator || isUserMod(Kong.userName) || isUserAdmin(Kong.userName)) && !PlayTimer.isTransferingRooms)
				{
					PlayTimer.swapRoomsStayConnected();
				}
				return;
			}
			
			if(m.length > 500)//trim message to 500 chars max
			{
				m = m.substring(0,500);
			}
			if (m.search(/\S/) == -1 || m == "v") //check for basic spam
			{
				return;
			}
			
			if(!Main.connection.connected)
			{
				displayMessage('<font color="#FF0000">[System]</font> It seems you are not connected. Please wait for GDR to establish a new connection. If GDR is unable to reconnect, please refresh.');
				return;
			}
			
			timeOfLastMessage = getTimer();
			Main.connection.send("ChatMessage", m)
		}
		
		private function deleteSuccess(o:DatabaseObject = null):void 
		{
			displayMessage('<font color="#FF0000">[Query]</font> Dumped User Indexes' + o);
		}
		private function deleteFailure(e:PlayerIOError):void 
		{
			displayMessage('<font color="#FF0000">[Query]</font> ' + e.message);
		}
		
		private function traceUserData(e:Event):void 
		{
			var load:URLLoader = URLLoader(e.target);
			var playerData:Object = com.adobe.serialization.json.JSON.decode(load.data);
			
			if(playerData.success)
			{
				displayMessage('<font color="#FF0000">[Query]</font> User Data Retrieved: Name: ' + playerData.username + "  Id: " + playerData.user_id);
			}
			
			return;
		}
		
		
		
		public function onMessage(m:Message = null, id:String = "", message:String = ""):void
		{
			trace("[ChatDisplay][onMessage] m = " + m + ", id = " + id + ", message = " + message);
			try 
			{
				var words:Array;
				trace("[onMessage] @1");
				if (message.indexOf("/silence ") == 0) //silencing a user. 3 cases. 1) Silence this. 2) Display silence.
				{
					trace("[onMessage] @2");
					if (message.indexOf("/silence " + Kong.userName) == 0)
					{
						Main.playerList.getPlayerFromName(Kong.userName).silenceMessageEvent("silence");
						displayEvent("silenced", "You are", Main.playerList.getPlayerFromID(id).UserName);
						//userIsSilenced = true;
					}
					else
					{
						trace("[onMessage] @3");
						words = message.split(" ", 2); //split the message with spaces
						var p1:Player = Main.playerList.getPlayerFromName(words[1]);
						if (p1 == null) return;
						p1.silenceMessageEvent("silence");
						displayEvent("silenced", words[1], Main.playerList.getPlayerFromID(id).UserName); //use second space delimit to grab username. Always will exist, since checked on sender side
					}
					return;
				}
				
				trace("[onMessage] @4");
				if (message.indexOf("/unsilence ") == 0) //silencing a user. 2 cases. 1) Silence this. 2) Display silence.
				{
					if (message.indexOf("/unsilence " + Kong.userName) == 0)
					{
						//userIsSilenced = false;
						displayEvent("unsilenced", "You are", Main.playerList.getPlayerFromID(id).UserName);
						Main.playerList.getPlayerFromName(Kong.userName).silenceMessageEvent("unsilence");
					}
					else
					{
						words = message.split(" ", 2); //split the message with spaces
						var p:Player = Main.playerList.getPlayerFromName(words[1]);
						if (p == null) return;
						p.silenceMessageEvent("unsilence");
						displayEvent("unsilenced", words[1], Main.playerList.getPlayerFromID(id).UserName); //use second space delimit to grab username. Always will exist, since checked on sender side
					}
					return;
				}
				
				if ((message.indexOf("/kickAll") == 0) && isUserAdmin(getUserNameFromId(id)))
				{
					//TODO Stop reconnection timer
					PlayTimer.stopReconnection();
					Main.connection.disconnect();
					displayMessage('<font color="#FF0000">[System]</font> System has been forced to disconnect you. Please refresh.</font>');
					//displayMessage('<font color="#FF0000" size="13">[System]</font> It seems you are not connected. Please wait for GDR to establish a new connection. If GDR is unable to reconnect, please refresh.');
					return;
				}
				
				if ((message.indexOf("/kick " + Kong.userName) == 0))
				{
					//TODO Stop reconnection timer
					PlayTimer.stopReconnection();
					Main.connection.disconnect();
					displayMessage('<font color="#FF0000">[System]</font> System has been forced to disconnect you. Please refresh.</font>');
					//displayMessage('<font color="#FF0000" size="13">[System]</font> It seems you are not connected. Please wait for GDR to establish a new connection. If GDR is unable to reconnect, please refresh.');
					return;
				}
				else if ((message.indexOf("/kick ") == 0))// && (getUserNameFromId(id) == "UnknownGuardian"))
				{
					words = message.split(" ", 2); //split the message with spaces
					displayEvent("kicked", words[1], getUserNameFromId(id)); //use second space delimit to grab username. Always will exist, since checked on sender side
					return;
				}
				
				
				if (message.indexOf("/ban") == 0) //banning a user. 1) Bans this. 2) Display Ban.
				{
					if (message.indexOf("/ban " + Kong.userName) == 0)
					{
						Main.playerList.getPlayerFromName(Kong.userName).silenceMessageEvent("silence");
						//userIsSilenced = true;
						PlayTimer.stopReconnection();
						Main.connection.disconnect();
						displayMessage('<font color="#FF0000">[System]</font> Account Permabanned</font>');
						banUser();
					}
					else
					{
						words = message.split(" ", 2); //split the message with spaces
						displayEvent("banned", words[1], Main.playerList.getPlayerFromID(id).UserName); //use second space delimit to grab username. Always will exist, since checked on sender side
					}
					return;
				}
				
				
				
				if (message.indexOf("/vote") == 0)
				{
					message = message.substr(5);
					var lines:Array = message.split('|/|'); //use this symbol as a new line
					for (var i:int = 0; i < lines.length; i++)
					{
						if(lines[i].length > 0)
							displayMessage('<font color="'+pollColor+'"><b>[<a href=\"event:@name' + getUserNameFromId(id) + '">Vote</a>]</b></font> ' + lines[i]);
					}
					return;
				}
				
				if (message.indexOf("/setColor") == 0  && (isUserMod(getUserNameFromId(id)) || isUserAdmin(getUserNameFromId(id)))) //changing a color.
				{
					words = message.split(" "); //split the message with spaces
					if(words.length == 2)
						Main.playerList.getPlayerFromID(id).setColor(words[1]);
					else if (words.length == 3)
						Main.playerList.getPlayerFromName(words[1]).setColor(words[2]);
					else if (words.length > 3)
					{
						for (var y:int = 1; y < words.length - 1; y++)
						{
							Main.playerList.getPlayerFromName(words[y]).setColor(words[words.length-1]);
						}
					}
					//TODO setColor
					//example: userbox.setColor(id, words[1]);
					return;
				}
				
				if (message.indexOf("/say ") == 0)
				{
					words = message.split(" "); //split the message with spaces
					var fakeName:Player = Main.playerList.getPlayerFromName(words[1]);
					if (fakeName == null) return;
					id = fakeName.ID;
					message = words.slice(2).join(" ");
				}
				
				if(message.indexOf("codeD") != -1) //code link
				{
					words = message.split(" ");
					for (var q:int = 0; q < words.length; q++)
					{
						if (words[q].indexOf("codeD") == 0) //grab any codeD's on the line. Could be more than 1.
						{
							words[q] = '<b><i><font color="#0078FF"><a href=\"event:' + words[q].split('"').join("") + '">' + words[q].split('"').join("") + '</a></font></i></b>';
						}
					}
					message = words.join(" ");
				}
				
				if(message.indexOf("codeM") != -1) 
				{
					words = message.split(" ");
					for (var cm:int = 0; cm < words.length; cm++)
					{
						if (words[cm].indexOf("codeM") == 0) 
						{
							words[cm] = '<b><i><font color="#0078FF"><a href=\"event:' + words[cm].split('"').join("") + '">' + words[cm].split('"').join("") + '</a></font></i></b>';
						}
					}
					message = words.join(" ");
				}
				
				if (message.indexOf("http") != -1 || message.indexOf("www.") != -1)
				{
					words = message.split(" ");
					for (var j:int = 0; j < words.length; j++)
					{
						if (words[j].indexOf("http://") == 0 || words[j].indexOf("www.") == 0 || words[j].indexOf("https://") == 0) //grab any codeD's on the line. Could be more than 1.
						{
							words[j] = '<font color="#0000FF"><a href=\"event:' + words[j].split('"').join("") + '">' + words[j].split('"').join("") + '</a></font>';
						}
					}
					message = words.join(" ");
				}
				
				if (message.indexOf("/w ") == 0) //private messages 4 cases. 1) Sending to you. 2)From you. 3)For UnknownGuardian 4)What everyone else should see
				{
					words = message.split(" ", 2);
					var restOfMessage:String = message.substr(message.indexOf(words[1]) + words[1].length);
					if (words[1].toLowerCase() == Kong.userName.toLowerCase())
					{
						message = '<font color="#0098FFF">[PM]' + restOfMessage + ' (<font color="#CC0033"><u><a href=\"event:@reply' + getUserNameFromId(id) + '">reply</a></u></font>)</font>';
					}
					else if (getUserNameFromId(id) == Kong.userName)
					{
						message = '<font color="#0098FFF">[PM to ' + words[1] + "] " +  restOfMessage + '</font>';
					}
					else
					{
						return;
					}
				}
				
				
				if(message.indexOf("/system") == 0) //code link
				{
					words = message.split(" ", 2);
					var restOfMessage2:String = message.substr(message.indexOf(words[0]) + words[0].length + 1);
					if (restOfMessage2 == "restart") restOfMessage2 = "Server restarting. Standby for reconnection in 180 seconds";
					displayMessage('<b><font color="#FF0000">[<a href=\"event:@nameSystem">System</a>]</font> ' + restOfMessage2 + '</b>');
					return;
				}
				
				if (message.indexOf("/afk") == 0)
				{
					Main.playerList.getPlayerFromID(id).setToAFK();
					return;
				}
				if (message.indexOf("/help") == 0)
				{
					Main.playerList.getPlayerFromID(id).setToHelp();
				}
				if (message.indexOf("/norm") == 0)
				{
					Main.playerList.getPlayerFromID(id).setToBack();
				}
				if (message.indexOf("/back") == 0)
				{
					Main.playerList.getPlayerFromID(id).setToBack();
					return;
				}
				
				if (Main.playerList.getPlayerFromID(id).Status == "AFK") //sending a message from an AFK status
				{
					Main.playerList.getPlayerFromID(id).setToBack();
				}
				
				if (Main.playerList.getPlayerFromID(id).isMuted) return;
				
				
				
				var messageContainsNick:Boolean = false;
				var tehPlayer:Player = Main.playerList.getPlayerFromName(Kong.userName);
				for (var r:int = 0; r < tehPlayer.nicks.length; r++)
				{
					//KongChat.log("Testing nick " + tehPlayer.nicks[r]);
					if (message.indexOf(tehPlayer.nicks[r]) != -1)
					{
						messageContainsNick = true;
						//break;
					}
				}
				//KongChat.log("Message contained Nick: " + messageContainsNick + " when nicks are " + tehPlayer.nicks.join(","));
				if ((soundMuted == 0 && userLostFocus) || (messageContainsNick && soundMuted == 1) || Main.playerList.getPlayerFromID(id).beepWhenMessageFrom)
				{
					var beep:Sound = new MessageSound();
					beep.play();
				}
				
				//Check if message is a vote for this user's poll
				if (poll)
				{
					poll.checkVote(message,id);
				}
				
				if (Main.playerList.getPlayerFromID(id).isBold)
					message = "<b>" + message + "</b>";
				
				trace("[onMessage] Final Message: " + message, id, getUserNameFromId(id) );
				//displayMessage('<font color="#' + /*000000*/ Main.playerList.getPlayerFromID(id).Color.substr(2) + '" size="13"><b>[<a href=\"event:@name' + getUserNameFromId(id) + '">' + getUserNameFromId(id) + '</a>]</b> ' + message + '</font>'); //display the message
				displayMessage('<font color="#' + /*000000*/ Main.playerList.getPlayerFromID(id).getColor().substr(2) + '"><b>[<a href=\"event:@name' + getUserNameFromId(id) + '">' + getUserNameFromId(id) + '</a>]</b></font> ' + message); //display the message
				
			} 
			catch (e:Error)
			{
				trace("[onMessage] Error: " + e);
				displayMessage('<font color="#FF00FF"><b>[<a href=\"event:@nameERROR_CAUGHT">ERROR_CAUGHT</a>]</b></font> ' + e); //display the message
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		//********************************
		//*  client side only functions  *
		//********************************
		//credit to skyboy
		public function displayMessage(message:String):void {
			trace("[displayMessage()] Message = " + message);
			var pos:Number = chatBox.verticalScrollPosition;
			var snap:Boolean = (chatBox.maxVerticalScrollPosition - pos < 2)
			chatBox.htmlText += getTimeStamp() +  message;
			if (snap) {
				chatBox.verticalScrollPosition = chatBox.maxVerticalScrollPosition;
			} else {
				chatBox.verticalScrollPosition = pos;
			}
		}
		public function displayEvent(type:String, n:String, otherN:String = ""):void
		{
			switch(type)
			{
				case "join":
					if (n == "RikkiG") return;
					displayMessage('<font color="#C0C0C0" size="12">[' + n + " joined GDR]</font>");
					break;
				case "leave":
					if (n == "RikkiG") return;
					displayMessage('<font color="#C0C0C0" size="12">[' + n + " left GDR]</font>");
					break;
				case "silenced":
					displayMessage('<font color="#C0C0C0" size="12">[' + n + " silenced by " + otherN +  "]</font>");
					break;
				case "unsilenced":
					displayMessage('<font color="#C0C0C0" size="12">[' + n + " unsilenced by " + otherN +  "]</font>");
					break;
				case "banned":
					displayMessage('<font color="#C0C0C0" size="12">[' + n + " banned by " + otherN +  "]</font>");
					break;
				case "kicked":
					displayMessage('<font color="#C0C0C0" size="12">[' + n + " kicked by " + otherN +  "]</font>");
					break;
				case "toAFK":
					displayMessage('<font color="#C0C0C0" size="12">[Status: AFK]</font>');
					break;
				case "backAFK":
					displayMessage('<font color="#C0C0C0" size="12">[Status: BACK]</font>');
					break;
				case "muteSound":
					displayMessage('<font color="#C0C0C0" size="12">[Sound Off]</font>');
					break;
				case "unmuteSound":
					displayMessage('<font color="#C0C0C0" size="12">[Sound On]</font>');
					break;
				case "useTab":
					displayMessage('<font color="#C0C0C0" size="12">[Use this command in the Match Tab]</font>');
					break;
				case "clear":
					displayMessage('<font color="#C0C0C0" size="12">[Messages Cleared]</font>');
					break;
				case "disconnect":
					displayMessage('<font color="#FF0000" size="12">[You are disconnected. GDR is attempting to reconnect]</font>');
					break;
				case "reconnect":
					displayMessage('<font color="#FF0000" size="12">[Reconnection Successful]</font>');
					break;
				case "roomTransfer":
					displayMessage('<font color="#FF0000" size="12">[Transfering Rooms]</font>');
					break;
				case "joinRoom":
					displayMessage('<font color="#FF0000" size="12">[Joined Room: ' + n + ']</font>');
					break;
				default:
					break;
			}
		}
		public function textLink(e:TextEvent):void
		{
			if (e.text.indexOf("codeD") != -1)
			{			
				tabCode.setLoadField(e.text);//tabCode.loadField.text = e.text;
				tabCode.bottomBar.loadCode(null);
				
				//var p:PasteBin = PasteBin(stage.getChildByName("PasteBin"));
				//p.loadField.text = e.text;
				//p.loadCode(null);
			}
			else if(e.text.indexOf("codeM")!=-1)
			{
				if(!tabMedia.isExpanded)tabMedia.handleLabelClick();
				tabMedia.loadURL(e.text);
			}
			else if ( e.text.indexOf("@name") != -1)
			{
				inputBox.appendText( e.text.substring(e.text.indexOf("@name") + 5) + " ");
				inputBox.setFocus();
				inputBox.setSelection(inputBox.text.length, inputBox.text.length);
			}
			else if (e.text.indexOf("@reply") != -1)
			{
				inputBox.appendText("/w " + e.text.substring(e.text.indexOf("@reply") + 6) + " ");
				inputBox.setFocus();
				inputBox.setSelection(inputBox.text.length, inputBox.text.length);
			}
			else if (e.text.indexOf("http://") != -1)
			{
				navigateToURL( new URLRequest(e.text));
			}
			else if (e.text.indexOf("https://") != -1)
			{
				navigateToURL( new URLRequest(e.text));
			}
			else if(e.text.indexOf("www.") == 0)
			{
				navigateToURL( new URLRequest("http://" + e.text));
			}
		}
		public function kDown(e:KeyboardEvent):void
		{
			if (e.keyCode == 13) //enter
			{
				sendMessage(inputBox.text);
			}
		}
		
		
		
		
		
		
		//utility
		public function clickProfusionLogo(e:MouseEvent):void {
			navigateToURL(new URLRequest("http://profusiongames.com/"), "_blank");
		}
		public function clickProfusionIcon(e:MouseEvent):void {
			navigateToURL(new URLRequest("http://www.kongregate.com/accounts/UnknownGuardian"), "_blank");
		}
		public function changeFocus(e:FocusEvent):void {
			tempScroll = chatBox.verticalScrollPosition;
		}
		public function changeFocusAgain(e:FocusEvent):void	{
			chatBox.verticalScrollPosition = tempScroll;
		}
		public function gainedFocus(e:Event):void {
			userLostFocus = false;
		}
		public function lostFocus(e:Event):void	{
			userLostFocus = true;
		}
		public function getTimeStamp():String {
			var time:Date = new Date();
			if (time.hours > 12) //prevent modding to 0 errors
			{
				time.hours %= 12;
			}
			else if (time.hours == 0)
			{
				time.hours = 12;
			}
			var minutes:String = "" + time.minutes;
			if(time.minutes < 10)//less than 10
			{
				minutes = "0" + minutes;//add a 0 before
			}
			return "" + time.hours + ":" + minutes + " ";//format the date into "h:m"
		}
		public function getHistoryTimeStamp(ms:Number):String {
			var time:Date = new Date(ms);
			if (time.hours > 12) //prevent modding to 0 errors
			{
				time.hours %= 12;
			}
			else if (time.hours == 0)
			{
				time.hours = 12;
			}
			var minutes:String = "" + time.minutes;
			if(time.minutes < 10)//less than 10
			{
				minutes = "0" + minutes;//add a 0 before
			}
			return "" + time.hours + ":" + minutes + " ";//format the date into "h:m"
		}
		public function openLinkTab(e:MouseEvent):void {
			showTab("link");
		}
		public function openCodeTab(e:MouseEvent):void {
			showTab("code");
		}
		public function openMediaTab(e:MouseEvent):void {
			showTab("media");
		}
		public function showTab(t:String):void
		{
			if (t == "code")
			{
				tabCode.handleLabelClick();
			}
			else if (t == "link")
			{
				tabLinks.handleLabelClick();
			}
			else if (t == "media")
			{
				tabMedia.handleLabelClick();
			}
		}
		public function getUserNameFromId(id:String):String {
			trace("[getUserNameFromId()] ID = " + id);
			//return userManager.getName(id);
			var p:Player = Main.playerList.getPlayerFromID(id);
			if (p)
			{
				return p.UserName;
			}
			return "";
			//return Main.playerList.getPlayerFromID(id).UserName;
		}
		public function isUserMod(_name:String):Boolean {
			//TODO isUserMod
			//return userManager.isMod(id);
			var p:Player = Main.playerList.getPlayerFromName(_name)
			if (p)
			{
				return p.Type == "Mod";
			}
			return false;
			//return Main.playerList.getPlayerFromName(_name).Type == "Mod"
		}
		public function isUserAdmin(_name:String):Boolean {
			//TODO isUserAdmin
			//return userManager.isAdmin(id);
			var p:Player = Main.playerList.getPlayerFromName(_name)
			if (p)
			{
				return p.Type == "Admin";
			}
			return false;
			//return Main.playerList.getPlayerFromName(_name).Type == "Admin"
		}
		public function banUser():void {
			//TODO banUser();
			//Disconenct player
			
			SaveSystem.getCurrentSlot().write("banned", true);
			SaveSystem.saveCurrentSlot();
			
			
			//var s:SharedObject = SharedObject.getLocal("GDR");
			//s.data.cake = true;
			//s.flush();
		}
		
	}

}