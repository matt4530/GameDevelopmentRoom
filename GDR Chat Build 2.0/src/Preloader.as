package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TextEvent;
	import flash.net.navigateToURL;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Preloader extends MovieClip 
	{
		
		public var t:TextField;
		public function Preloader() 
		{
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			// show loader
			
			t = new TextField();
			t.textColor = 0x666666;
			t.defaultTextFormat = new TextFormat("Arial", 8);
			t.autoSize = 'center';
			t.text = "0%";
			addChild(t);
			
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// update loader
			var percent:Number = (e.target.bytesLoaded / e.target.bytesTotal) * 100;
			graphics.beginFill(0x666666);
			graphics.drawRect(stage.stageWidth / 2 - 50, stage.stageHeight / 2 - 1, int(percent), 4);
			graphics.endFill();
			t.x = percent + stage.stageWidth / 2 - 50 - t.width/2
			t.y = stage.stageHeight / 2 - 15
			t.text = int(percent).toString();
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				startup();
			}
		}
		
		private function startup():void 
		{
			// hide loader
			stop();
			
			var s:SharedObject = SharedObject.getLocal("GDRPreloader");
			if (!s.data.numTimesVisited)
			{
				s.data.numTimesVisited = 0;
			}
			s.data.numTimesVisited++;
			s.flush();
			continueOn();
		}
		
		public function continueOn():void
		{
			t.parent.removeChild(t);
			graphics.clear();
			
			stop();
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}		
	}
	
}