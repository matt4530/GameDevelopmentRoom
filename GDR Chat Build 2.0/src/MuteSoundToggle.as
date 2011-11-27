package  
{
	import flash.events.MouseEvent;
	import ugLabs.net.SaveSystem;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class MuteSoundToggle extends MuteSound
	{
		public function MuteSoundToggle() 
		{
			if(SaveSystem.getCurrentSlot().read("SoundSetting") == undefined)
				gotoAndStop(1);
			else
				gotoAndStop((SaveSystem.getCurrentSlot().read("SoundSetting") as int));
				
			Main.chatDisplay.soundMuted = currentFrame - 1;
				
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, click);
		}
		
		public function click(e:MouseEvent = null):void
		{
			Main.chatDisplay.soundMuted++;
			Main.chatDisplay.soundMuted %= 3;
			gotoAndStop(Main.chatDisplay.soundMuted + 1);
			
			SaveSystem.getCurrentSlot().write("SoundSetting", currentFrame);
			SaveSystem.saveCurrentSlot();
		}
		
	}

}