package {

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.Font;
	import com.greensock.TweenLite;
	import ugLabs.util.Align;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import SWFStats.*;

	public class LinkScrollBox extends Sprite {

		private var _container:Sprite;
		private var _item:Item;
		private var _itemTextField:TextField;
		private var _defaultFormat:TextFormat = new TextFormat();
		private var _arialRounded:Font = new ArialRounded();
		private var _textFieldXPosition:uint = 10;
		private var _textFieldYPosition:uint = 10;
		private var _textFieldWidth:uint = 270;
		private var _textFieldHeight:uint = 25;
		private var _itemPosition:uint = 40;
		private var _mask:Shape;
		private var _maskWidth:uint = 288;
		private var _maskHeight:uint = 150;
		private var _paddingTop:uint = 0;
		private var _background:Shape;
		private var _maxSpeed:uint = 10;
		private var _speed:Number;
		private var _items:Array = [];;
		private var _stage:Sprite;

		public function LinkScrollBox (s:Sprite) {
			this._stage = s;
			loadLinks();
			createRollingScroller();
		}
		
		private function loadLinks():void
		{
			_items.push("Thread: HOW TO MAKE GAMES@http://www.kongregate.com/forums/4-programming/topics/89-faq-making-games-read-first");
			_items.push("Kongregate API@http://www.kongregate.com/developer_center/docs/kongregate-api");
			_items.push("Programming Forum@http://www.kongregate.com/forums/4-programming");
			_items.push("Getting Started with FlashDevelop@http://www.kongregate.com/games/Paltar/flashdevelop-tutorial");
			_items.push("Make An Avoider - MJW@http://gamedev.michaeljameswilliams.com/as3-avoider-game-tutorial-base/");
			_items.push("Emanuele Feronato Flash Blog@http://www.emanueleferonato.com/");
			_items.push("FlashGameLicense.com@http://www.flashgamelicense.com/developer_home.php");
			_items.push("Shootorials for AS2 by Kongregate@http://www.kongregate.com/labs");
			_items.push("Shootorials for AS3 by Moly@http://www.kongregate.com/accounts/Moly");
			_items.push("Tutorial Games on Kongregate@http://www.kongregate.com/tutorials-games");
			_items.push("Official Suggestions Thread@http://www.kongregate.com/forums/4-programming/topics/93529-game-development-room-gdr");
			_items.push("Made By Profusion Dev Team@http://profusiongames.com/");
		}

	
		private function createRollingScroller(event:Event = null):void {
			_container = new Sprite();
			_stage.addChild(_container);
			
			for (var i:int = 0; i < _items.length; i++) {
				_item = new Item();
				_item.item_btn_over.alpha = 0;

				_itemTextField = new TextField();
				_itemTextField.x = _textFieldXPosition;
				_itemTextField.y = _textFieldYPosition;
				_itemTextField.selectable = false;
				_itemTextField.width = _textFieldWidth;
				_itemTextField.height = _textFieldHeight;
				_itemTextField.embedFonts = true;

				_defaultFormat.color = 0x111112;
				_defaultFormat.font = _arialRounded.fontName;
				_defaultFormat.size = 15;
				_itemTextField.defaultTextFormat = _defaultFormat;
				
				
				var st:String = _items[i];
				var link:String = st.substr(st.indexOf("@") + 1);
				st = st.substring(0,st.indexOf("@"));
				_item.link = link;
				_item.addEventListener(MouseEvent.CLICK,itemClicked);
				
				_itemTextField.text = st;

				_item.addChild(_itemTextField);
				_item.y = i * _itemPosition;
				_item.buttonMode = true;
				_item.mouseChildren = false;
				_container.addChild(_item);
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
			//Align.centerHorizontallyInStage(_stage, _mask);
			_mask.y = _paddingTop;
			addChild(_mask);

			_container.mask = _mask;

			_container.x = _mask.x = 327;
			_container.y = _paddingTop;

			_container.addEventListener(MouseEvent.MOUSE_OVER, movingOver);
			_container.addEventListener(MouseEvent.MOUSE_OUT, movingOut);
		}

		private function movingOver (event:MouseEvent):void {
			_container.removeEventListener(MouseEvent.MOUSE_OVER, movingOver);
			addEventListener(Event.ENTER_FRAME, enterFrame);
			if (event.target is Item)
				TweenLite.to(Item(event.target).item_btn_over, .2, {alpha:1});
		}

		private function movingOut (event:MouseEvent):void {
			removeEventListener(Event.ENTER_FRAME, enterFrame);
			_container.addEventListener(MouseEvent.MOUSE_OVER, movingOver);
			if (event.target is Item)
				TweenLite.to(Item(event.target).item_btn_over, .2, {alpha:0});
		}

		public function enterFrame(event:Event):void {
			_speed = (_mask.height / 2 - _mask.mouseY) / (_mask.height / 2) * _maxSpeed;
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
			Log.CustomMetric("Navigated to " + e.currentTarget.link, "Links");
			navigateToURL( new URLRequest(e.currentTarget.link));
		}

	}
}
