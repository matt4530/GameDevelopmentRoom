package  
{
	import fl.controls.UIScrollBar;
	import fl.events.ScrollEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class PlayerList extends Sprite
	{
		public var verticalScroll:UIScrollBar;
		public var players:Vector.<Player> = new Vector.<Player>();
		
		public var playerContainer:Sprite;
		
		public function PlayerList() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0xFFFFFF, 0);
			sprite.graphics.drawRect(0, 0, 243, 148);
			sprite.graphics.endFill();
			addChild(sprite);
			mask = sprite;
			
			
			verticalScroll = new UIScrollBar();
			verticalScroll.x = 240 - 10;
			verticalScroll.y = 0;
			verticalScroll.height = 148;
			verticalScroll.enabled = true;
			verticalScroll.minScrollPosition = 0;
			verticalScroll.pageSize = mask.height;
			verticalScroll.maxScrollPosition = 150;
			verticalScroll.addEventListener(ScrollEvent.SCROLL, scrollList);
			addChild(verticalScroll);
			
			playerContainer = new Sprite();
			addChild(playerContainer);
		}
		public function scrollList(e:ScrollEvent):void
		{
			playerContainer.y = -e.position + mask.y;
		}
		
		public function addPlayer(p:Player):void
		{
			players.push(p);
			playerContainer.addChild(p);
			redisplay();
		}
		
		public function removePlayerFromID(id:String):void
		{
			for (var i:int = 0; i < players.length; i++)
			{
				if (players[i].ID == id)
				{
					var p:Player = players[i];
					players.splice(i, 1);
					p.remove();
					redisplay();
					return;
				}
			}
		}
		
		public function getPlayerFromID(id:String):Player
		{
			for (var i:int = 0; i < players.length; i++)
			{
				if (players[i].ID == id)
				{
					return players[i];
				}
			}
			return null;
		}
		
		public function getPlayerFromName(n:String):Player
		{
			for (var i:int = 0; i < players.length; i++)
			{
				if (players[i].UserName == n)
				{
					return players[i];
				}
			}
			return null;
		}
		
		public function removePlayer(p:Player):void
		{
			players.splice(players.indexOf(p), 1);
			p.remove();
			redisplay();
		}
		public function removeAllPlayers():void
		{
			while (players.length > 0)
			{
				players.pop().remove();
			}
			redisplay();
		}
		public function redisplay():void
		{
			var admins:Array = [];
			var mods:Array = [];
			var devs:Array = [];
			var regs:Array = [];
			for (var i:int = 0; i < players.length; i++)
			{
				if (players[i].Type == "Admin")	{
					admins.push(players[i]);
				} else if (players[i].Type == "Mod") {
					mods.push(players[i]);
				} else if (players[i].Type == "Dev") {
					devs.push(players[i]);
				} else if (players[i].Type == "Reg") {
					regs.push(players[i]);
				}
			}
			
			admins.sort(sortName);
			mods.sort(sortName);
			devs.sort(sortName);
			regs.sort(sortName);
			
			for (i = 0; i < admins.length; i++)
			{
				admins[i].y = admins[i].height * i;
			}
			for (i = 0; i < mods.length; i++)
			{
				mods[i].y = mods[i].height * (i+admins.length);
			}
			for (i = 0; i < devs.length; i++)
			{
				devs[i].y = devs[i].height * (i+admins.length+mods.length);
			}
			for (i = 0; i < regs.length; i++)
			{
				regs[i].y = regs[i].height * (i+admins.length+mods.length+devs.length);
			}
			verticalScroll.minScrollPosition = 0;
			var max:int = playerContainer.height - mask.height
			max < 0 ? max = 0 : null;
			verticalScroll.pageSize = mask.height;
			verticalScroll.maxScrollPosition = max;
		}
		
		/*
		public function banUserFromID(id:String):void
		{
			getPlayerFromID(id).banPlayer();
		}
		public function banUserFromName(n:String):void
		{
			getPlayerFromName(b).banPlayer();
		}
		*/
		
		private function sortName(a:Player, b:Player):Number {
			if(a.UserName > b.UserName ) {
				return 1;
			} else if(a.UserName < b.UserName) {
				return -1;
			} else  {
				return 0; //perhaps have a disconnect here? Identical usernames = fail.
			}
		}

	}

}