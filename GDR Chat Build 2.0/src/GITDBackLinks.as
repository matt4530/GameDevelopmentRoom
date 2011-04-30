package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class GITDBackLinks extends BackLinks
	{
		public var s:Sprite = new Sprite();
		
		public function GITDBackLinks() 
		{
			addEventListener(MouseEvent.CLICK, click);
			addEventListener(MouseEvent.ROLL_OUT, rOut);
			addEventListener(MouseEvent.ROLL_OVER, rOver);
			buttonMode = true;
			addChild(s);
			setChildIndex(s, 1);
		}
		
		public function click(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://www.kongregate.com/games/YellowAfterlife/pipe10"));
		}
		public function rOut(e:MouseEvent):void
		{
			s.graphics.clear();
		}
		public function rOver(e:MouseEvent):void
		{
			s.graphics.beginFill(0x999999, 0.4);
			s.graphics.drawRect(0, 0, width, height);
			s.graphics.endFill();
		}
	}

}