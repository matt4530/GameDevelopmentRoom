package  
{
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class MuteSoundToggle extends MuteSound
	{
		public function MuteSoundToggle() 
		{
			gotoAndStop(1);
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, click);
		}
		
		public function click(e:MouseEvent = null):void
		{
			Main.chatDisplay.soundMuted++;
			Main.chatDisplay.soundMuted %= 3;
			gotoAndStop(Main.chatDisplay.soundMuted+1);
		}
		
	}

}