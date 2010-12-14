package 
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class LinkContainer extends Sprite
	{
	
		//scroll model
		public var scrollBox:LinkScrollBox;

		
		public function LinkContainer():void
		{
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		public function init(e:Event):void
		{
			scrollBox = new  LinkScrollBox(this);
		}
	}	
}
