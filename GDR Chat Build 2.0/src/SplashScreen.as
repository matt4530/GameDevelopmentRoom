package  
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class SplashScreen extends Sprite
	{
		private var _t:TextField
		private var mySprite:Sprite = new Sprite(); 
		public var tempAlpha:Number = 0;
		
		public function SplashScreen() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function init(e:Event):void
		{
			mySprite.useHandCursor = true;
			
			
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, 650, 550);
			graphics.endFill();
			
			//alpha = 0;
			addChild(mySprite);
			var m:Matrix = new Matrix(); 
			m.createGradientBox( stage.stageWidth*2, stage.stageWidth*2, 3.14, -stage.stageWidth/2,-stage.stageHeight / 2);  
			mySprite.graphics.beginGradientFill('radial', [ 0xE7E2DA, 0xA69E9D],  [1, 1], [0, 255], m); 
			mySprite.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight); 
			mySprite.graphics.endFill();			
			
			_t = new TextField();
			_t.defaultTextFormat = new TextFormat("Arial", 25, 0x474143, true, null, null);
			_t.autoSize = 'center';
			_t.antiAliasType = AntiAliasType.ADVANCED;
			_t.selectable = false;//474143,A69E9D,E7E2DA,FFFFFF,E7E8E7
			_t.text = "ProFusion";
			_t.x = (stage.stageWidth - _t.width) / 2;
			_t.y = (stage.stageHeight-_t.height) / 2;
			addChild(_t);
			
			//_t.filters = [new BlurFilter(1, 1)];// Filter(0x000000, 1, 1, 1)];
			
			addEventListener(Event.ENTER_FRAME, frame);
			stage.addEventListener(MouseEvent.CLICK, textLink);
			
			TweenLite.to(this, 3, { tempAlpha:100 } );
			TweenLite.to(this, 3, { delay:4, tempAlpha:0, overwrite:false, onComplete:kill } );
		}
		
		public function frame(e:Event):void
		{
			mySprite.alpha = tempAlpha / 100;
			
			
			
			var m:Matrix = new Matrix(); 
			m.createGradientBox( stage.stageWidth*2, stage.stageWidth*2, 3.14, -stage.stageWidth/2, -stage.stageHeight / 2);  
			 
			mySprite.graphics.beginGradientFill('radial', [ 0xE7E2DA, 0xA69E9D],  [1, 1], [0, 255], m); 
			 
			mySprite.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight); 
			mySprite.graphics.endFill();
			
			
		}
		public function textLink(e:MouseEvent):void
		{
			//Log.CustomMetric("Clicked ProfusionGames link"); // metric
			//Link.Open("http://profusiongames.com/?gameref=ruby_star", "ProfusionSplashScreen", "Developer");
			navigateToURL(new URLRequest("http://profusiongames.com/?gameref=gdr"));
		}
		
		public function kill():void
		{
			stage.removeEventListener(MouseEvent.CLICK, textLink);
			removeEventListener(Event.ENTER_FRAME, frame);
			mySprite.parent.removeChild(mySprite);
			_t.parent.removeChild(_t);
			Main.splashScreenFinished = true;
			parent.removeChild(this);
		}
	}

}