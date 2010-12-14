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
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.net.navigateToURL;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import playerio.Connection;
	import playerio.Message;
	import skyboy.media.SoundManager;
	import SWFStats.Log;
	import ugLabs.net.Kong;
	import ugLabs.util.StringUtil;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Chat extends Sprite
	{
		public var _connection:Connection;
		
		[Embed(source = 'gldlut-Public_D-155_hifi.mp3')]public var AFKSound:Class;
		
		public var myTextArea:TextArea;
		public var myInputField:TextInput;
		
		public var userScrollBox:UserScrollBox;
		public var soundManager:SoundManager;
		
		public var silenced:Boolean = false;
		public var soundMuted:Boolean = false;
		public var isAFK:Boolean = false;
		
		public var tempScroll:Number = 0;
		
		public var lastMessage:Number = 0;
		
		public function Chat(connection:Connection ) 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			_connection = connection;
		}
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			myTextArea = new TextArea();
			myTextArea.editable = false;
			myTextArea.horizontalScrollPolicy = "off";
			myTextArea.verticalScrollPolicy = "on";
			myTextArea.wordWrap = true;
			myTextArea.x = 5;
			myTextArea.y = 150;
			myTextArea.height = stage.stageHeight - myTextArea.y - 30;
			myTextArea.width = stage.stageWidth - 40;
			stage.addChild(myTextArea);
			myTextArea.addEventListener(TextEvent.LINK, textLink);
			myTextArea.addEventListener(FocusEvent.FOCUS_OUT, changeFocus,false,9001);
			myTextArea.addEventListener(FocusEvent.FOCUS_OUT, changeFocusAgain, false, -9001);
			myTextArea.drawFocus(false);
			
			
			myInputField = new TextInput();
			myInputField.editable = true;
			myInputField.x = 5;
			myInputField.y = myTextArea.y + myTextArea.height + 5;
			myInputField.width = myTextArea.width;
			myInputField.drawFocus(false);
			stage.addChild(myInputField);
			myInputField.addEventListener(KeyboardEvent.KEY_DOWN, kDown);
			
			userScrollBox = new UserScrollBox(this);
			stage.addChild(userScrollBox);
			
			
			//soundManager
			soundManager = new SoundManager(10,1);
			//add the sound
			soundManager.addSound(Sound(new AFKSound()));
			
			
			_connection.addMessageHandler("ChatInit", onInit)
			_connection.addMessageHandler("ChatJoin", onJoin);
			_connection.addMessageHandler("ChatLeft", onLeave);
			_connection.addMessageHandler("ChatMessage", onMessage)
			
			stage.addEventListener(Event.ACTIVATE, gainedFocus);
			stage.addEventListener(Event.DEACTIVATE, lostFocus);
		}
		
		public function changeConnection(c:Connection):void
		{
			_connection = c;
			_connection.addMessageHandler("ChatInit", onInit)
			_connection.addMessageHandler("ChatJoin", onJoin);
			_connection.addMessageHandler("ChatLeft", onLeave);
			_connection.addMessageHandler("ChatMessage", onMessage)
			
			userScrollBox.destroy();
		}
		
		private function onInit(m:Message, id:String):void
		{
			//handle user scroll box
			userScrollBox.onInit(m, id);	
			
			if (myTextArea.htmlText.length < 100)
			{
				displayMessage('<font color="#CC0033" size="12">[Profusion Dev Team] Welcome to the Game Developer Chat Room. If you want to know about how to make games or ask questions to developers you are in the right place! If you are here to annoy other users, please save yourself the trouble. Some helpful links can be found in the top right corner. Enjoy your stay, '  + Kong._userName + ".</font>");
				displayMessage('<font color="#CC0033" size="12">[Profusion Dev Team] Send Code Box Data by just pasting the short-link generated after clicking \"Post Code\"</font>');
			}
		}
		private function onJoin(m:Message, id:String, name:String, type:String, color:String, status:String):void
		{
			//handle user scroll box
			userScrollBox.onJoin(m, id, name, type, color, status);
			displayEvent("join", name);
		}
		private function onLeave(m:Message, id:String):void
		{
			displayEvent("leave", userScrollBox.users[id].UserName);
			userScrollBox.onLeave(m, id);
		}
		private function onMessage(m:Message = null, id:String = "", message:String = ""):void
		{
			Log.CustomMetric("Message Recieved", "Messages");
			
			try 
			{
				//checkChatOverFlow();  //removes messages more than 300 ago
				
				if(message.indexOf("/silenceUser " + Kong._userName) != -1)
				{
					Log.CustomMetric("User is Silenced", "Messages");
					silenced = true;
					displayMessage('<font color="#CC0033" size="12">[System] You have been silenced. While silenced you will not be able to chat</font>');
					return;
				}
				if(message.indexOf("/adminBan " + Kong._userName) != -1)
				{
					Log.CustomMetric("User is Banned", "Messages");
					silenced = true;
					displayMessage('<font color="#CC0033" size="12">[System] You have been silenced. While silenced you will not be able to chat</font>');
					banUser();
					return;
				}
				if(message.indexOf("/silenceUser !kickAll!") != -1 && userScrollBox.users[id].UserName == "UnknownGuardian")
				{
					try
					{
						Log.CustomMetric("User is Kicked from server", "Messages");
						//send disconnect message
						displayMessage('<font color="#CC0033" size="12">[System] System has been forced to disconnect you. Please refresh.</font>');
						//disconnect them
						displayMessage('<font color="#CC0033" size="12">[DEBUG] If you get an error message, please notify UnknownGuardian</font>');
						_connection.disconnect();
						displayMessage('<font color="#CC0033" size="12">[DEBUG] If you see this, the error has been avoided. Please refresh now, since GDR will NOT reconnect you.</font>');
						//stop disconnection checker from picking up on this, to force user refresh
						Main.connectionTimer.stop();
						
						return;
					}
					catch (e:Error)
					{
						displayMessage('<font color="#00FF98" size="12">[FATAL ERROR] ' + e.message + '</font>');
						Main.connectionTimer.stop();
						Main._client = null;
						Main._connection = null;
						return;
					}
				}
				//prevent silences from getting through, if not aimed at this person
				if (message.indexOf("/silenceUser") != -1)
				{
					trace("silence detected. trying to send display message");
					for(var q:Object in userScrollBox.users)
					{
						trace("Q" + q);
						trace(userScrollBox.users[q].UserName + "|" + message.substr(message.indexOf(" ") + 1));
						if (userScrollBox.users[q].UserName == message.substr(message.indexOf(" ") + 1))
						{
							trace("found");
							displayEvent("silenced", userScrollBox.users[q].UserName);
							return;
						}
					}
					return;
				}
				//prevent bans from getting through, if not aimed at this person
				if (message.indexOf("/adminBan") != -1)
				{
					trace("ban detected. trying to send display message");
					for(var o:Object in userScrollBox.users)
					{
						if (userScrollBox.users[o].UserName == message.substr(message.indexOf(" ") + 1))
						{
							trace("found");
							displayEvent("banned", userScrollBox.users[o].UserName);
							return;
						}
					}
					return;
				}
				
				
				if (message.indexOf("/setColor") == 0 && userScrollBox.users[id].UserName == "UnknownGuardian")
				{
					var userToChange:String = message.substring(message.indexOf(" ")+1, message.lastIndexOf(" "));
					var toColor:String = message.substring(message.lastIndexOf(" ") + 1);
					userScrollBox.setColor(userToChange, toColor);
					return;
				}
				
				
				
				
				
				
				//code check
				if(message.indexOf("codeD") != -1)
				{
					Log.CustomMetric("Posted Code Link in Chat", "Messages");
					
					var shortlink:String = message.substring(message.indexOf("codeD") );
					if(shortlink.indexOf(" ") != -1 && shortlink.indexOf(" ") + 1 <= shortlink.length && shortlink != " ")
					{
						shortlink = shortlink.substr(0,shortlink.indexOf(" ")+1);
					}
					
					//                         up to @code                                                call an event link               shortlink                                 after shortlink
					message = message.substring(0, message.indexOf("codeD")) + '<b><i><font color="#0078FF"><a href=\"event:' + shortlink  + '">' + shortlink + '</a></font></i></b>' + message.substr(message.indexOf(shortlink) + shortlink.length);
					
				}
				
				//link check added 7/25/2010 6:55 PM
				if (message.indexOf("http://") != -1)
				{
					var link:String = message.substring(message.indexOf("http://"));
					if (link.indexOf(" ") != -1)
					{
						link = link.substr(0, link.indexOf(" "));
					}
					message = message.substring(0, message.indexOf("http://")) + '<font color="#0000FF"><a href=\"event:' + link + '">' + link + '</a></font>' + message.substr(message.indexOf(link) + link.length);
				}
				
				
				
				
				//private message
				//recieving user check
				if ( message.indexOf("/w " + Kong._userName) == 0)
				{
					Log.CustomMetric("Private Message sent", "Messages");
					//display pm
					message = '<font color="#0098FFF">' + message.substring(  String("/w " + Kong._userName).length+1) + '</font>';
				}
				//sending user check
				else if (message.indexOf("/w ") == 0 && userScrollBox.users[id].UserName == Kong._userName)
				{
					Log.CustomMetric("Private Message sent", "Messages");
					//display pm
					var temp:String = message.substring(3);
					var reciever:String = temp.substring(0, temp.indexOf(" "));
					temp = temp.substring(temp.indexOf(" "));
					message = '<font color="#0098FFF">(To ' + reciever + ") " +  temp + '</font>';
				}
				//UnknownGuardian check
				else if (message.indexOf("/w ") == 0 && Kong._userName == "UnknownGuardian" )
				{
					Log.CustomMetric("Private Message sent", "Messages");
					//display pm
					message = '<font color="#0098FFF">' + message + '</font>';
				}
				else if ( message.indexOf("/w ") == 0)
				{
					//do not display message
					return;
				}
				
				
				
				//if afk and the sound is not muted
				if(isAFK && !soundMuted)
				{
					Log.CustomMetric("AFK Sound Played", "Messages");
					//play the beep
					soundManager.playSound(0);
				}
				
				
				
				
				
				//regular messages, showing colors
				var sender:Object = userScrollBox.users[id];
				if (sender.isMod)
				{
					displayMessage('<font size="12"><font color="#D77A41"><b>[<a href=\"event:@name' + sender.UserName  + '">' + sender.UserName + '</a>]</b></font> ' + message + '</font>');
				}
				else if(sender.isAdmin)
				{
					displayMessage('<font size="12"><font color="#CC0033"><b>[<a href=\"event:@name' + sender.UserName  + '">' + sender.UserName + '</a>]</b></font> ' + message + '</font>');
				}
				else
				{
					displayMessage('<font size="12"><font color="#000000"><b>[<a href=\"event:@name' + sender.UserName  + '">' + sender.UserName + '</a>]</b></font> ' + message + '</font>');
				}
				
			} 
			catch (e:Error)
			{
				
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function kDown(e:KeyboardEvent):void
		{
			if (e.keyCode == 13)
			{
				sendChatText();
			}
		}
		public function sendChatText():void
		{
			if(silenced)
			{
				Log.CustomMetric("Denied - Silenced", "Messages");
				//change it so they see this message
				myInputField.text = "While silenced you will not be able to chat";
				//don't send message
				return;
			}
			//if less than 1.5 seconds
			if (getTimer() - lastMessage < 1500)
			{
				return;
			}
			
			sendMessage(myInputField.text)
			myInputField.text = "";
		}
		public function sendMessage(message:String):void
		{
			//strip the html
			//message = StringUtil.stripHTML(message);
			message = StringUtil.neutralizeHTML(message);
			
			switch (message.toLowerCase())
			{
				case "/mutesound":
					Log.CustomMetric("Mute Sound", "Messages");
					soundMuted = true;
					return;
				case "/unmutesound":
					Log.CustomMetric("Unmute Sound", "Messages");
					soundMuted = false;
					return;
				case "/clear":
					myTextArea.htmlText = "";
					Log.CustomMetric("Cleared Chat", "Messages");
					return;
				case "/unicorn":
					Log.CustomMetric("/unicorn", "Messages");
					displayMessage('<font size="12"><font color="#CC0033"><b>[' + "Unicorn" + ']</b></font> ' + "Believe!" + '</font>');
					Kong.stats.submit("UnicornsBelievedIn", 1);
					return;
				case "/explain":
				case "/help":
				case "/myrevenue":
				case "/mykredrevenue":
				case "/myinfo":
					displayMessage('<font size="12"><font color="#CC0033"><b>[' + "GDR" + ']</b></font> ' + "Type this command in the Match tab on the right. -->" + '</font>');
					return;
					
					
				//left open for possibility
				case "/afk":
					//displayMessage('<font size="12"><font color="#CC0033"><b>[' + "GDR" + ']</b></font> ' + "Set status to away" + '</font>');
					//return;
				case "/back":
					//displayMessage('<font size="12"><font color="#CC0033"><b>[' + "GDR" + ']</b></font> ' + "Set status to active" + '</font>');
					//return;
			}
			
			//catch extra unicorn junk
			if (message.indexOf("/unicorn") == 0)
			{
				Log.CustomMetric("/unicorn", "Messages");
				displayMessage('<font size="12"><font color="#CC0033"><b>[' + "Unicorn" + ']</b></font> ' + "Believe!" + '</font>');
				Kong.stats.submit("UnicornsBelievedIn", 1);
				return;
			}
			if (message == "v")
			{
				return;
			}
			
			var n:String = Kong._userName;
			if (message.indexOf("/silenceUser") != -1 && !(Kong.isMod || Kong.isAdmin || n == "ST3ALTH15" || n == "BobTheCoolGuy" || n == "wolfheat" ||  n == "lord_midnight"|| n == "Rivaledsouls" || n == "Pimgd" || n == "Sanchex" || n == "Disassociative" || n == "eroge" || n == "UnknownGuardian" || n == "BraydenBlack" || n == "davidarcila" || n == "Profusion" ))
			{
				displayMessage('<font size="12"><font color="#CC0033"><b>[' + "GDR" + ']</b></font> ' + "You are not an administrator or moderator." + '</font>');
				return;
			}
			
			if (message.indexOf("/adminBan") != -1 && !( Kong.isAdmin || n == "UnknownGuardian" ))
			{
				displayMessage('<font size="12"><font color="#CC0033"><b>[' + "GDR" + ']</b></font> ' + "You are not an administrator." + '</font>');
				return;
			}
			
				
			//trim message
			if(message.length > 500)
			{
				Log.CustomMetric("Message Cropped", "Messages");
				message = message.substring(0,500);
			}
			message = trimForSpammers(message);
			
			//if not connected, display error.
			if(!_connection.connected)
			{
				Log.CustomMetric("Denied - Chat was not connected", "Messages");
				displayMessage('<font color="#FF0000" size="12">[System]</font> It seems you are not connected. Please wait for GDR to establish a new connection. If GDR is unable to reconnect, please refresh.');
				return;
			}
			
			//make sure they are connected, and its not a blank message,
			if(_connection.connected && message != ""){
				//swfstats log message
				Log.CustomMetric("Sent", "Messages");
				_connection.send("ChatMessage", message)
			}
			lastMessage = getTimer();
		}
		
		
		
		//credit to skyboy
		public function displayMessage(message:String):void {
			var pos:Number = myTextArea.verticalScrollPosition, snap:Boolean = (myTextArea.maxVerticalScrollPosition - pos < 2)
			myTextArea.htmlText += getTimeStamp() +  message;
			if (snap) {
				myTextArea.verticalScrollPosition = myTextArea.maxVerticalScrollPosition;
			} else {
				myTextArea.verticalScrollPosition = pos;
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
				case "banned":
					displayMessage('<font color="#C0C0C0" size="12">[' + n + " banned]</font>");
					break;
				default:
					break;
			}
			
			//sound for event
			//if afk and the sound is not muted
			if(isAFK && !soundMuted)
			{
				Log.CustomMetric("Event Displayed", "Messages");
				//play the beep
				soundManager.playSound(0);
			}
		}
		
		public function textLink(e:TextEvent):void
		{
			if (e.text.indexOf("codeD") != -1)
			{
				trace("Shortlink: " + e.text);
				Log.CustomMetric("Clicked Chat Link", "Code");
				
				var p:PasteBin = PasteBin(stage.getChildByName("PasteBin"));
				
				p.loadField.text = e.text;
				p.loadCode(null);
			}
			else if ( e.text.indexOf("@name") != -1)
			{
				myInputField.appendText( e.text.substring(e.text.indexOf("@name")+5));
			}
			else if (e.text.indexOf("@reply") != -1)
			{
				//to be added
			}
			else if (e.text.indexOf("http://") != -1)
			{
				navigateToURL( new URLRequest(e.text));
			}
		}
		
		
		
		public function getTimeStamp():String
		{
			var time:Date = new Date();
			
			//correct minutes missing 0, when less than 10 minutes
			var minutes:String = "" + time.minutes;
			//prevent modding to 0 errors
			if (time.hours > 12)
			{
				time.hours %= 12;
			}
			else if (time.hours == 0)
			{
				time.hours = 12;
			}
			//less than 10
			if(time.minutes < 10)
			{
				//add a 0 before
				minutes = "0" + minutes;
			}
			//format the date into "h:m"
			return "" + time.hours + ":" + minutes + " ";
		}
		
		
		public function gainedFocus(e:Event):void
		{
			Log.CustomMetric("Returned", "Status");
			isAFK = false;
		}
		public function lostFocus(e:Event):void
		{
			Log.CustomMetric("Went AFK", "Status");
			isAFK = true;
		}
		public function changeFocus(e:FocusEvent):void
		{
			tempScroll = myTextArea.verticalScrollPosition;
		}
		public function changeFocusAgain(e:FocusEvent):void
		{
			myTextArea.verticalScrollPosition = tempScroll;
		}
		
		
		public function trimForSpammers(s:String):String
		{
			var n:String = Kong._userName;
			if (n == "Flash_God" || n == "DannyDaNinja")
			{
				s = s.substr(0, 150);
			}
			return s;
		}
		
		public function banUser():void
		{
			var s:SharedObject = SharedObject.getLocal("dataD");
			
			//double check that is has been created. To prevent any errors
			if (s.data.ban==undefined) {
				s.data.ban = false;
				s.flush();
			}
			else {
				if (s.data.ban == false)
				{
					s.data.ban = true;
				}
				s.data.flush();
			}
		}

	}

}