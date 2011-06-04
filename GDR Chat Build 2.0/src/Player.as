package  
{
	import flash.display.Sprite;
	import flash.events.Event;
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
		public var isCollaborator:Boolean = false;
		
		private var field:TextField;
		private var icon:Sprite;
		private var silenceIcon:Sprite;
		private var collabIcon:Sprite;
		public var collabNames:Array = ["Rivaledsouls", "truefire", "jonathanasdf", "ST3ALTH15", "skyboy", "draganviper", "qwerber", "darkscanner", "FlashSmith", "mage_ruler9", "Siveran", "DPbrad", "mikebolt", "Senekis93", "UnknownGuardian", "ratkillcat", "simplegoogly", "lobstershow", "GamerFefan", "Flexcool354", "cashughes", "TheWhiteAngel", "BraydenBlack", "nojkimserious", "turoni", "DannyDaNinja"];
		
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
				//Color = "0xD77A41";
			}
			else if (Type == "Reg")
			{
				icon = new UserTypeRegIcon();
				icon.x = 220;
				icon.y = 10;
				addChild(icon);
			}
			else if(Type == "Admin")
			{
				icon = new UserTypeAdminIcon();
				icon.x = 220;
				icon.y = 10;
				addChild(icon);
				//Color = "0xCC0033";
			}
			if (Status == "AFK")
			{
				setToAFK();
			}
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(MouseEvent.ROLL_OVER, rOver);
			addEventListener(MouseEvent.ROLL_OUT, rOut);
		}
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//if(UserName == Kong.userName && (Type == "Mod" || Type == "Admin"))
			trace("[Player][init] " + Kong.userName + Main.chatDisplay.isUserAdmin(Kong.userName) + Main.chatDisplay.isUserMod(Kong.userName) );
			//(UserName == Kong.userName && (Type == "Mod" || Type == "Admin"))||
			trace("[Player][init][indexOf] = " + Main.playerList.players);
			if (  (Main.chatDisplay.isUserAdmin(Kong.userName) || Main.chatDisplay.isUserMod(Kong.userName)) )
			{
				silenceIcon = new UserSilenceToggle();
				silenceIcon.x = 205 - silenceIcon.width - 2;
				silenceIcon.y = 10;
				silenceIcon.alpha = 0.3;
				silenceIcon.buttonMode = true;
				addChild(silenceIcon);
				
				silenceIcon.addEventListener(MouseEvent.CLICK, toggleSilencePlayer);
			}
			
			if (collabNames.indexOf(UserName) >= 0)
			{
				collabIcon = new UserTypeCollabIcon();
				collabIcon.x = 170;
				collabIcon.y = 10;
				collabIcon.buttonMode = true;
				addChild(collabIcon);
				collabIcon.addEventListener(MouseEvent.CLICK, gotoCollab);
				
				isCollaborator = true;
			}
			
			
			field.addEventListener(MouseEvent.CLICK, gotoProfile);
			
		}
		
		private function gotoCollab(e:MouseEvent):void 
		{
			navigateToURL(new URLRequest("http://kongcollab.xtreemhost.com/forums/index.php"));
		}
		
		public function toggleSilencePlayer(e:MouseEvent = null):void
		{
			//TODO don't toggle or even show if user is not a mod admin
			if (Status == "Silenced")
			{
				//Status = "AFK";
				//silenceIcon.alpha = 0.3;
				//silenceIcon.x = 205 - silenceIcon.width - 2;
				Main.chatDisplay.sendMessage("/unsilence " + UserName);
			}
			else
			{
				//Status = "Silenced";
				//silenceIcon.alpha = 1;
				//silenceIcon.x = 205;
				Main.chatDisplay.sendMessage("/silence " + UserName);
			}
		}
		
		public function silenceMessageEvent(m:String):void
		{
			if (m == "unsilence")
			{
				Status = "AFK";
				if (silenceIcon) //not mod or admin, so don't have
				{
					silenceIcon.alpha = 0.3;
					silenceIcon.x = 205 - silenceIcon.width - 2;
				}
			}
			else
			{
				Status = "Silenced";
				if (silenceIcon) //not mod or admin, so don't have
				{
					silenceIcon.alpha = 1;
					silenceIcon.x = 205;
				}
			}
		}
		
		public function gotoProfile(e:MouseEvent):void
		{
			if (e.currentTarget != silenceIcon && e.currentTarget != collabIcon)
			{
				navigateToURL(new URLRequest("http://www.kongregate.com/accounts/" + UserName));
			}
		}
		
		public function rOver(e:MouseEvent):void
		{
			graphics.beginFill(0x999999, 0.2);
			graphics.drawRect(0, 0, width + 4, height);
			graphics.endFill();
		}
		public function rOut(e:MouseEvent):void
		{
			graphics.clear();
		}
		
		public function setToAFK():void
		{
			field.textColor = 0x909090;
			Status = "AFK";
		}
		public function setToBack():void
		{
			field.textColor = 0x000000;
			Status = "Norm";
		}
		
		public function setColor(c:String):void
		{
			Color = c;
		}
		
		public function remove():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, rOver);
			removeEventListener(MouseEvent.ROLL_OUT, rOut);
			field.removeEventListener(MouseEvent.CLICK, gotoProfile);
			if (silenceIcon)
			{
				silenceIcon.removeEventListener(MouseEvent.CLICK, toggleSilencePlayer);
			}
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
			parent.removeChild(this);
		}
	}

}