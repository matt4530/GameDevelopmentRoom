package ugLabs.net
{
	/**
	 * BetterKong by UnknownGuardian. November 24th 2010.
	 * Visit http://profusiongames.com/ and http://github.com/UnknownGuardian
	 *
	 * Copyright (c) 2010 ProfusionGames
	 *    All rights reserved.
	 *
	 * Permission is hereby granted, free of charge, to any person
	 * obtaining a copy of this software and associated documentation
	 * files (the "Software"), to deal in the Software without
	 * restriction, including without limitation the rights to use,
	 * copy, modify, merge, publish, distribute, sublicense, and/or sell
	 * copies of the Software, and to permit persons to whom the
	 * Software is furnished to do so, subject to the following
	 * conditions:
	 *
	 * ^ Attribution will be given to:
	 *  	UnknownGuardian http://www.kongregate.com/accounts/UnknownGuardian
	 *
	 * ^ Redistributions of source code must retain the above copyright notice,
	 * this list of conditions and the following disclaimer in all copies or
	 * substantial portions of the Software.
	 *
	 * ^ Redistributions of modified source code must be marked as such, with
	 * the modifications marked and ducumented and the modifer's name clearly
	 * listed as having modified the source code.
	 *
	 * ^ Redistributions of source code may not add to, subtract from, or in
	 * any other way modify the above copyright notice, this list of conditions,
	 * or the following disclaimer for any reason.
	 *
	 * ^ Redistributions in binary form must reproduce the above copyright
	 * notice, this list of conditions and the following disclaimer in the
	 * documentation and/or other materials provided with the distribution.
	 *
	 * THE SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
	 * IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
	 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
	 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
	 * OR COPYRIGHT HOLDERS OR CONTRIBUTORS  BE LIABLE FOR ANY CLAIM, DIRECT,
	 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
	 * OR OTHER LIABILITY,(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
	 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
	 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
	 * WHETHER AN ACTION OF IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
	 * NEGLIGENCE OR OTHERWISE) ARISING FROM, OUT OF, IN CONNECTION OR
	 * IN ANY OTHER WAY OUT OF THE USE OF OR OTHER DEALINGS WITH THIS
	 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * English: Use, distributed, etc to this with keeping credits and copyright
	 */

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
	public class BetterKong
	{
		private static var _instance:Kong;
		private static var _okToCreate:Boolean = false;
		
		public static var api:* = null;
		
		public static var chat:* = null;
		public static var services:* = null;
		public static var stats:* = null;
		public static var mtx:* = null;
		public static var sharedContent:* = null;
		public static var images:* = null;
		
		
		public static var userName:String = "";
		public static var userID:String = "";
		public static var userToken:String = "";
		
		public static var isGuest:Boolean = false;
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
		
		
		//private stuff used in methods
		private static var getPlayerInfoCallback:Function;
		
		
		
		
		
		public function BetterKong()
		{
			if( !BetterKong._okToCreate ){
				throw new Error("[BetterKong] Error: " + this + " is not a singleton and must be accessed with the getInstance() method");				
			}
		}
		
		public static function getInstance():Kong
		{
			if( !BetterKong._instance ){
				BetterKong._okToCreate = true;
				BetterKong._instance = new Kong();
				BetterKong._okToCreate = false;
			}
			return BetterKong._instance;
		}
		
		
		
		/**
		 * connectToKong
		 * @description		connects to kong for you, like a good little method
		 * @param			s: the stage that kong connects to
		 * @param			callback: the function to be called when completed, signals that player info is to be gathered.
		 */
		public static function connectToKong(s:Stage):void//, callback:Function):void
		{
			//if (callback != null)
			//{
			//	BetterKong.getPlayerInfoCallback = callback;
			//}
			
			//grab the loaderinfo param
			var paramObj:Object = LoaderInfo(s.root.loaderInfo).parameters;
 
			// The API path. The "shadow" API will load if testing locally.
			var apiPath:String = paramObj.kongregate_api_path ||"http://www.kongregate.com/flash/API_AS3_Local.swf";
 
			// Allow the API access to this SWF
			Security.allowDomain(apiPath);
 
			// Load the API
			var request:URLRequest = new URLRequest(apiPath);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, BetterKong.loadedAPI);
			loader.load(request);
			s.addChild(loader);
		}
		
		
		
		private static function loadedAPI(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, BetterKong.loadedAPI);
			api = e.target.content;
			api.services.connect();
			trace("[BetterKong] Loaded Kongregate API");
			
			chat = api.chat;
			services = api.services;
			stats = api.stats;
			mtx = api.mtx;
			sharedContent =  api.sharedContent;
			
			//local cannot load images API
			try	{
				images = api.images;
			}
			catch (e:Error) { }
			
			//extract basic data.
			isGuest = services.isGuest();
			userName = services.getUsername();
			
			//local cannot load user id
			try	{
				userID = services.getUserID();
			}
			catch (e:Error) { }
			userToken = services.getGameAuthToken();
		}
		
		
		/**
		 * getPlayerInfo
		 * @description		gets information about the player
		 * @param			callback: function called on callback
		 */
		public static function getPlayerInfo(callback:Function = null):void
		{
			var request:URLRequest = new URLRequest("http://api.kongregate.com/api/user_info.json?username=" + userName);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, catchIOError); //catch if username does not exist
			loader.addEventListener(Event.COMPLETE, loadedPlayerInfo);
			loader.load(request); 
			getPlayerInfoCallback = callback;
		}
		private static function catchIOError(e:Error):void
		{
			trace("[BetterKong] Error: Username " + BetterKong.userName + " does not exist.\nPlayerInfo not retrieved.");
		}
		private static function loadedPlayerInfo(event:Event):void
		{
			var load:URLLoader = URLLoader(event.target);
			var playerData:Object = JSON.decode(load.data);
			
			if(playerData.success)
			{
				BetterKong.isDev = playerData.user_vars.developer;
				BetterKong.isCurator = playerData.user_vars.curator;
				BetterKong.isForumMod = playerData.user_vars.forum_moderator;
				BetterKong.isMod = playerData.user_vars.moderator;
				BetterKong.isAdmin = playerData.user_vars.admin;
				
				BetterKong.age = playerData.user_vars.age;
				BetterKong.level = playerData.user_vars.level;
				BetterKong.points = playerData.user_vars.points;
				BetterKong.avatarURL = playerData.user_vars.avatar_url;
				BetterKong.chatAvatarURL = playerData.user_vars.levelbug_url;
				BetterKong.levelIconURL = playerData.user_vars.chat_avatar_url;				
			}
			else
			{
				trace("[BetterKong] Error: Retrieving User Data Failed.\nData set to default values");
			}
			
			//callback
			if(BetterKong.getPlayerInfoCallback != null)
			{
				BetterKong.getPlayerInfoCallback();
			}
		}
	}
}

