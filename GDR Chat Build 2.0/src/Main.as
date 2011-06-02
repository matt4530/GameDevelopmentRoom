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
	import flash.net.SharedObject;
	import flash.utils.setTimeout;
	import playerio.Client;
	import playerio.Connection;
	import playerio.Message;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	import ugLabs.net.Kong;
	import ugLabs.net.SiteLock;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Main extends Sprite 
	{
		public static var roomName:String = "Asd21ssr2(3hj1k232j3k#2hkj32hj23h2£$3kj2{hbdsao";
		public static var debugField:Text;
		public static var chatDisplay:ChatDisplay;
		public static var playerList:PlayerList;
		
		public static var client:Client;
		public static var connection:Connection
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			//var p:PollManager = new PollManager(true);
			//addChild(p);
			
			run();
			
		}
		
		
		public function run():void
		{
			setStageProperties();
			createDebugField();
			checkSiteLock();
			//////////////////////connectToKongregate();////////////////////////
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
			TextEffect.add("       ====[GDR]====");
			TextEffect.add("\n");
			TextEffect.setField(debugField);
			TextEffect.start(0.5);
		}
		
		public function checkSiteLock():void
		{
			TextEffect.addGroup("...................................");
			TextEffect.add("\n");
			TextEffect.addGroup("...................................");
			TextEffect.add("\n");
			TextEffect.addGroup("...................................");
			TextEffect.add("\n");
			TextEffect.add("SiteLock activating........");
			TextEffect.add("\n");
			SiteLock.allowLocalPlay();
			SiteLock.allowSites(["kongregate.com"]);
			SiteLock.registerStage(stage);
			var approved:Boolean = SiteLock.checkURL(false);
			if (SiteLock.isLocal())
			{
				TextEffect.add("Denied Access...............");
				TextEffect.add("\n");
				TextEffect.add("Visit: http://www.kongregate.com/games/UnknownGuardian/game-development-room-gdr");
				TextEffect.add("\n");
				debugField.selectable = true;
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
				TextEffect.setAllCompleteCallback(forceGuestLogin);
				return;
			}
			displayConnectedUserData();
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
			connectToPlayerIO();
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
				{Name:Kong.userName,Type:getHighestUserType(), Color:getTypeColor()},	//User join data
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
			connection.addMessageHandler("PollResponse", onPollResponse);
			connection.addMessageHandler("PollCreate", onPollCreate);
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
			stage.swapChildren(debugField, chatDisplay);
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
		public static function onPollResponse(m:Message = null, username:String = "", message:String = ""):void
		{
			trace("[Main] onPollResponse");
			trace(m, "XXXX", username, "XXXX", message);
			Main.chatDisplay.tabPoll.handlePollResponse(username, message);
			
		}
		public static function onPollCreate(m:Message = null, id:String = "", message:String = ""):void
		{
			trace("[Main] onPollCreate");
			if (Main.chatDisplay.getUserNameFromId(id) != Kong.userName)
			{
				if (Main.chatDisplay.tabPoll)
				{
					Main.chatDisplay.tabPoll.kill();
				}
				Main.chatDisplay.tabPoll = new PollManager(false);
				Main.chatDisplay.tabPoll.startPoll(id + "|" + message);
				Main.chatDisplay.addChild(Main.chatDisplay.tabPoll);
			}
		}
		
		//util methods
		public static function getHighestUserType():String	{
			var n:String = Kong.userName;
			
			trace("[Main][getHighestUserType()] ", Kong.isAdmin, Kong.isMod, Kong.isDev, Kong.isForumMod, Kong.isCurator, Kong.userName);
			//if(Kong.isAdmin || n == "UnknownGuardian" || n == "BraydenBlack" || n == "davidarcila" || n == "Profusion")
			if(Kong.isAdmin)
				return "Admin";
			//if(Kong.isMod || n == "ST3ALTH15" || n == "BobTheCoolGuy" || n == "wolfheat" ||  n == "lord_midnight"|| n == "Rivaledsouls" || n == "Pimgd" || n == "Sanchex" || n == "Disassociative" || n == "eroge" || n == "GDRTestMod")
			if(Kong.isMod)
				return "Mod";
			if(Kong.isDev)
				return "Dev";
			return "Reg";
		}
		public static function getTypeColor():String {
			var n:String = Kong.userName;
			
			//if(Kong.isAdmin || n == "UnknownGuardian" || n == "BraydenBlack" || n == "davidarcila" || n == "Profusion")
			if(Kong.isAdmin || n == "UnknownGuardian" || n == "BraydenBlack" || n == "davidarcila" || n == "Profusion")
				return "0xCC0033";
			//if(Kong.isMod || n == "ST3ALTH15" || n == "BobTheCoolGuy" || n == "wolfheat" ||  n == "lord_midnight"|| n == "Rivaledsouls" || n == "Pimgd" || n == "Sanchex" || n == "Disassociative" || n == "eroge" || n == "GDRTestMod")
			if(Kong.isMod)
				return "0xD77A41";
			if(Kong.isDev)
				return "0x0098FF";
			return "0x000000";
		}
		
		public function isBanned():Boolean
		{
			var s:SharedObject = SharedObject.getLocal("GDR");
			return (s.data.cake != undefined && s.data.cake);
		}
	}
}


















