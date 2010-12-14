package 
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import ugLabs.net.Kong;
	
	import SWFStats.*;
	
	public class ChatInputManager
	{
		//scroll model
		public var scrollBox:LinkScrollBox;

		
		public function ChatInputManager():void
		{
			Kong.createChatTab("GDR Help", "Get help on how to use GDR", {size:0.5});
			Kong.onChatTabVisible(displayGreeting);
		}
		
		public function displayGreeting(e:Event):void
		{
			Kong.clearMessages();
			Kong.sendMessage("Welcome to the really, really awesome looking GDR help center. With this new colorful and creative help center, you can type in a command listed above.", "GDR");
			Kong.displayChatCanvasText("Title","GDR HELP", {align:"tr"}, {font:"Verdana",size:30,color:0x333333});
			var c:String = "Commands\n\n" + "/explain\n" + "/help\n" + "/unicorn\n" + "/myrevenue\n" + "/mykredrevenue\n" + "/myinfo\n" + "/clear\n" 
			Kong.displayChatCanvasText("CommandList",c, {align:"tl"}, {font:"Verdana",size:12,color:0x333333});
			Kong.displayChatCanvasText("Credits","Profusion", {align:"br"}, {font:"Verdana",size:10,color:0xCC0033});
			Kong.onChatMessage(handleMessage);
			
			Kong.sendMessage("Type the commands below", "GDR");
		}
		
		public function handleMessage(event:*):void
		{
			trace("Event: " + event);
			trace("Data: " + event.data);
			trace("username: " + event.data.username);
			trace("Message: " + event.data.text);
			var m:String = event.data.text;
			m = m.toLowerCase();
			switch(m)
			{
				case "/explain":
					Kong.sendMessage("Hello " + Kong._userName, "GDR");
					if(Kong.isDev)
					{
						Kong.sendMessage("I see that you are a developer. This chat is specifically designed to aid developers in getting and giving help.", "GDR");
						Kong.sendMessage("You can post code in the Code Box Tab to easily share code with other developers, and you can also rapidly solve problems", "GDR");
					}
					else
					{
						Kong.sendMessage("I see that you are not a developer. Would you like to become one? This game will make that possibility become even easier", "GDR");
						Kong.sendMessage("In GDR, you can learn to make games, and learn how to make money off of them. Feel free to ask questions in the chat ", "GDR");
					}
					break;
				case "/help":
					Kong.sendMessage("Below is a list of commands used in GDR", "GDR");
					Kong.sendMessage("/muteSound - Mutes the AFK Sound", "GDR");
					Kong.sendMessage("/unmuteSound - Unmutes the AFK Sound", "GDR");
					Kong.sendMessage("CodeShortlink - Posts and links the shortlink in chat", "GDR");
					if(Kong.isMod)
					{
						Kong.sendMessage("/silenceUser USERAME -Silences the named user.", "GDR");
					}
					break;
				case "/unicorn":
					Kong.sendMessage("Believe!", "GDR");
					break;
				case "/myrevenue":
					navigateTo({loc:"http://www.kongregate.com/my_revenue_summaries"});
					break;
				case "/mykredrevenue":
					navigateTo({loc:"http://www.kongregate.com/my_kred_revenue"});
					break;
				case "/myinfo":
					Kong.sendMessage("You've been busy, " + Kong._userName, "GDR");
					Kong.isDev? Kong.sendMessage("You are a developer", "GDR") :null;
					Kong.isCurator? Kong.sendMessage("You are a curator", "GDR") :null;
					Kong.isMod? Kong.sendMessage("You are a moderator", "GDR") :null;
					Kong.isForumMod? Kong.sendMessage("You are a forum moderator", "GDR") :null;
					Kong.isAdmin? Kong.sendMessage("You are an administrator", "GDR") :null;
					
					(Kong.age > 0)? Kong.sendMessage("You are " + Kong.age + " years old", "GDR") :null;
					(Kong.level > 0)? Kong.sendMessage("You are level " + Kong.level, "GDR") :null;
					Kong.sendMessage("You have " + Kong.points + " points", "GDR");
					
					//Kong.sendMessage("You have " +  Kong.numFriendsOnline + " friends online", "GDR");
					//Kong.sendMessage("You have " +  Kong.numUnreadShouts + " unread Shouts", "GDR");
					//Kong.sendMessage("You have " +  Kong.numUnreadWhispers + " unread Whispers", "GDR");
					//Kong.sendMessage("You have " +  Kong.numKreds + " kreds", "GDR");
					
					(Kong.silencedUntil != null)? Kong.sendMessage("You are silenced until " + Kong.silencedUntil, "GDR") :null;
					break;
				case "/suggest":
					navigateTo({loc:"http://www.kongregate.com/forums/4-programming/topics/93529-game-development-room-gdr"});
					break;
				case "/clear":
					Kong.clearMessages();
					break;
					
				default:
					break;
			}
		}
		
		
		
		private function navigateTo(obj:Object):void
		{
			Log.CustomMetric("Navigated to " + obj.loc, "ChatInputManager");
			navigateToURL( new URLRequest(obj.loc));
		}
		
		public function debug_object(o:Object):void
		{
			import flash.utils.*;
			var def:XML       = describeType(o);
			trace(def);
		}
	}	
}
