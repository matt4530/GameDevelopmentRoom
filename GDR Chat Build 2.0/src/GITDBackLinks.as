package  
{
	import com.greensock.easing.Sine;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
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
		public var displayCount:int = 0;
		public var displayMax:int = 2;
		public var m:Sprite = new Sprite();
		
		public function GITDBackLinks() 
		{
			part1.addEventListener(MouseEvent.CLICK, click);
			part2.addEventListener(MouseEvent.CLICK, click);
			addEventListener(MouseEvent.ROLL_OUT, rOut);
			addEventListener(MouseEvent.ROLL_OVER, rOver);
			buttonMode = true;
			
			m.graphics.beginFill(0x000000, 1);
			m.graphics.drawRect(0, 0, width / displayMax, height);
			m.graphics.endFill();
			addChild(m);
			mask = m;
			m.mouseEnabled = false;
			s.mouseEnabled = false;
			//m.mouseChildren = false;
			//s.mouseChildren = false;
			
			addChild(s);
			setChildIndex(s, displayMax);
			addEventListener(Event.ADDED_TO_STAGE, init)
		}
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init)
			startMove();
		}
		public function startMove():void
		{
			displayCount++;
			if (displayCount >= displayMax) displayCount = 0;
			var destinX:int = 256 + 360 * displayCount;
			TweenLite.to(this, 2, { x:destinX, ease:Sine.easeInOut, delay: 120,onUpdate:update,  onComplete:startMove } );
		}
		public function update():void
		{
			m.x = 256 - x;
			s.x = 256 - x;
		}
		
		public function click(e:MouseEvent):void
		{
			if(e.currentTarget == part1)
				navigateToURL(new URLRequest("http://www.kongregate.com/games/YellowAfterlife/pipe10"));
			if(e.currentTarget == part2)
				navigateToURL(new URLRequest("http://www.kongregate.com/games/orandze/sunget"));
			/*if(e.currentTarget == part2)
				navigateToURL(new URLRequest("http://www.kongregate.com/games/Siveran/farm-of-souls"));
			if(e.currentTarget == part3)
				navigateToURL(new URLRequest("http://www.kongregate.com/games/truefire/commander-cookie-vs-the-vegetables"));
			if(e.currentTarget == part4)
				navigateToURL(new URLRequest("http://www.kongregate.com/games/truefire/inversion"));*/
			trace(e.target.name);
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