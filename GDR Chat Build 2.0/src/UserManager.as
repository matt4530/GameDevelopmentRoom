package {

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.Font;
	import playerio.*;
	import com.greensock.TweenLite;
	import ugLabs.util.Align;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import SWFStats.*;

	public class UserManager extends Sprite {

		private var _container:Sprite;
		private var _item:Item;
		private var _itemTextField:TextField;
		private var _defaultFormat:TextFormat = new TextFormat();
		private var _arialRounded:Font = new ArialRounded();
		private var _textFieldXPosition:uint = 10;
		private var _textFieldYPosition:uint = 6;
		private var _textFieldWidth:uint = 270;
		private var _textFieldHeight:uint = 12;
		private var _itemPosition:uint = 20;
		private var _mask:Shape;
		private var _maskWidth:uint = 210;
		private var _maskHeight:uint = 150;
		private var _paddingTop:uint = 0;
		private var _background:Shape;
		private var _maxSpeed:uint = 5;
		private var _speed:Number;
		private var _chat:Sprite
		public var users:Object = {};

		public function UserManager (s:Sprite) {
			this._chat = s;
		}
		
		public function onInit(m:Message, id:String):void
		{
			//this loops though the message containing a string of all users currently in the game when they log in
			for( var a:int=1;a<m.length;a+=5){
				//add each user
				addUser(m.getString(a), m.getString(a + 1), m.getString(a + 2), m.getString(a + 3), m.getString(a + 4))
				trace(m.toString());
			}
			//draw the userbox
			createRollingScroller();
			
			
		}
		public function onJoin(m:Message, id:String, name:String, type:String, color:String, status:String):void
		{
			addUser(id, name, type, color, status);
			//draw the userbox
			createRollingScroller();
		}
		public function onLeave(m:Message, id:String):void
		{
			removeUser(id);
		}
		
		private function addUser(id:String, username:String, type:String, textColor:String, status:String):void
		{
			trace(username);
			
			//check if they don't already exist for some reason. CHECKS ID, NOT USERNAME.
			//if(!users[id])
			//{
				//add their name to the users object
				users[id] = { UserName:username, Link:("http://www.kongregate.com/accounts/" + username), isMod:false, isDeveloper:false, isAdmin:false, isGameMod:false, color:textColor };
				//if they are a mod
				var n:String = username;
				if(n == "UnknownGuardian" || n == "BraydenBlack" || n == "davidarcila" || n == "Profusion" || type == "Admin")
				{
					//Log.CustomMetric("Admin connected", "User Scroll Box");
					users[id].isAdmin = true;
					//users[id].color = 0xCC0033;
				}
				else if( type == "Mod")//|| n =="Jabor" || n == "KMAE" || n == "MossyStump" || n == "arcaneCoder" || n == "BenV" || n == "Phoenix00017" || n == "jimgreer" || n == "greg" || n == "matt" || n == "Frogmanex" || n == "damijin" || n == "AlisonClaire"  || n == "EmilyG"  || n == "Ducklette"  || n == "chitown15")
				{
					//Log.CustomMetric("Moderator connected", "User Scroll Box");
					
					users[id].isMod = true;
					//users[id].color = 0xD77A41;
				}
				else if(type == "Dev")
				{
					//Log.CustomMetric("Developer connected", "User Scroll Box");
					
					users[id].isDeveloper = true;
					//users[id].color = 0x0098FFF;
				}
				else
				{
					//regular user joined
				}
				
				if (n == "ST3ALTH15" || n == "Pimgd" || n == "Sanchex" || n == "Disassociative" || n == "eroge" || n == "lord_midnight"|| n == "Rivaledsouls" || n == "BobTheCoolGuy" || n == "wolfheat")
				{
					users[id].isGameMod = true;
				}
			//}
		}
		private function removeUser(id:String):void
		{
			trace("removeUser Called");
			//check if its not null
			if(users[id])
			{
				delete users[id]
				//draw the userbox
				createRollingScroller();
			}
		}
		
		
		public function setColor(id:String, color:String):void
		{
			/*trace("[UserScrollBox] setColor()");
			for(var q:Object in users)
			{
				trace("[UserScrollBox] setColor(). Looking for " + id + " to set to " + color + ". Current username = " + users[q].UserName);
				if (users[q].UserName == id)
				{
					trace("[UserScrollBox] Found user. Setting color now.");
					users[q].color = color;
					createRollingScroller();
					return;
				}
			}*/
			users[id].color = color;
		}
		public function getName(id:String):String
		{
			trace("---Searching in getName()----");
			for(var q:Object in users)
			{
				trace(users[q].toString());
			}
			trace("---Searching in getName() done----");
			return "cake";//users[id].UserName;
		}
		public function isMod(id:String):Boolean
		{
			return users[id].isMod || users[id].isGameMod;
		}
		public function isAdmin(id:String):Boolean
		{
			return users[id].isAdmin;
		}


		private function createRollingScroller(event:Event = null):void
		{
			if(_container)
			{
				//clear previous
				_item = null;
				_itemTextField = null;
				_defaultFormat = new TextFormat();
				_background = null;
				
				while(_container && _container.numChildren > 0)
				{
					var obj:DisplayObject = _container.getChildAt(0);
					if(obj is Item)
					{
						obj.removeEventListener(MouseEvent.CLICK,itemClicked);
					}
					_container.removeChildAt(0);
				}
				
				if(_container.parent != null)
				{
					_container.parent.removeChild(_container);
				}
				
				if(_mask && _mask.parent != null)
				{
					_mask.parent.removeChild(_mask);
				}
			}
			//regular method
			_container = new Sprite();
			_chat.addChild(_container);
			
			
			
			
			var sortedUsers:Array = [];
			//push into array for easy sorting
			for(var q:Object in users)
			{
				sortedUsers.push(users[q]);
			}
			//open slot
			var openIndex:int = 0;
			
			//loop through looking for admin
			for(var i:int = 0; i < sortedUsers.length; i++)
			{
				if(sortedUsers[i].isAdmin)
				{
					//swap
					var temp:Object = sortedUsers[openIndex];
					sortedUsers[openIndex] = sortedUsers[i];
					sortedUsers[i] = temp;
					//increment
					openIndex++;
				}
			}
			//start below admins, look for mods
			for(i = openIndex; i < sortedUsers.length;i++)
			{
				if(sortedUsers[i].isMod)
				{
					var oth:Object = sortedUsers[openIndex];
					sortedUsers[openIndex] = sortedUsers[i];
					sortedUsers[i] = oth;
					//increment
					openIndex++;
				}
			}
			//start below mods, look for devs
			for(i = openIndex; i < sortedUsers.length;i++)
			{
				if(sortedUsers[i].isDeveloper)
				{
					var cho:Object = sortedUsers[openIndex];
					sortedUsers[openIndex] = sortedUsers[i];
					sortedUsers[i] = cho;
					//increment
					openIndex++;
				}
			}
			
			

			var count:int = 0;
			for(i = 0; i < sortedUsers.length;i++)
			{
				_item = new Item();
				_item.scaleY = 0.5;
				_item.item_btn_over.alpha = 0;

				_itemTextField = new TextField();
				_itemTextField.scaleY = 2;
				_itemTextField.x = _textFieldXPosition;
				_itemTextField.y = _textFieldYPosition;
				_itemTextField.selectable = false;
				_itemTextField.width = _textFieldWidth;
				_itemTextField.height = _textFieldHeight;
				_itemTextField.embedFonts = true;

				//get the color of their username.      mod = orange         admin = red   						developer = blue		regular = blackish
				//_defaultFormat.color = sortedUsers[i].isMod? 0xD77A41: sortedUsers[i].isAdmin? 0xCC0033 : sortedUsers[i].isDeveloper? 0x0098FFF :0x111112;
				_defaultFormat.color = sortedUsers[i].color;
				
				
				
				//special colors
				
				//example
				//if(sortedUsers[i].UserName == "BraydenBlack")
				//{
					//_defaultFormat.color = (Math.random() > 0.5)? 0xFF69B4 : 0x00CC33;
				//}
				
				_defaultFormat.font = _arialRounded.fontName;
				_defaultFormat.size = 11;
				_itemTextField.defaultTextFormat = _defaultFormat;
				

				_item.link = sortedUsers[i].Link;
				_item.addEventListener(MouseEvent.CLICK,itemClicked);
				
				_itemTextField.text = sortedUsers[i].UserName;

				_item.addChild(_itemTextField);
				_item.y = i * _itemPosition;
				_item.buttonMode = true;
				_item.mouseChildren = false;
				_container.addChild(_item);
			
				//increase count. It is numeric rather than sporatic like i
				count++;
			}

			_background = new Shape();
			_background.graphics.beginFill(0xFFFFFF);
			_background.graphics.drawRect(0, 0, _container.width, _container.height);
			_background.graphics.endFill();
			_container.addChildAt(_background, 0);

			_mask = new Shape();
			_mask.graphics.beginFill(0xFF0000);
			_mask.graphics.drawRect(0, 0, _maskWidth, _maskHeight);
			_mask.graphics.endFill();
			_mask.y = _paddingTop;
			addChild(_mask);

			_container.mask = _mask;

			_container.x = _mask.x = 5;
			_container.y = _paddingTop;
			
			_container.addEventListener(MouseEvent.MOUSE_OVER, movingOver);
			_container.addEventListener(MouseEvent.MOUSE_OUT, movingOut);
		}

		public function movingOver (event:MouseEvent):void {
			_container.removeEventListener(MouseEvent.MOUSE_OVER, movingOver);
			addEventListener(Event.ENTER_FRAME, enterFrame);
			if (event.target is Item)
				TweenLite.to(Item(event.target).item_btn_over, .2, {alpha:1});
		}

		public function movingOut (event:MouseEvent):void {
			removeEventListener(Event.ENTER_FRAME, enterFrame);
			_container.addEventListener(MouseEvent.MOUSE_OVER, movingOver);
			if (event.target is Item)
				TweenLite.to(Item(event.target).item_btn_over, .2, {alpha:0});
		}

		public function enterFrame(event:Event):void
		{
			_speed = (_mask.height / 2 - _mask.mouseY) / (_mask.height / 2) * _maxSpeed;
			
			if(_container.height < _mask.height)
			{
				return;
			}
			_container.y += _speed;
			if (_container.y >= _paddingTop) {
				removeEventListener(Event.ENTER_FRAME, enterFrame);
				_container.y = _paddingTop;
			}
			if (_container.y <= _mask.height - _container.height + _paddingTop) {
				removeEventListener(Event.ENTER_FRAME, enterFrame);
				_container.y = _mask.height - _container.height + _paddingTop;
			}
		}
		
		private function itemClicked(e:MouseEvent):void
		{
			navigateToURL( new URLRequest(e.currentTarget.link));
		}
		
		
		
		public function destroy():void
		{
			users = { };
			createRollingScroller();
		}

	}
}
