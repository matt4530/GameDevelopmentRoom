//Modified and extends by UnknownGuardian
package ugLabs.util
{
	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * ...
	 * @author UnknownGuardian
	 */
    public class CollisionDetection
	{

		
		
		
		
		
		
		
		/**
		 * Circle to Rectangle collision detection.
		 * Source:  http://www.kongregate.com/forums/4/topics/83159?page=1#posts-1849452
		 * @since 0.2.1
		 * @since 03/27/2010
		 * @param	c1						Circle to test.
		 * @param	r1						Rectangle to test against.
		 * @param	targetCoordinateSpace	The Display Object's coordinate system to use.
		 * @return Returns True if the objects are colliding.
		 */
		static public function circleRectCollision(c1:Object, r1:Object, targetCoordinateSpace:DisplayObject):Boolean
		{
			var space:DisplayObject = targetCoordinateSpace;
			var testX:Number = c1.x;
			var testY:Number = c1.y;
			
			if (testX < r1.getBounds(space).left) { testX = r1.getBounds(space).left; }
			if (testX > r1.getBounds(space).right) { testX = r1.getBounds(space).right; }
			if (testY < r1.getBounds(space).top) { testY = r1.getBounds(space).top; }
			if (testY > r1.getBounds(space).bottom) { testY = r1.getBounds(space).bottom; }
			
			return findDistance(new Point(c1.x, c1.y), new Point(testX, testY)) < c1.width / 2;
		}

		
		
		
		
		
		
		
		/**
		 * Rectangle to Rectangle collision detection.
		 * Source:  http://www.kongregate.com/forums/4/topics/83159?page=1#posts-1849452
		 * @author  Feltope
		 * @param	r1 The first Rectangle to test.
		 * @param	r2 The second Rectangle to test.
		 * @return  Returns True if the objects are colliding.
		 */
		static public function rectRectCollision(r1:Object, r2:Object):Boolean
		{
			var xMinDist:Number = (r1.width + r2.width) / 2;
			var yMinDist:Number = (r1.height + r2.height) / 2;
			var xDist:Number = Math.abs(r1.x - r2.x);
			var yDist:Number = Math.abs(r1.y - r2.y);
			
			if (xDist >= xMinDist || yDist >= yMinDist)
			{ return false; }
			else { return true; }
		}

		
		
		
		
		
		
		
		/**
		 * Circle to Circle collision detection
		 * Source:  http://www.kongregate.com/forums/4/topics/83159?page=1#posts-1849452
		 * @since 0.2.1
		 * @since 03/27/2010
		 * @param	c1 First circle
		 * @param	c2 Second circle
		 * @return Returns true if objects are colliding.
		 */
		static public function circleCircleCollision(c1:Object, c2:Object):Boolean
		{
			var distX:Number = c2.x - c1.x;
			var distY:Number = c2.y - c1.y;
			var dist:Number = (distX * distX) + (distY * distY);
			
			if (dist < (c1.width * c1.width) + (c2.width * c2.width)) { return true; }
			
			return false;
		}

		
		
		
		
		
		
		
		/**
		 * Finds the distance between two sets of coordinates.
		 * Source:  http://www.kongregate.com/forums/4/topics/83159?page=1#posts-1849452
		 * @since 0.2.1
		 * @since 03/27/2010
		 * @param	p1	First Point Object.
		 * @param	p2	Second Point Object.
		 * @return Returns the distance between the two Point Objects.
		 */
		static public function findDistance(p1:Point, p2:Point):Number
		{
			return Math.sqrt((p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y));
		}
		
		
		
		
		
		
		
		
	}
}