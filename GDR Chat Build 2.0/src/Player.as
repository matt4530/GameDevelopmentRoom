package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ugLabs.net.Kong;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Player extends Sprite
	{
		public var ID:String = "";
		public var UserName:String = "UnknownGuardian";
		public var Status:String = "Norm";
		public var Color:String = "0x000000";
		public var Type:String = "Mod";
		
		private var field:TextField;
		private var icon:Sprite;
		private var silenceIcon:Sprite;
		
		public function Player(id:String, n:String, t:String, c:String, s:String) 
		{
			ID = id;
			UserName = n;// "CAKE-" + String.fromCharCode(int(Math.random() * 16) + 64);
			Type = t;// Math.random() > 0.5 ? "Dev" : Math.random() > 0.5 ? "Mod" : Math.random() > 0.5 ? "Admin" : "Reg";
			Status = s;
			Color = c;
			
			field = new TextField();
			field.defaultTextFormat = new TextFormat("Arial", field.width > 230 ? 14 : 16, 0x000000, true);
			field.text = UserName;
			field.selectable = false;
			field.autoSize = "left";
			addChild(field);
			
			if (Type == "Dev")
			{
				icon = new UserTypeDevIcon();
				icon.x = 220;
				icon.y = 10;
				addChild(icon);
			}
			else if (Type == "Mod")
			{
				icon = new UserTypeModIcon();
				icon.x = 220;
				icon.y = 10;
				addChild(icon);
			}
			else if (Type == "Reg")
			{
				icon = new UserTypeRegIcon();
				icon.x = 220;
				icon.y = 10;
				addChild(icon);
			}
			else
			{
				icon = new UserTypeAdminIcon();
				icon.x = 220;
				icon.y = 10;
				addChild(icon);
			}
			
			//if(UserName == Kong.userName && (Type == "Mod" || Type == "Admin"))
			trace("[Player][init] " + Kong.userName + Main.chatDisplay.isUserAdmin(Kong.userName) + Main.chatDisplay.isUserMod(Kong.userName) );
			
			if ((UserName == Kong.userName && (Type == "Mod" || Type == "Admin")) || (Main.chatDisplay.isUserAdmin(Kong.userName) || Main.chatDisplay.isUserMod(Kong.userName)) )
			{
				silenceIcon = new UserSilenceToggle();
				silenceIcon.x = 205 - silenceIcon.width - 2;
				silenceIcon.y = 10;
				silenceIcon.alpha = 0.3;
				silenceIcon.buttonMode = true;
				addChild(silenceIcon);
				
				silenceIcon.addEventListener(MouseEvent.CLICK, toggleSilencePlayer);
			}
			
			field.addEventListener(MouseEvent.CLICK, gotoProfile);
		}
		
		public function toggleSilencePlayer(e:MouseEvent = null):void
		{
			//TODO don't toggle or even show if user is not a mod admin
			if (Status == "Silenced")
			{
				Status = "AFK";
				silenceIcon.alpha = 0.3;
				silenceIcon.x = 205 - silenceIcon.width - 2;
				Main.chatDisplay.sendMessage("/unsilenceUser " + UserName);
			}
			else
			{
				Status = "Silenced";
				silenceIcon.alpha = 1;
				silenceIcon.x = 205;
				Main.chatDisplay.sendMessage("/silenceUser " + UserName);
			}
		}
		
		public function silenceMessageEvent(m:String):void
		{
			if (m == "unsilence")
			{
				silenceIcon.alpha = 0.3;
				silenceIcon.x = 205 - silenceIcon.width - 2;
			}
			else
			{
				silenceIcon.alpha = 1;
				silenceIcon.x = 205;
			}
		}
		
		public function gotoProfile(e:MouseEvent):void
		{
			if (e.currentTarget != silenceIcon)
			{
				navigateToURL(new URLRequest("http://www.kongregate.com/accounts/" + UserName));
			}
		}
		
	}

}