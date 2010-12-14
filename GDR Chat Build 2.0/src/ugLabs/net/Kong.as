package ugLabs.net
{
	import com.adobe.serialization.json.JSON;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.system.Security;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	
	//Singleton Class
	public class Kong
	{
		private static var _instance:Kong;
		private static var _okToCreate:Boolean = false;
		
		public static var _api:* = null;
		
		public static var chat:* = null;
		public static var services:* = null;
		public static var stats:* = null;
		public static var mtx:* = null;
		public static var sharedContent:* = null;
		public static var images:* = null;
		
		
		public static var _userName:String = "";
		public static var _userID:String = "";
		public static var _userToken:String = "";
		
		public static var isDev:Boolean = false;
		public static var isCurator:Boolean = false;
		public static var isForumMod:Boolean = false;
		public static var isMod:Boolean = false;
		public static var isAdmin:Boolean = false;
		
		public static var age:int = 0;
		public static var level:int = 0;
		public static var points:int = 0;
		public static var avatarURL:String = "";
		public static var chatAvatarURL:String = "";
		public static var levelIconURL:String = "";
		
		public static var numFriendsOnline:int = 0;
		public static var numUnreadShouts:int = 0;
		public static var numUnreadWhispers:int = 0;
		public static var numKreds:int = 0;
		
		public static var silencedUntil:String = null
		
		
		//private stuff used in methods
		private static var getPlayerInfoCallback:Function;
		
		
		
		
		
		public function Kong()
		{
			if( !Kong._okToCreate ){
				throw new Error("[Kong] Error: " + this + " is not a singleton and must be accessed with the getInstance() method");				
			}
		}
		
		public static function getInstance():Kong
		{
			if( !Kong._instance ){
				Kong._okToCreate = true;
				Kong._instance = new Kong();
				Kong._okToCreate = false;
			}
			return Kong._instance;
		}
		
		
		
		/**
		 * connectToKong
		 * @description		connects to kong for you, like a good little method
		 * @param			s: the stage that kong connects to
		 * @param			callback: the function to be called when completed
		 */
		public static function connectToKong(s:Stage, callback:Function):void
		{
			if (callback != null)
			{
				Kong.getPlayerInfoCallback = callback;
			}
			
			//grab the loaderinfo param
			var paramObj:Object = LoaderInfo(s.root.loaderInfo).parameters;
 
			// The API path. The "shadow" API will load if testing locally.
			var apiPath:String = paramObj.kongregate_api_path ||"http://www.kongregate.com/flash/API_AS3_Local.swf";
 
			// Allow the API access to this SWF
			Security.allowDomain(apiPath);
 
			// Load the API
			var request:URLRequest = new URLRequest(apiPath);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, Kong.reset);
			loader.load(request);
			s.addChild(loader);
		}
		
		
		
		/**
		 * reset
		 * @description		resets the API. Call this if you want to regather all data
		 * @param			e: event passed ffrom the loader's contentloaderinfo's event listener upon load completion
		 */
		public static function reset(e:Event = null):void
		{
			if (e != null)
			{
				e.target.content.services.connect();
				initAPI(e.target.content, null);
			}
			else
			{
				Kong.getPlayerInfoCallback = null;
				initAPI(Kong._api, null);
			}
			
		}
		
		
		
		
		
		
		
		
		/**
		 * initAPI
		 * @description		sets the API
		 * @param			kongAPI: the kong API returned from loading it
		 * @param			callback: the function to be called when completed
		 */
		public static function initAPI(kongAPI:*, callback:Function):void
		{
			try {
				
				if(kongAPI != null)
				{
					Kong._api = kongAPI;
					Kong.chat = kongAPI.chat;
					Kong.services = kongAPI.services;
					Kong.stats = kongAPI.stats;
					Kong.mtx = kongAPI.mtx;
					Kong.sharedContent =  kongAPI.sharedContent;
					Kong.images = kongAPI.images;
					
					Kong.extractApiData();
					if (callback != null)
					{
						Kong.getPlayerInfoCallback = callback;
					}
					Kong.getPlayerInfo(false);
				}
				else
				{
					throw new Error("[Kong] Error: The Kongregate API passed into initAPI is null");
				}
			} catch (e:Error)
			{
				//do nothing
				trace("\n\n[Kong] PREVENTED: " + e + "\n[Kong] Local Testing causes some APIs to be unavaibale\n\n");
			}
		}
		private static function extractApiData():void
		{
			if(Kong._api)
			{
				Kong._userName = Kong._api.services.getUsername();
				try{
					Kong._userID = Kong._api.services.getUserId();
					Kong._userToken = Kong._api.services.getGameAuthToken();
				} catch(e:Error) {
					trace("\n\n[Kong] PREVENTED: " + e + "\n[Kong] userID is now 0.\n[Kong] userToken is empty\n\n");
					Kong._userID = "0";
					Kong._userToken = "";
				}
			}
			else
			{
				throw new Error("[Kong] Error: Kong._api is not defined. Call method Kong.initAPI() or Kong.connectToKong() prior to this to define the api");				
			}
			
		}
		
		
		
		/**
		 * getPlayerInfo
		 * @description		gets information about the player
		 * @param			callback: function called on callback
		 * @param			getFriends: default as false. Functionality will be added later
		 */
		private static function getPlayerInfo(getFriends:Boolean = false):void
		{
			var request:URLRequest = new URLRequest("http://api.kongregate.com/api/user_info.json?username=" + _userName + "&friends=" + getFriends.toString());
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, catchIOError); //catch if username does not exist
			loader.addEventListener(Event.COMPLETE, loadedPlayerInfo);
			loader.load(request); 
		}
		private static function catchIOError(e:Error):void
		{
			trace("\n\n[Kong] PREVENTED Error: Username " + Kong._userName + " does not exist.\n\n");
			//callback			
			if(Kong.getPlayerInfoCallback != null)
			{
				Kong.getPlayerInfoCallback(e);
			}
		}
		private static function loadedPlayerInfo(event:Event):void
		{
			var load:URLLoader = URLLoader(event.target);
			var playerData:Object = JSON.decode(load.data);
			
			if(playerData.success)
			{
				Kong.isDev = playerData.user_vars.developer;
				Kong.isCurator = playerData.user_vars.curator;
				Kong.isForumMod = playerData.user_vars.forum_moderator;
				Kong.isMod = playerData.user_vars.moderator;
				Kong.isAdmin = playerData.user_vars.admin;
				
				Kong.age = playerData.user_vars.age;
				Kong.level = playerData.user_vars.level;
				Kong.points = playerData.user_vars.points;
				Kong.avatarURL = playerData.user_vars.avatar_url;
				Kong.chatAvatarURL = playerData.user_vars.levelbug_url;
				Kong.levelIconURL = playerData.user_vars.chat_avatar_url;
				
				Kong.numFriendsOnline = playerData.user_vars.friends_online_count;
				Kong.numUnreadShouts = playerData.user_vars.unread_shouts_count;
				Kong.numUnreadWhispers = playerData.user_vars.unread_whispers_count;
				Kong.numKreds = playerData.user_vars.kreds_balance;
				
				Kong.silencedUntil = playerData.user_vars.silenced_until;
			}
			else
			{
				trace("\n\n[Kong] PREVENTED Error: Retrieving User Data Failed.\nData set to default values\n\n");
			}
			
			//callback
			if(Kong.getPlayerInfoCallback != null)
			{
				Kong.getPlayerInfoCallback(null);
			}
		}
			
			
		
		
		
		
		
		
		
		
		
		
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		//these methods soon to be deleted
		
		public static function createChatTab(Name:String,Description:String,Options:Object):void
		{
			if(Options == null)
			{
				Options = {size:1};
			}
			Kong._api.chat.showTab(Name,Description,Options);
		}		
		public static function closeTab():void
		{
			Kong._api.chat.closeTab();
		}
		
		public static function getChatCanvasSize():Object
		{
			return Kong._api.chat.getCanvasSize();
		}
		public static function displayChatCanvasText(Name:String, Text:String, Position:Object, TextFormatObject:Object):void
		{
			//Kong Documentation Error: they have lowercase t in text on example
			Kong._api.chat.displayCanvasText(Name, Text, Position, TextFormatObject);
		}
		
		public static function sendMessage(Message:String,Username:String):void
		{
			Kong._api.chat.displayMessage(Message,Username);
		}
		public static function clearMessages():void
		{
			Kong._api.chat.clearMessages();
		}
		
		
		public static function onChatTabVisible(Callback:Function):void
		{
			Kong._api.chat.addEventListener("tab_visible",Callback);
		}
		
		public static function onChatMessage(Callback:Function):void
		{
			//Callback has to take in event:*;
			//Documented Data:
			//	e.data.text = message
			
			//Undocumented Data:
			//	e.data.username = username
			Kong._api.chat.addEventListener("message",Callback);
		}
	}
}

