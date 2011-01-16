package  
{
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import playerio.Message;
	import ugLabs.net.Kong;
	import ugLabs.util.StringUtil;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class ChatDisplay extends Sprite
	{
		public var chatBox:TextArea;
		private var tempScroll:Number;
		
		public var inputBox:TextInput;
		
		private var soundMuted:Boolean = false;
		//private var userIsSilenced:Boolean = false;
		private var userLostFocus:Boolean = false;
		private var timeOfLastMessage:int = 0;
		private var minMessageInverval:int = 1250;
		
		public function ChatDisplay() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event ):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			createUserList();
			createLinksList();
			createChatBox();
			//connectToPlayerIO();
			createBorders();
			createHeader();
			createTabs();
			addFocusEvents();
		}
		
		public function createUserList():void
		{
			var b:BackUserList = new BackUserList();
			b.x = 5;
			b.y = 65;
			addChild(b);
			
			Main.playerList = new PlayerList();
			Main.playerList.x = 5;
			Main.playerList.y = 65;
			addChild(Main.playerList);
		}
		public function createLinksList():void
		{
			var b:BackLinks = new BackLinks();
			b.x = 259;
			b.y = 65;
			addChild(b);
		}
		public function createChatBox():void
		{
			var b:BackText = new BackText();
			b.x = 5;
			b.y = stage.stageHeight - b.height - 5;
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
			chatBox.x = b.x;
			chatBox.y = b.y;
			chatBox.width = b.width;
			chatBox.height = b.height - inputBox.height;
			chatBox.addEventListener(TextEvent.LINK, textLink);
			chatBox.addEventListener(FocusEvent.FOCUS_OUT, changeFocus,false,9001);
			chatBox.addEventListener(FocusEvent.FOCUS_OUT, changeFocusAgain, false, -9001);
			chatBox.drawFocus(false);
			addChild(chatBox);
		}
		public function createBorders():void
		{
			var d:Divider = new Divider();
			d.x = -36;
			d.y = 223;
			addChild(d);
			
			var di:Divider = new Divider();
			di.x = 0;
			di.y = 55;
			addChild(di);
		}
		public function createHeader():void
		{
			var profusionLogo:ProfusionLogo = new ProfusionLogo();
			profusionLogo.x = 567;
			profusionLogo.y = 26;
			addChild(profusionLogo);
			profusionLogo.addEventListener(MouseEvent.CLICK, clickProfusionLogo);
			
			var gdrLogo:GDRLogo = new GDRLogo();
			gdrLogo.x = 446;
			gdrLogo.y = 26;
			addChild(gdrLogo);
			
			var profusionIcon:ProfusionIcon = new ProfusionIcon();
			profusionIcon.x = 325;
			profusionIcon.y = 26;
			addChild(profusionIcon);
			profusionIcon.addEventListener(MouseEvent.CLICK, clickProfusionIcon);
			
			var infoBackgrond:InformationBackground = new InformationBackground();
			infoBackgrond.x = 190;
			infoBackgrond.y = 27;
			addChild(infoBackgrond);
			
			var timeDisplay:TimeDisplay = new TimeDisplay();
			timeDisplay.x = 76;
			timeDisplay.y = 27;
			addChild(timeDisplay);
		}
		public function createTabs():void
		{
			var link:LinksTabIcon = new LinksTabIcon();
			link.x = 633;
			link.y = 127;
			addChild(link);
			link.addEventListener(MouseEvent.CLICK, openLinkTab);
			
			var code:CodeBoxIcon = new CodeBoxIcon();
			code.x = 633;
			code.y = 256;
			addChild(code);
			code.addEventListener(MouseEvent.CLICK, openCodeTab);
			
			var beta:BetaTabIcon = new BetaTabIcon();
			beta.x = 633;
			beta.y = 452;
			addChild(beta);
			beta.addEventListener(MouseEvent.CLICK, openBetaTab);
		}
		public function connectToPlayerIO():void
		{
			Main.connection.addMessageHandler("ChatInit", onInit)
			Main.connection.addMessageHandler("ChatJoin", onJoin);
			Main.connection.addMessageHandler("ChatLeft", onLeave);
			Main.connection.addMessageHandler("ChatMessage", onMessage)
			trace("[ChatDisplay][connectToPlayerIO] Added Init/Join/Left/Message Listeners to Connection");
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
			//handle user scroll box
			/////////////userManager.onInit(m, id);	
			var p:Player;
			for ( var a:int = 1; a < m.length; a += 5)
			{
				var _id:String = m.getString(a);
				var _name:String = m.getString(a+1);
				var _type:String = m.getString(a + 2);
				var _color:String = m.getString(a + 3);
				var _status:String = m.getString(a + 4);
				p = new Player(_id, _name, _type, _color, _status);
				Main.playerList.addPlayer(p);
				//////////////addUser(m.getString(a), m.getString(a + 1), m.getString(a + 2), m.getString(a + 3), m.getString(a + 4))
			}
			
			
			trace("[ChatDisplay][onInit] m = " + m + ", id = " + id);
			
			if (chatBox.htmlText.length < 100)
			{
				displayMessage('<font color="#CC0033" size="12">[Profusion Dev Team] Welcome to the Game Developer Chat Room. If you want to know about how to make games or ask questions to developers you are in the right place! If you are here to annoy other users, please save yourself the trouble. Some helpful links can be found in the top right corner. Enjoy your stay, '  + Kong.userName + ".</font>");
				//displayMessage('<font color="#CC0033" size="12">[Profusion Dev Team] Send Code Box Data by just pasting the short-link generated after clicking \"Post Code\"</font>');
			}
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
			if (Main.playerList.getPlayerFromName(Kong.userName).Status == "Silenced") //don't send if silenced
			{
				inputBox.text = "You cannot chat while silenced";
				return;
			}
			if (getTimer() - timeOfLastMessage < minMessageInverval) //don't send if chatting too fast
			{
				return;
			}
			
			inputBox.text = ""; //clear since message is approved, and will continue
			
			m = StringUtil.neutralizeHTML(m); //remove any html in the string
			
			switch(m.toLowerCase()) //to handle any special message cases
			{
				case "/mutesound":
					soundMuted = true;
					return;
				case "/unmutesound":
					soundMuted = false;
					return;
				case "/clear":
					chatBox.htmlText = "";
					return;
				case "/explain":
				case "/help":
				case "/myrevenue":
				case "/mykredrevenue":
				case "/myinfo":
					//displayMessage('<font size="12"><font color="#CC0033"><b>[' + "GDR" + ']</b></font> ' + "Type this command in the Match tab on the right. -->" + '</font>');
					return;
				case "/afk":
					//return;
				case "/back":
					//return;
			}
			
			if (m.indexOf("/unicorn") == 0) //unicorn
			{
				displayMessage('<font size="12"><font color="#CC0033"><b>[' + "Unicorn" + ']</b></font> ' + "Believe!" + '</font>');
				Kong.stats.submit("UnicornsBelievedIn", 1);
				return;
			}
			
			if (m.indexOf("/silenceUser ") == 0 && !(isUserMod(Kong.userName) || isUserAdmin(Kong.userName))) //if a non mod tries to silence
			{
				return;
			}
			if (m.indexOf("/unsilenceUser ") == 0 && !(isUserMod(Kong.userName) || isUserAdmin(Kong.userName))) //if a non mod tries to silence
			{
				return;
			}
			if (m.indexOf("/adminBan ") == 0 && !isUserAdmin(Kong.userName)) //if a non mod tries to silence
			{
				return;
			}
			
			if(m.length > 500)//trim message to 500 chars max
			{
				m = m.substring(0,500);
			}
			if (m == "" || m == " " || m == "  " || m == "v") //check for basic spam
			{
				return;
			}
			
			if(!Main.connection.connected)
			{
				displayMessage('<font color="#FF0000" size="12">[System]</font> It seems you are not connected. Please wait for GDR to establish a new connection. If GDR is unable to reconnect, please refresh.');
				return;
			}
			
			timeOfLastMessage = getTimer();
			Main.connection.send("ChatMessage", m)
		}
		
		public function onMessage(m:Message = null, id:String = "", message:String = ""):void
		{
			trace("[ChatDisplay][onMessage] m = " + m + ", id = " + id + ", message = " + message);
			try 
			{
				var words:Array;
				
				if (message.indexOf("/silenceUser ") == 0) //silencing a user. 3 cases. 1) Silence this. 2) Display silence. 3) Kick all.
				{
					if (message.indexOf("/silenceUser " + Kong.userName) == 0)
					{
						Main.playerList.getPlayerFromName(Kong.userName).silenceMessageEvent("silence");
						//userIsSilenced = true;
					}
					else if ((message.indexOf("/silenceUser !kickAll!") == 0) && (getUserNameFromId(id) == "UnknownGuardian"))
					{
						//TODO Stop reconnection timer
						Main.connection.disconnect();
						displayMessage('<font color="#CC0033" size="13">[System] System has been forced to disconnect you. Please refresh.</font>');
					}
					else
					{
						words = message.split(" ", 2); //split the message with spaces
						displayEvent("silenced", words[1]); //use second space delimit to grab username. Always will exist, since checked on sender side
					}
					return;
				}
				
				if (message.indexOf("/unsilenceUser ") == 0) //silencing a user. 2 cases. 1) Silence this. 2) Display silence.
				{
					if (message.indexOf("/unsilenceUser " + Kong.userName) == 0)
					{
						//userIsSilenced = false;
						Main.playerList.getPlayerFromName(Kong.userName).silenceMessageEvent("unsilence");
					}
					else
					{
						words = message.split(" ", 2); //split the message with spaces
						displayEvent("unsilenced", words[1]); //use second space delimit to grab username. Always will exist, since checked on sender side
					}
					return;
				}
				
				if (message.indexOf("/adminBan") == 0) //banning a user. 1) Bans this. 2) Display Ban.
				{
					if (message.indexOf("/adminBan " + Kong.userName) == 0)
					{
						Main.playerList.getPlayerFromName(Kong.userName).silenceMessageEvent("silence");
						//userIsSilenced = true;
						banUser();
					}
					else
					{
						words = message.split(" ", 2); //split the message with spaces
						displayEvent("banned", words[1]); //use second space delimit to grab username. Always will exist, since checked on sender side
					}
					return;
				}
				
				if (message.indexOf("/setColor") == 0) //changing a color.
				{
					words = message.split(" ", 2); //split the message with spaces
					//TODO setColor
					//example: userbox.setColor(id, words[2]);
					return;
				}
				
				if(message.indexOf("codeD") != -1) //code link
				{
					words = message.split(" ");
					for (var i:int = 0; i < words.length; i++)
					{
						if (words[i].indexOf("codeD") == 0) //grab any codeD's on the line. Could be more than 1.
						{
							words[i] = '<b><i><font color="#0078FF"><a href=\"event:' + words[i] + '">' + words[i] + '</a></font></i></b>';
						}
					}
					message = words.join(" ");
				}
				
				if (message.indexOf("http://") != -1)
				{
					words = message.split(" ");
					for (var j:int = 0; j < words.length; j++)
					{
						if (words[j].indexOf("http://") == 0 || words[j].indexOf("www.") == 0 || words[j].indexOf("https://") == 0) //grab any codeD's on the line. Could be more than 1.
						{
							words[j] = '<font color="#0000FF"><a href=\"event:' + words[j] + '">' + words[j] + '</a></font>';
						}
					}
					message = words.join(" ");
				}
				
				
				if (message.indexOf("/w ") == 0) //private messages 4 cases. 1) Sending to you. 2)From you. 3)For UnknownGuardian 4)What everyone else should see
				{
					words = message.split(" ", 2);
					var restOfMessage:String = message.substr(message.indexOf(words[1]) + words[1].length);
					if (words[1] == Kong.userName)
					{
						message = '<font color="#0098FFF">' + restOfMessage + '</font>';
					}
					else if (getUserNameFromId(id) == Kong.userName)
					{
						message = '<font color="#0098FFF">(To ' + words[1] + ") " +  restOfMessage + '</font>';
					}
					else if (getUserNameFromId(id) == "UnknownGuardian")
					{
						message = '<font color="#0098FFF">' + message + '</font>';
					}
					else
					{
						return;
					}
				}
				
				trace("[onMessage] Final Message: " + message, id, getUserNameFromId(id) );
				displayMessage('<font color="#000000" size="13"><b>[<a href=\"event:@name' + getUserNameFromId(id) + '">' + getUserNameFromId(id) + '</a>]</b> ' + message + '</font>'); //display the message
				
			} 
			catch (e:Error)
			{
				trace("[onMessage] Error: " + e);
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
		public function displayEvent(type:String, n:String):void
		{
			switch(type)
			{
				case "join":
					displayMessage('<font color="#C0C0C0" size="12">[' + n + " joined GDR]</font>");
					break;
				case "leave":
					displayMessage('<font color="#C0C0C0" size="12">[' + n + " left GDR]</font>");
					break;
				case "silenced":
					displayMessage('<font color="#C0C0C0" size="12">[' + n + " silenced]</font>");
					break;
				case "unsilenced":
					displayMessage('<font color="#C0C0C0" size="12">[' + n + " unsilenced]</font>");
					break;
				case "banned":
					displayMessage('<font color="#C0C0C0" size="12">[' + n + " banned]</font>");
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
				default:
					break;
			}
		}
		public function textLink(e:TextEvent):void
		{
			if (e.text.indexOf("codeD") != -1)
			{				
				//var p:PasteBin = PasteBin(stage.getChildByName("PasteBin"));
				//p.loadField.text = e.text;
				//p.loadCode(null);
			}
			else if ( e.text.indexOf("@name") != -1)
			{
				inputBox.appendText( e.text.substring(e.text.indexOf("@name")+5));
			}
			else if (e.text.indexOf("@reply") != -1)
			{
				inputBox.appendText("/w " + e.text.substring(e.text.indexOf("@reply")+6));
			}
			else if (e.text.indexOf("http://") != -1)
			{
				navigateToURL( new URLRequest(e.text));
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
		public function openLinkTab(e:MouseEvent):void {
			showTab("link");
		}
		public function openCodeTab(e:MouseEvent):void {
			showTab("code");
		}
		public function openBetaTab(e:MouseEvent):void {
			showTab("beta");
		}
		public function showTab(t:String):void
		{
			
		}
		public function getUserNameFromId(id:String):String {
			trace("[getUserNameFromId()] ID = " + id);
			//return userManager.getName(id);
			return Main.playerList.getPlayerFromID(id).UserName;
		}
		public function isUserMod(_name:String):Boolean {
			//TODO isUserMod
			//return userManager.isMod(id);
			return Main.playerList.getPlayerFromName(_name).Type == "Mod"
		}
		public function isUserAdmin(_name:String):Boolean {
			//TODO isUserAdmin
			//return userManager.isAdmin(id);
			return Main.playerList.getPlayerFromName(_name).Type == "Admin"
		}
		public function banUser():void {
			//TODO banUser();
			//Disconenct player
		}
		
	}

}