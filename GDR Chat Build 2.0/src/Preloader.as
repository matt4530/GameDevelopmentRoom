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
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Preloader extends MovieClip 
	{
		public var logo:TextField
		
		public function Preloader() 
		{
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			// show loader
			graphics.lineStyle(1, 0xFFFFFF);
			graphics.drawRect(0, 270, 650, 10);
			
			logo = new TextField();
			logo.autoSize = 'center'
			logo.htmlText = '<font size="30" face="Zekton"><a href=\"event:Profusion"><font color="#FFFFFF">Pro</font><font color="#0098FF">fusion</font> <font color="#FFFFFF">Dev Team</font></a>';
			logo.selectable = false;
			logo.addEventListener(TextEvent.LINK, textLink);
			logo.x = (stage.stageWidth - logo.width) / 2;
			logo.y = (stage.stageHeight - logo.height) / 2 - 50;
			logo.name = "Logo";
			stage.addChild(logo);
			
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// update loader
			graphics.clear();
			graphics.lineStyle(1, 0xFFFFFF);
			graphics.drawRect(0, stage.stageHeight/2 - 5, stage.stageWidth-1, 10);
			graphics.lineStyle(1, 0xFFFFFF, 0.7);
			graphics.beginFill(0xFFFFFF, 0.7);
			graphics.drawRect(2, stage.stageHeight/2 -3, (stage.stageWidth-5) * e.bytesLoaded / e.bytesTotal,  6);
			graphics.endFill();
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
			
			if (s.data.numTimesVisited <= 2)
			{
				setTimeout(continueOn, 3000);
			}
			else
			{
				continueOn();
			}
			s.flush();
		}
		
		public function continueOn():void
		{
			graphics.clear();
			stage.removeChild(logo);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
		public function textLink(e:TextEvent):void
		{
			navigateToURL(new URLRequest("http://kdugames.wordpress.com/"));
		}
		
	}
	
}