/*
package 
{
	import com.greensock.TweenLite;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.display.StageScaleMode
	import flash.display.StageAlign
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import playerio.*;
	import SWFStats.*;
	import ugLabs.net.Kong;
	import ugLabs.net.SiteLock;
	import ugLabs.util.StringUtil;
	///**
	 * ...
	 * @author UnknownGuardian
	 * /
	public class Main extends Sprite 
	{
		//the debug textfield
		public static var status:TextField;
		
		public static var _client:Client;
		public static var _connection:Connection;
		
		public var _chat:Chat;
		public var _linkContainer:LinkContainer;
		public var _userContainer:UserContainer;
		public var _pasteBin:PasteBin;
		public var _links:LinksTab;
		public static var _betaTab:BetaTab;
		public var _chatInputManager:ChatInputManager;
		
		public var myTimer:Timer;
		public var startTime:Number;
		public var databaseTime:Number = 0;
		public var gameStats:TextField;
		
		public static var connectionTimer:Timer;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.scaleMode = StageScaleMode.NO_SCALE
			stage.align = StageAlign.TOP_LEFT
			
			//runError();
			runGDR();
		}
		public function runError():void
		{
			Main.status = new TextField();
			Main.status.defaultTextFormat = new TextFormat("Arial", 10, 0xFFFFFF);
			Main.status.selectable = true;
			Main.status.multiline = true;
			Main.status.wordWrap = true;
			Main.status.width = stage.stageWidth;
			Main.status.height = stage.stageHeight;
			Main.status.text = 	"We apologize for the inconvenience. GDR will be down for 24 hours or so." + 
								"With the recent set of errors, we feel its necessary to discuss the problems" + 
								" and find solutions with Player.io\n\n\n UnknownGuardian";
			stage.addChild(status);
		}
		
		public function runGDR():void
		{
			//connect to swfstats
			Log.View(586, "954baea9-fe01-4ed4-97e0-e10a85f1d29e", root.loaderInfo.loaderURL);
			
			
			name = "Main";
			createStatusTextField();
			
			
			SiteLock.allowLocalPlay();
			SiteLock.allowSites(["kongregate.com"]);
			SiteLock.registerStage(stage);
			SiteLock.checkURL(true);
			
			if (SiteLock.isLocal())
			{
				trace("cale");
				//local testing
				PlayerIO.connect(
					stage,								//Referance to stage
					"bettergdr-4dxwzr0qd0ycaegdgynhww",			//Game id (Get your own at playerio.com. 1: Create user, 2:Goto admin pannel, 3:Create game, 4: Copy game id inside the "")
					"public",							//Connection id, default is public
					"cake",								//Username
					"",									//User auth. Can be left blank if authentication is disabled on connection
					handleLocalConnect,						//Function executed on successful connect
					handleError							//Function executed if we recive an error
				);
			}
			else
			{
				Kong.connectToKong(stage, checkIfUserCanPlay);
			}
		}
		
		public function handleLocalConnect(client:Client):void
		{			
			client.multiplayer.developmentServer = "localhost:8184";
			
			client.multiplayer.createJoinRoom(
				"tictactoe",						//Room id. If set to null a random roomid is used
				"TicTacToe",						//The game type started on the server
				false,								//Should the room be hidden from the lobby?
				{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
				{Name:"Caker",Type:"Admin", Color:"0xFFFFFF"},	//"Guest-" + (Math.random()*9999<<0)								//User join data
				handleJoin,							//Function executed on successful joining of the room
				handleError							//Function executed if we got a join error
			);
		}
		
		public function createStatusTextField():void
		{
			Main.status = new TextField();
			Main.status.defaultTextFormat = new TextFormat("Arial", 10, 0xFFFFFF);
			Main.status.selectable = true;
			Main.status.multiline = true;
			Main.status.width = stage.stageWidth;
			Main.status.height = stage.stageHeight;
			Main.status.text = "Status\n" +
								"...\n" + 
								"...\n" + 
								"...\n" + 
								"...\n";
			stage.addChild(status);
			
			
			gameStats = new TextField();
			gameStats.defaultTextFormat = new TextFormat("Arial", 10, 0xFFFFFF, null, null, null, null, null, 'center');
			gameStats.x = 170;
			gameStats.y = 5;
			gameStats.width = 200;
			gameStats.height = 200;
			stage.addChild(gameStats);
		}
		
		
		public function checkIfUserCanPlay(e:Error):void
		{
			//if there is an error (that could be from guest)
			if (e != null)
			{
				Main.status.appendText(
										"...\n" + 
										"Oh noes!\n" + 
										"Something horrible has happenned. \n" + 
										"To prevent the entire game from disconnecting for all users,\n" + 
										"I am not allowing you to connect right now.\n" + 
										"\n" + 
										"Please refresh"
									);
				return;
			}
			if (Kong.services.isGuest())
			{
				Kong.services.addEventListener("login", guestLogin);
				Kong.services.showSignInBox();
				return;
			}
			else
			{
				onKongregateInPageLogin();
			}
		}
		
		public function guestLogin(e:Event):void
		{
			Kong.reset();
			Main.status.text = "Status\n" +
								"...\n" + 
								"...\n" + 
								"...\n" + 
								"...\n";
			onKongregateInPageLogin();
		}
		
		public function onKongregateInPageLogin(event:Event = null):void
		{
			Main.status.appendText( "...\nHello " + Kong._userName + "\n");
			Main.status.appendText( "Your ID is " + Kong._userID + "\n");
			Main.status.appendText( "...\nConnecting to server\n");
			
			if (!isValidUserName()  || isBanned())
			{
				return;
			}
			
			try {
				
	//			PlayerIO.connect(
	//								stage,								//Referance to stage
	//								"chat-pfplo6j07kwdjfcqq9bdg",		//Game id (Get your own at playerio.com. 1: Create user, 2:Goto admin pannel, 3:Create game, 4: Copy game id inside the "")
	//								"public",							//Connection id, default is public
	//								TicTacToe.kongregate.user.getName() + type,//Username
	//								"",									//User auth. Can be left blank if authentication is disabled on connection
	//								handleConnect,						//Function executed on successful connect
	//								handleError							//Function executed if we recive an error
	//							);

				PlayerIO.quickConnect.kongregateConnect(
													    stage,
													    "gdr-mwvmnfxwn0mxd2fbzfd4a",//"chat-pfplo6j07kwdjfcqq9bdg",
													    Kong._userID,
													    Kong._userToken,
														handleConnect,
														handleError
														);
			}
			catch (e:Error)
			{
				Main.status.appendText(
											"...\n" + 
											"Oh noes!\n" + 
											"Something horrible has happenned. \n" + 
											"To prevent the entire game from disconnecting for all users,\n" + 
											"I am not allowing you to connect right now.\n" + 
											"\n" + 
											"Please refresh"
										);
				return;
			}
			
		}
		
		public function handleConnect(client:Client):void
		{			
			trace("Sucessfully connected to player.io");
			Main.status.appendText( "...\nServer Connection Established\n");
			
			//Set developmentsever (Comment out to connect to your server online)
			//client.multiplayer.developmentServer = "localhost:8184";

			
			_client = client;
			
			status.appendText( "...\nJoining Room\n");
			//Create pr join the room test
			client.multiplayer.createJoinRoom(
				"stager",												//Room id. If set to null a random roomid is used
				"TicTacToe",										//The game type started on the server
				false,												//Should the room be hidden from the lobby?
				{},													//Room data. This data is returned to lobby list. Variabels can be modifed on the server
				{Name:Kong._userName,Type:getHighestUserType()},	//User join data
				handleJoin,											//Function executed on successful joining of the room
				handleJoinError										//Function executed if we got a join error
			);
			
		}
		public function handleError(error:PlayerIOError):void
		{
			trace("Got", error)
			Main.status.appendText( "...\n[Main][handleError][PlayerIOError] " + error + "\n");
			Main.status.appendText( "...\nThis usually can be solved by refreshing the page.");
		}
		public function handleJoinError(error:PlayerIOError):void
		{
			trace("Got", error)
			Main.status.appendText( "...\n[Main][handleJoinError][PlayerIOError] " + error + "\n");
		}
		
		private function handleJoin(connection:Connection):void
		{
			trace("Sucessfully connected to the multiplayer server");
			Main.status.appendText( "...\nJoined Room\n");
			Main.status.setTextFormat(new TextFormat(null, null, 0x666666));
			
			//swf stats, this is recorded as a play, since they made it to the room
			Log.Play();
			
			//log the username under users that played
			//Log.CustomMetric(Kong._userName, "Users that Played");
			//this line kills playtomic

			if(connection == null)
			{
				status.appendText( "...\nError: Connection is null. Please refresh");
				return;
			}
			
			_connection = connection;

			//Add chat to game
			_chat = new Chat(connection);
			stage.addChild(_chat);
			TweenLite.from(_chat,2,{alpha:0});
			
			_linkContainer = new LinkContainer();
			stage.addChild(_linkContainer);
			
			//_userContainer = new UserContainer(connection);
			//stage.addChild(_userContainer);
			
			_pasteBin = new PasteBin(stage,_client,connection);
			_pasteBin.name = "PasteBin";
			
			_links = new LinksTab();
			stage.addChild(_links);
			
			_betaTab = new BetaTab(_client,connection);
			_betaTab.name = "BetaTab";
			stage.addChild(_betaTab);
			
			if (!SiteLock.isLocal())
			{
				_chatInputManager = new ChatInputManager();
			}
				
			startTimers();
		}
		
		public function startTimers():void
		{
			//set start time
			startTime = getTimer();
						
			stage.addEventListener(Event.ENTER_FRAME,statsUpdate);
			
			//                300000 = 5 minutes, infinite
			myTimer = new Timer(300000,0);
			myTimer.addEventListener(TimerEvent.TIMER, submitData);
			myTimer.start();
			
			
			Main.connectionTimer = new Timer(60000, 0);
			Main.connectionTimer.addEventListener(TimerEvent.TIMER, checkConnection);
			Main.connectionTimer.start();
		}
		public function statsUpdate(e:Event):void
		{
			var ms:Number = getTimer()-startTime;
			var sec:int = ms/1000;
			var min:int = sec/60;
			var hr:int = min/60;
			gameStats.text = "[Time] \n Hours: " + hr + "\n  Minutes: " + min%60 + "\n  Seconds: " + sec%60 + "\n\n Total Minutes: " + databaseTime;
		}
		public function submitData(e:TimerEvent):void
		{
			_client.bigDB.loadMyPlayerObject(loadedSavedData);
			
			Kong.stats.submit("GamePlayedMinutes",databaseTime);
		}
		public function loadedSavedData(o:DatabaseObject):void
		{
			if(o.Data != null)
			{
				var t:int = o.Data.Time;
				t+=5;
				o.Data = { Time:t };
				databaseTime = t;
			}
			else
			{
				o.Data = { Time:5 };
				databaseTime = 5;
			}
			o.save();
			
		}
		public function checkConnection(e:TimerEvent):void
		{
			if (!_connection.connected)
			{
				_chat.displayMessage('<font color="#FF0000" size="12">[System]</font> GDR identified that you are disconnected at ' + getTimer() + 'ms. Please allow 60 seconds for reconnection.');
				_client.multiplayer.createJoinRoom(
					"stager",												//Room id. If set to null a random roomid is used
					"TicTacToe",										//The game type started on the server
					false,												//Should the room be hidden from the lobby?
					{},													//Room data. This data is returned to lobby list. Variabels can be modifed on the server
					{Name:Kong._userName,Type:getHighestUserType()},	//User join data
					handleReconnection,											//Function executed on successful joining of the room
					handleReconnectionError										//Function executed if we got a join error
				);
			}
		}
		public function handleReconnection(connection:Connection):void
		{
			_connection = connection;
			_chat.changeConnection(connection);
			_pasteBin.connection = connection;
			_chat.displayMessage('<font color="#FF0000" size="12">[System]</font> Reconnection Successful at ' + getTimer() + 'ms.' );
		}
		public function handleReconnectionError(error:PlayerIOError):void
		{
			trace("Got", error)
			_chat.myTextArea.appendText("...\n[Main][handleReconnectionError][PlayerIOError] " + error + "\n");
			_chat.myTextArea.appendText("...\nThis usually can be solved by refreshing the page.");
		}
		
		public function showRooms(rooms:Array):void
		{
			_chat.myTextArea.appendText(rooms.join("+"));
		}
		public function showRoomsError(e:PlayerIOError):void
		{
			_chat.myTextArea.appendText(e.errorID + "   " + e.message);
		}
		
		
		
		
		
		
		
		
		
		public function isValidUserName():Boolean
		{
			return (Kong._userName.length > 3) && (Kong._userID != "0") && (Kong._userName != "Guest");
		}
		public function getHighestUserType():String
		{
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
			var s:SharedObject = SharedObject.getLocal("dataD");
			if (s.data.ban==undefined) {
				s.data.ban = false;
				s.flush();
			}
			else {
				return s.data.ban;
			}			
			
			return false;
		}
		
	}
	
}*/