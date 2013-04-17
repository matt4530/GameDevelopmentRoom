package  
{
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import ugLabs.net.Kong;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class KongChat
	{
		private static var isCreated:Boolean = false;
		private static var DebugLevel:int = 0;
		public function KongChat() 
		{
			
		}
		
		public static function init():void
		{
			Kong.chat.showTab("Debug", "Debug", { size:0.5 } );
			Kong.chat.addEventListener("tab_visible", onTabShown);
			Kong.chat.addEventListener("message", onPlayerMessage);
			isCreated = true;
		}
		
		static private function onPlayerMessage(e:*):void 
		{
			var m:String = e.data.text;
			
			if (DebugLevel == 2)
			{
				log("Event: " + e);
				log("Data: " + e.data);
				log("username: " + e.data.username);
				log("Message: " + e.data.text);
				debug_object(e.data);
			}
			
			if (m == "/dev")
			{
				Kong.chat.displayMessage("Do NOT share the auth token with anyone. Change your Kongregate password immediately if you accidentally share your token. Abuse of this feature will result in a permanent ban on your account.","GDR");
				Kong.chat.displayMessage(Kong.userId,">User ID");
				Kong.chat.displayMessage(Kong.userToken, ">Auth Token");
				Kong.chat.displayMessage("  ","GDR");
			}
			else if (m == "/rev")
			{
				Kong.chat.displayMessage("http://www.kongregate.com/accounts/" + e.data.username + "/revenue_summary", "GDR");
				navigateToURL(new URLRequest("http://www.kongregate.com/accounts/" + e.data.username + "/revenue_summary"));
			}
			else if (m == "/log 0")
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
			}
			else if (m == "/contests")
			{
				Kong.chat.clearMessages();
				Kong.chat.displayMessage("#25 is coming soon! Run by UnknownGuardian","GiTD");
				Kong.chat.displayMessage("#2 is coming soon! Run by Senekis93","PGGC");
			}
			else if (m == "/help")
			{
				Kong.chat.clearMessages();
			  //Kong.chat.displayMessage("Do NOT share the auth token with anyone.", "GDR");
				Kong.chat.displayMessage("/dev   >Develop GDR Locally","GDR");
				Kong.chat.displayMessage("/rev   >Check your Kong revenue quick","GDR");
				Kong.chat.displayMessage("/log 0   >Turn logging off","GDR");
				Kong.chat.displayMessage("/log 1   >Recieve basic logs","GDR");
				Kong.chat.displayMessage("/log 2   >Recieve advanced logs","GDR");
				Kong.chat.displayMessage("/contests   >Check upcoming contests","GDR");
				Kong.chat.displayMessage("/help  >You must be really lost","GDR");
			}
		}
		
		static private function onTabShown(e:Event):void 
		{
			Kong.chat.clearMessages();
			Kong.chat.displayCanvasImage("APIHeader", "http://i.imgur.com/oksxs.png", { x:0, y:0 } );
			Kong.chat.displayMessage("API Ready...", "GDR");
			Kong.chat.displayMessage("Developers can create their own util methods for GDR! Make suggestions in the GDR thread. http://www.kongregate.com/forums/4-game-programming/topics/93529-game-development-room-gdr. A list of commands is found with /help","GDR");
		}
		
		
		static public function log(t:String):void 
		{
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
