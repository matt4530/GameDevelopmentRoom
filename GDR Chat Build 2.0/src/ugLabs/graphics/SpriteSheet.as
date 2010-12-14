//Modified and extends by UnknownGuardian
//Credit from http://www.bensilvis.com/?p=317

package ugLabs.graphics
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;
   
    public class SpriteSheet extends Sprite
	{
       
        private var tileSheetBitmapData:BitmapData;
        private var canvasBitmapData:BitmapData;
       
        private var tileWidth:int;
        private var tileHeight:int;
        private var rowLength:int;
       
        private var tileRectangle:Rectangle;
        private var tilePoint:Point;
       
        public function SpriteSheet(tileSheetBitmap:Bitmap, width:Number = 16, height:Number = 16)
        {  
            tileSheetBitmapData = tileSheetBitmap.bitmapData;
            tileWidth = width;
            tileHeight = height;
           
            rowLength = int(tileSheetBitmap.width / width);
           
            tileRectangle = new Rectangle(0, 0, tileWidth, tileHeight);
            tilePoint = new Point(0, 0);
           
            canvasBitmapData = new BitmapData(tileWidth, tileHeight, true);
            var canvasBitmap:Bitmap = new Bitmap(canvasBitmapData);
            addChild(canvasBitmap);
           
            drawTile(0);
        }
       
        public function drawTile(tileNumber:int):void
        {
            tileRectangle.x = int((tileNumber % rowLength)) * tileWidth;
            tileRectangle.y = int((tileNumber / rowLength)) * tileHeight;
            canvasBitmapData.copyPixels(tileSheetBitmapData, tileRectangle, tilePoint);
        }
       
    }
}