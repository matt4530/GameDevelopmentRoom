package senekis
{
	import flash.events.Event;
	
	public class MediaEvent extends Event
	{
		public var mode:String;
		public static const SHARE:String = "0";
		
		public function MediaEvent(e:String, s:String):void
		{
			super(e, false, false);
			mode = s;
		}
		
		override public function clone():Event
		{
			return new MediaEvent(type, mode);
		}
	}
}