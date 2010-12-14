package 
{
	
	import flash.display.Sprite;
	import playerio.*;
	
	public class UserContainer extends Sprite
	{
	
		//scroll model
		public var scrollBox:UserScrollBox;

		
		public function UserContainer(connection:Connection):void
		{
			scrollBox = new  UserScrollBox(this);
		}
	}	
}
