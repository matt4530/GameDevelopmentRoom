package  
{
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import playerio.DatabaseObject;
	import ugLabs.net.Kong;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class KongChat
	{
		private static var isCreated:Boolean = false;
		private static var lastGiTDUpdate:int = 0;
		private static var DebugLevel:int = 0;
		public function KongChat() 
		{
			
		}
		
		public static function init():void
		{
			if (isCreated)
				return;
			
			Kong.chat.showTab("GiTD", "Debug", { size:0.5 } );
			Kong.chat.addEventListener("tab_visible", onTabShown);
			Kong.chat.addEventListener("message", onPlayerMessage);
			isCreated = true;
		}
		
		static private function onPlayerMessage(e:*):void 
		{
			var m:String = e.data.text;
			
			/*if (DebugLevel == 2)
			{
				log("Event: " + e);
				log("Data: " + e.data);
				log("username: " + e.data.username);
				log("Message: " + e.data.text);
				debug_object(e.data);
			}*/
			
			if (m == "/dev")
			{
				Kong.chat.displayMessage("Do NOT share the auth token with anyone. Change your Kongregate password immediately if you accidentally share your token. Abuse of this feature will result in a permanent ban on your account.","GDR");
				Kong.chat.displayMessage(Kong.userId,">User ID");
				Kong.chat.displayMessage(Kong.userToken, ">Auth Token");
				Kong.chat.displayMessage("  ","GDR");
			}
			else if (m == "/rev")
			{
				var revURL:String = "http://www.kongregate.com/accounts/" + Kong.userName + "/revenue_summary";
				Kong.chat.displayMessage(revURL, "GDR");
				navigateToURL(new URLRequest(revURL));
			}
			/*else if (m == "/log 0")
			{
				DebugLevel = 0;
			}
			else if (m == "/log 1")
			{
				DebugLevel = 1;
			}
			else if (m == "/log 2")
			{
				DebugLevel = 2;
			}*/
			else if (m == "/contest")
			{
				forceGiTDLoad();
				
				//Kong.chat.displayMessage("#25 is coming soon! Run by UnknownGuardian","GiTD");
				//Kong.chat.displayMessage("#2 is coming soon! Run by Senekis93","PGGC");
			}
			else if (m == "/clear")
			{
				Kong.chat.clearMessages();
			}
			else if (m == "/help")
			{
				//Kong.chat.clearMessages();
				Kong.chat.displayMessage("/dev   >Develop GDR Locally","GDR");
				Kong.chat.displayMessage("/contest   >Check upcoming contests","GDR");
				Kong.chat.displayMessage("/help  >You must be really lost","GDR");
			}
		}
		
		static private function forceGiTDLoad():void
		{
			Kong.chat.clearMessages();
			Kong.chat.displayCanvasImage("GiTDHeader", "http://i.imgur.com/5eAr1hm.png", { x:0, y:0 } );
			Main.client.bigDB.load("GiTD", "content", onGotGiTDInfo);
		}
		
		static private function onGotGiTDInfo(dbo:DatabaseObject):void 
		{
			if (getTimer() - lastGiTDUpdate < 1500)
				return;
				
			lastGiTDUpdate = getTimer();
			
			if (dbo["image"] && dbo["image"].indexOf("http://") == 0)
				Kong.chat.displayCanvasImage("GiTDHeader", dbo["image"], { x:0, y:0 } );
			else
				Kong.chat.displayCanvasImage("GiTDHeader", "http://i.imgur.com/5eAr1hm.png", { x:0, y:0 } );
			
			if (dbo["message"] && dbo["message"].length > 0)
				Kong.chat.displayMessage(dbo["message"],"GDR");
			else
				Kong.chat.displayMessage("Check the Programming forums for upcoming GiTD events.","GDR");
			
			
		}
		
		static private function onTabShown(e:Event):void 
		{
			forceGiTDLoad();
			//Kong.chat.clearMessages();
			//Kong.chat.displayCanvasImage("APIHeader", "http://i.imgur.com/oksxs.png", { x:0, y:0 } );
			//Kong.chat.displayMessage("API Ready...", "GDR");
			//Kong.chat.displayMessage("Developers can create their own util methods for GDR! Make suggestions in the GDR thread. http://www.kongregate.com/forums/4-game-programming/topics/93529-game-development-room-gdr. A list of commands is found with /help","GDR");
		}
		
		
		static public function log(t:String):void 
		{
			return;
			
			
			
			if (DebugLevel == 0) return;
			
			if (!isCreated && Kong.userName == "UnknownGuardian")
			{
				init();				
			}
			Kong.chat.displayMessage(t,"Log");
		}
		
		static public function debug_object(o:Object):void
		{			
			import flash.utils.*;
			var def:XML       = describeType(o);
			log(def);
		}
	}

}