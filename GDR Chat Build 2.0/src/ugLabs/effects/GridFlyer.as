package ugLabs.effects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class GridFlyer extends Sprite
	{
		public var isPaused:Boolean = false
		
		public var Width:int = 800;
		public var Height:int = 800;
		
		public var xDensity:int = 30;
		public var yDensity:int = 30;
		
		public var bColor:uint = 0xFFFFFF;
		public var lColor:uint = 0x000000;
		public var sColor:uint = 0xFFFF00;
		
		public var speed:int = 3;
		public var rot:Number = 0.1;
		
		public var myBit:Bitmap;
		public var myData:BitmapData;
		
		public var myContainer:Sprite;
		
		public function GridFlyer(_width:int, _height:int, _densityX:int, _densityY:int, _backgroundColor:uint, _lineColor:uint, _squareColor:uint, _speed:int = 3, _rotation:Number = 0.1) 
		{
			Width = _width;
			Height = _height;
			xDensity = _densityX;
			yDensity = _densityY;
			bColor = _backgroundColor;
			lColor = _lineColor;
			sColor = _squareColor;
			speed = _speed;
			rot = _rotation;
			
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			createGrid();
			addEventListener(Event.ENTER_FRAME, frame);
		}
		
		public function createGrid():void
		{
			var g:Graphics = this.graphics;
			g.beginFill(bColor, 1);
			g.drawRect(0, 0, Width, Height);
			g.endFill();
			g.lineStyle(1, lColor);
			for (var i:int = 0; i < Width; i += xDensity)
			{
				g.moveTo(i, 0);
				g.lineTo(i, Height);
			}
			for (i = 0; i < Height; i += yDensity)
			{
				g.moveTo(0, i);
				g.lineTo(Width, i);
			}
			
			for (i = 0; i < Width; i += xDensity)
			{
				for (var q:int = 0; q < Height; q += yDensity)
				{
					g.beginFill(sColor, 1);
					g.drawRect(i + 2, q + 2, xDensity - 4, yDensity - 4);
					g.endFill();
				}
			}
			
			
			myData = new BitmapData(Width, Height, false);
			myData.draw(this);
			g.clear();
			myBit = new Bitmap(myData);
			
			myContainer = new Sprite();
			myContainer.addChild(myBit);
			myContainer.x = stage.stageWidth / 2;
			myContainer.y = stage.stageHeight / 2;
			myBit.x = -Width / 2;
			myBit.y = -Height / 2;
			addChild(myContainer);
		}
		
		public function frame(e:Event):void
		{
			myBit.y -= speed;
			if (Math.abs(myBit.y) >= yDensity+Height/2)
			{
				myBit.y = -Height/2;
			}
			myContainer.rotation += rot;
		}
		
		public function pause():void
		{
			if (!isPaused)
			{
				isPaused = true;
				removeEventListener(Event.ENTER_FRAME, frame);
			}
		}
		public function unpause():void
		{
			if (isPaused)
			{
				isPaused = false;
				addEventListener(Event.ENTER_FRAME, frame);
			}
		}
		public function destroy():void
		{
			if (!isPaused)
			{
				removeEventListener(Event.ENTER_FRAME, frame);
			}
			myData.dispose();
			myData = null;
			myBit = null;
			parent.removeChild(this);
			
			trace("Removed");
		}
		
	}

}