package ugLabs.util
{

	import flash.display.*;

	public class Align
	{

		public static function centerInStage (stage:Stage, mc:DisplayObject):void {
			mc.x = stage.stageWidth / 2 - mc.width / 2;
			mc.y = stage.stageHeight / 2 - mc.height / 2;
		}

		public static function centerHorizontallyInStage (stage:Stage, mc:DisplayObject):void {
			mc.x = stage.stageWidth / 2 - mc.width / 2;
		}

		public static function centerVerticallyInStage (stage:Stage, mc:DisplayObject):void {
			mc.y = stage.stageHeight / 2 - mc.height / 2;
		}

	}

}
