package  
{
	import com.bit101.components.Text;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class TextEffect
	{
		private static var field:Text;
		private static var toAdd:String = "";
		private static var timer:Timer;
		private static var callback:Function;
		private static var speed:Number = 0.5;
		
		public function TextEffect() 
		{
			
		}
		
		public static function setField(t:Text):void
		{
			field = t;
		}
		
		public static function start(displaySpeed:Number = -1):void
		{
			if (displaySpeed == -1)
			{
				displaySpeed = speed;
			}
			else
			{
				speed = displaySpeed;
			}
			if (field)
			{
				timer = new Timer(displaySpeed, 0);
				timer.addEventListener(TimerEvent.TIMER, append);
				timer.start();
			}
			else
			{
				throw new Error("Field is not defined", 1);
			}
		}
		
		public function setSpeed(displaySpeed:Number):void
		{
			if (timer)
			{
				timer.delay = displaySpeed;
			}
			speed = displaySpeed;
		}
		
		public static function add(s:String):void
		{
			toAdd += s;
			if (timer && !timer.running)
			{
				start();
			}
		}
		
		public static function addGroup(s:String):void
		{
			add( "|" + s + "|");
		}
		
		private static function append(e:TimerEvent):void
		{
			if (toAdd.length != 0)
			{
				var char:String = toAdd.charAt(0);
				if (char == "|")
				{
					field.text += toAdd.substring(1,toAdd.indexOf("|", 1));
					toAdd = toAdd.substr(toAdd.indexOf("|", 1) + 1);
				}
				else
				{
					field.text += toAdd.charAt(0);
					toAdd = toAdd.substr(1);
				}
			}
			else
			{
				if(callback != null)
				{
					callback();
				}
				callback = null;
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, append);
			}
		}
		
		public static function stop(clearWaitingText:Boolean = false):void
		{
			if (timer)
			{
				if (timer.running)
				{
					timer.stop();
				}
				timer.removeEventListener(TimerEvent.TIMER, append);
				timer = null;
			}
			
			if (clearWaitingText)
			{
				toAdd = "";
			}
		}
		
		public static function setAllCompleteCallback(f:Function):void
		{
			callback = f;
		}
		
	}

}