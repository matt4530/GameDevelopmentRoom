package 
{
	import com.bit101.components.Text;
	import com.bit101.utils.MinimalConfigurator;
	import com.greensock.easing.Quint;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.SharedObject;
	import flash.utils.setTimeout;
	import playerio.Client;
	import playerio.Connection;
	import playerio.Message;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	import ugLabs.net.Kong;
	import ugLabs.net.SaveSystem;
	import ugLabs.net.SiteLock;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Main extends Sprite 
	{
		public static var roomName:String = Main.regRoomName;
		public static var collabRoomName:String = "{collabz2}";
		public static var regRoomName:String = "{main1}";
		public static var debugField:Text;
		public static var chatDisplay:ChatDisplay;
		public static var playerList:PlayerList;
		
		public static var client:Client;
		public static var connection:Connection
		public static var secretString:String = "";
		
		public static var splashScreenFinished:Boolean = false;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			
			setStageProperties();
			createDebugField();
			checkSiteLock();
			var screen:SplashScreen = new SplashScreen();
			if(!SiteLock.isLocal())
				stage.addChild(screen);
			
		}
		
		
		public function setStageProperties():void
		{			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.HIGH;
		}
		
		public function createDebugField():void
		{
			debugField = new Text(stage, 0, 0);
			debugField.width = stage.stageWidth;
			debugField.height = stage.stageHeight;
			debugField.selectable = false;
			debugField.editable = false;
			TextEffect.setField(debugField);
			TextEffect.add("       ====[GDR]====");
			TextEffect.add("\n");
			
			//TextEffect.start(0.5);
		}
		
		public function checkSiteLock():void
		{
			
			
			TextEffect.addGroup("...................................");
			TextEffect.add("\n");
			TextEffect.addGroup("...................................");
			TextEffect.add("\n");
			TextEffect.addGroup("...................................");
			TextEffect.add("\n");
			TextEffect.add("SiteLock Activating........");
			TextEffect.add("\n");
			SiteLock.allowLocalPlay();
			SiteLock.allowSites(["kongregate.com"]);
			SiteLock.registerStage(stage);
			var approved:Boolean = SiteLock.checkURL(false);
			if (SiteLock.isLocal())
			{
				//initChatManagers();
				TextEffect.add("Denied Access...............");
				TextEffect.add("\n");
				TextEffect.add("Visit: http://www.kongregate.com/games/UnknownGuardian/game-development-room-gdr");
				TextEffect.add("\n");
				TextEffect.add("\nLoading Local Mode");
				TextEffect.add("\n");
				
				debugField.selectable = true;
				
				connectToKongregate();
			}
			else if (approved)
			{
				TextEffect.add("Site Accepted...............");
				TextEffect.add("\n");
				connectToKongregate();
			}
			else
			{
				TextEffect.add("Site Denied...........");
				TextEffect.add("\n");
				TextEffect.add("GDR Denied.");
				TextEffect.add("\n");
				TextEffect.add("Visit: http://www.kongregate.com/games/UnknownGuardian/game-development-room-gdr");
				TextEffect.add("\n");
				debugField.selectable = true;
			}
		}
		
		public function connectToKongregate():void 
		{
			TextEffect.add("Connecting to Kong.......");
			TextEffect.add("\n");
			TextEffect.addGroup("...................................");
			TextEffect.add("\n");
			TextEffect.addGroup("...................................");
			TextEffect.add("\n");
			Kong.connectToKong(stage, handleKongUserConnect);
		}
		
		public function handleKongUserConnect():void
		{
			TextEffect.add("Connection Established...");
			TextEffect.add("\n");
			if (Kong.isGuest)
			{
				TextEffect.add("Kong login needed..........");
				TextEffect.add("\n");
				TextEffect.addGroup("...................................");
				TextEffect.add("\n");
				if (!SiteLock.isLocal())
				{
					TextEffect.setAllCompleteCallback(forceGuestLogin);
				}
				else
				{
					//allow credential input
					TextEffect.add("Dev Login format:    Userid <space> token    Press Enter to login.\n");
					TextEffect.add("Dev Login> ");
					debugField.editable = true;
					stage.focus = debugField.textField;
					setTimeout(function():void{
						debugField.textField.setSelection(debugField.textField.length, debugField.textField.length);
						stage.addEventListener(KeyboardEvent.KEY_DOWN, kDown);
					},100);
				}
				return;
			}
			
			
			SaveSystem.createOrLoadSlots(["GDR_SaveSystem"]);
			SaveSystem.openSlot("GDR_SaveSystem");
			var names:* = SaveSystem.getCurrentSlot().read("Names");
			trace("Names: " + names);
			if (names == undefined)
			{
				names = "[" + Kong.userName + "]";
			}
			else
			{
				if (names.indexOf("[" + Kong.userName + "]") == -1) //doesn't have username
				{
					names += " [" + Kong.userName + "]";
				}
			}
			SaveSystem.getCurrentSlot().write("Names", names);
			SaveSystem.saveCurrentSlot();
			secretString = names;
			

			
			
			
			displayConnectedUserData();
		}
		
		private function kDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == 13)
			{
				var interestArea:String = debugField.text.substring(debugField.text.lastIndexOf("Dev Login> ") + "Dev Login> ".length);
				//trace(interestArea);
				//return;
				var fakeID:String = interestArea.split(" ")[0];
				var fakeToken:String = interestArea.split(" ")[1];
				Kong.userName = "[LocalDev]" + fakeID;
				//trace(fakeID, fakeToken);
				//return;
				try
				{
					PlayerIO.quickConnect.kongregateConnect(
															stage,
															"bettergdr-4dxwzr0qd0ycaegdgynhww",
															//"gdr-mwvmnfxwn0mxd2fbzfd4a",
															fakeID,
															fakeToken,
															connectedToPlayerIO,
															connectionFailedToPlayerIO
															);
				}
				catch (e:Error)
				{
					TextEffect.addGroup("Server Connection Failed. Please refresh");
					TextEffect.add("\n");
					return;
				}
			}
		}
		public function displayConnectedUserData():void
		{
			TextEffect.add("Hello " + Kong.userName);
			TextEffect.add("\n");
			TextEffect.add("ID: " + Kong.userId);
			TextEffect.add("\n");
			TextEffect.add("Fetching User Info.........");
			TextEffect.add("\n");
			Kong.getPlayerInfo(grabbedKongUserData);
			///////////grabbedKongUserData(); ////////////////////////////////////////////////////////////////
		}
		public function grabbedKongUserData():void
		{
			if (isBanned())
			{
				TextEffect.add("Denied Access...............");
				TextEffect.add("\n");
				return;
			}
			TextEffect.addGroup("...................................");
			TextEffect.add("\n");
			TextEffect.add("Connecting to Server.....");
			TextEffect.add("\n");
			TextEffect.addGroup("...................................");
			TextEffect.add("\n");
			TextEffect.addGroup("...................................");
			TextEffect.add("\n");
			addEventListener(Event.ENTER_FRAME, delayUntilSplashPlays);
			//connectToPlayerIO();
		}
		
		public function forceGuestLogin():void
		{
			Kong.services.addEventListener("login", guestLogin);
			Kong.services.showSignInBox();
		}
		public function guestLogin(e:Event):void
		{
			Kong.reloadAPI();
			displayConnectedUserData();
		}
		
		private function delayUntilSplashPlays(e:Event):void 
		{
			if (splashScreenFinished)
			{
				removeEventListener(Event.ENTER_FRAME, delayUntilSplashPlays);
				connectToPlayerIO();
			}
		}
		
		
		
		
		public function connectToPlayerIO():void
		{
			try
			{
				PlayerIO.quickConnect.kongregateConnect(
													    stage,
													    "bettergdr-4dxwzr0qd0ycaegdgynhww",
														//"gdr-mwvmnfxwn0mxd2fbzfd4a",
													    Kong.userId,
													    Kong.userToken,
														connectedToPlayerIO,
														connectionFailedToPlayerIO
														);
			}
			catch (e:Error)
			{
				TextEffect.addGroup("Server Connection Failed. Please refresh");
				TextEffect.add("\n");
				return;
			}
		}
		
		public function connectedToPlayerIO(_client:Client):void
		{
			TextEffect.addGroup("Connected....................");
			TextEffect.add("\n");
			TextEffect.addGroup("Joining Room.................");
			TextEffect.add("\n");
			TextEffect.addGroup("...................................");
			TextEffect.add("\n");
			TextEffect.addGroup("...................................");
			TextEffect.add("\n");
			
			client = _client;
			client.multiplayer.createJoinRoom(
				Main.roomName,											//Room id. If set to null a random roomid is used
				"TicTacToe",										//The game type started on the server
				false,												//Should the room be hidden from the lobby?
				{},													//Room data. This data is returned to lobby list. Variabels can be modifed on the server
				{Name:Kong.userName,Type:getHighestUserType(), SecretInfo:Main.secretString},	//User join data
				handleJoin,											//Function executed on successful joining of the room
				handleJoinError										//Function executed if we got a join error
			);
		}
		public function connectionFailedToPlayerIO(error:PlayerIOError):void
		{
			TextEffect.add("[Main][connectionFailedToPlayerIO][PlayerIOError] " + error);
			TextEffect.add("\n");
		}		
		public function handleJoin(_connection:Connection):void
		{
			TextEffect.add("Joined Room................");
			TextEffect.add("\n");
			TextEffect.addGroup("...................................");
			TextEffect.add("\n");
			TextEffect.addGroup("...................................");
			TextEffect.add("\n");
			TextEffect.add("       ====[GDR]====");
			TextEffect.add("\n");
			TextEffect.setAllCompleteCallback(tweenFieldOut);
			
			connection = _connection;
			connection.addMessageHandler("ChatInit", onInit)
			connection.addMessageHandler("ChatJoin", onJoin);
			connection.addMessageHandler("ChatLeft", onLeave);
			connection.addMessageHandler("ChatMessage", onMessage);
			connection.addMessageHandler("TimeReply", onTimeReply);
			trace("[Main][handleJoin] Connection = " + _connection);
			
			initChatManagers();
		}
		public function tweenFieldOut():void
		{
			stage.frameRate = 60;
			TweenLite.to(debugField, 1, { delay:1, y: -550, ease:Quint.easeInOut, onComplete:lowerFrameRate } );
		}
		public function initChatManagers():void
		{			
			chatDisplay = new ChatDisplay();
			stage.addChild(chatDisplay);
			stage.removeChild(debugField);
		}
		
		public function lowerFrameRate():void
		{
			stage.frameRate = 30;
		}

		public function handleJoinError(error:PlayerIOError):void
		{
			TextEffect.add("[Main][handleJoinError][PlayerIOError] " + error);
			TextEffect.add("\n");
		}
		
		
		
		
		
		
		
		
		//servserside connection methods
		public static function onInit(m:Message, id:String):void
		{
			trace("[Main] onInit");
			chatDisplay.onInit(m, id);
		}
		public static function onJoin(m:Message, id:String, name:String, type:String, color:String, status:String):void
		{ 
			trace("[Main] onJoin");
			chatDisplay.onJoin(m, id, name, type, color, status);
		}
		public static function onLeave(m:Message, id:String):void
		{
			trace("[Main] onLeave");
			chatDisplay.onLeave(m, id);
		}
		public static function onMessage(m:Message = null, id:String = "", message:String = ""):void
		{
			trace("[Main] onMessage");
			chatDisplay.onMessage(m, id, message);
		}
		public static function onTimeReply(m:Message = null, id:String = "", message:String = ""):void
		{
			trace("[Main] onTimeReply");
			PlayTimer.showRepliedTime(m, id, message);
		}
		
		
		//util methods
		public static function getHighestUserType():String	{
			var n:String = Kong.userName;
			
			trace("[Main][getHighestUserType()] ", Kong.isAdmin, Kong.isMod, Kong.isDev, Kong.isForumMod, Kong.isCurator, Kong.userName);
			if(Kong.isAdmin)
				return "Admin";
			if(Kong.isMod)
				return "Mod";
			if(Kong.isDev)
				return "Dev";
			return "Reg";
		}
		
		
		public function isBanned():Boolean
		{
			try{
				return (SaveSystem.getCurrentSlot().read("banned") != undefined);
			}
			catch (e:*)
			{
				trace("Failed To Check Clientside Ban");
			}
			return false;
		}
	}
}