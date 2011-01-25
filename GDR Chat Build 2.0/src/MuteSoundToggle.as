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
			gotoAndStop(2);
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, click);
		}
		
		public function click(e:MouseEvent):void
		{
			Main.chatDisplay.soundMuted = !Main.chatDisplay.soundMuted;
			if (Main.chatDisplay.soundMuted)
			{
				gotoAndStop(2);
			}
			else
			{
				gotoAndStop(1);
			}
		}
		
	}

}