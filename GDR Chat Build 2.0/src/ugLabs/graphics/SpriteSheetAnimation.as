//Created by UnknownGuardian
//Extends a modified package

package ugLabs.graphics
{
	import flash.display.Bitmap;
	import flash.events.Event;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class SpriteSheetAnimation extends SpriteSheet 
	{
		public var frameNumber:int = 0;
		public var numFrames:int = 0;
		public var isAdded:Boolean = false;
		public var destroyWhenComplete:Boolean = false;
		
		//original bitmap
		//how wide each cell is
		//how tall each cell is
		//how many frames. just for use of bitmaps with empty slots
		//play the animation immediately?
		//destroy after playing once?
		public function SpriteSheetAnimation(tileSheetBitmap:Bitmap, Width:Number, Height:Number, numberOfFrames:int , startImmediately:Boolean, destroyOnComplete:Boolean ):void
		{
			super(tileSheetBitmap, Width, Height);
			
			numFrames = numberOfFrames;
			destroyWhenComplete = destroyOnComplete;
			
			if (startImmediately)
			{
				addEventListener(Event.ENTER_FRAME, animate);
				isAdded = true;
			}
		}
		public function startAnimation():void
		{
			if (!isAdded)
			{
				addEventListener(Event.ENTER_FRAME, animate);
				isAdded = true;
			}
		}
		public function animate(e:Event):void
		{
				drawTile(frameNumber);
				
				frameNumber++;
				if (frameNumber == numFrames)
				{
					frameNumber = 0;
					if (destroyWhenComplete)
					{
						destroy();
					}
				}
		}
		public function destroy(e:Event = null):void
		{
			if (parent != null)
			{
				parent.removeChild(this);
				if (!isAdded)
				{
					removeEventListener(Event.ENTER_FRAME, animate);
					parent.removeChild(this);
				}
			}
		}
	}
	
}