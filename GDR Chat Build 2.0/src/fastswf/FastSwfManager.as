package fastswf 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class FastSwfManager extends FastSwf 
	{

		public function FastSwfManager() 
		{
			
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			nameField.text = "Share SWFs\nfaster.";
			nameField.height = 40;
			nameField.multiline = true;
			
			removeChild(browse);
			removeChild(preloader);
			
			open.label = "Register";
			open.y -= 10;
			
			open.enabled = true;
			open.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			navigateToURL(new URLRequest("https://www.fastswf.com/users/sign_up"));
		}
		
		
		
	}

}