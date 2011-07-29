package  
{
	import flash.events.Event;
	import ugLabs.net.Kong;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class KongChat
	{
		private static var isCreated:Boolean = false;
		public function KongChat() 
		{
			
		}
		
		public static function init():void
		{
			Kong.chat.showTab("Debug", "Debug", { size:0.5 } );
			Kong.chat.addEventListener("tab_visible", onTabShown);
			Kong.chat.addEventListener("message", onPlayerMessage);
			isCreated = true;
		}
		
		static private function onPlayerMessage(e:*):void 
		{
			var m:String = e.data.text;
			if (m.indexOf("image ") == 0)
			{
				Kong.chat.removeCanvasObject("Image");
				var url:String = m.split(" ")[1];
				trace("IMAGE URL", url);
				var position:Object = {x:0,y:0};
				Kong.chat.displayCanvasImage("Image", url, position);
			}
		}
		
		static private function onTabShown(e:Event):void 
		{
			Kong.chat.displayMessage("Entering Debug Session","GDR");
		}
		
		
		static public function log(t:String):void 
		{
			if (!isCreated && Kong.userName == "UnknownGuardian")
			{
				init();				
			}
			Kong.chat.displayMessage(t,"GDR");
		}
	}

}