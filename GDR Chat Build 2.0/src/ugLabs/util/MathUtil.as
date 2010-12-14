package ugLabs.util
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class MathUtil 
	{
		
		
		
		
		
		/**
		 * Number delimiter. Can be used to insert commas to make numbers more readable
		 * Extra Reference: http://www.kongregate.com/forums/4-programming/topics/87476
		 * @since 04/29/2010
		 * @param	num						Number to delimit.
		 * @param	delimiter				Delimiter to insert. Like "," or ".".
		 * @param	numCharGroup			The number of characters between delimiter string.
		 * @param	decimalPrecision		The decimal precision of this function
		 * @return  Returns the final delimited String.
		 */
		static public function numberDelimiter(num:Number, delimiter:String = ",", numCharGroup:Number = 3, decimalPrecision:int = 0):String 
		{
			var decimal:String = "", newVal:Number = Math.abs(num);
			if (decimalPrecision != 0) 
			{
				decimal = String((newVal % 1).toFixed(decimalPrecision)).substring(1); // if left negative, could be -0.x
			}
			var newString:String = "";
			var numberString:String = Math.floor(newVal).toString();
			for (var index:int = numberString.length, col:int = 0; ~--index; ) 
			{
				newString = numberString.substr(index, 1) + newString;
				if (++col == numCharGroup && index) 
				{
					newString = delimiter + newString;
					col = 0;
				}
			}
			return ((num < 0) ? "-" : "") + newString + decimal;
		}
		
		
		
		static public function getPointRadiusDistance(centerPoint:Point = null, radius:Number = 100, angle:Number = 0):Point
		{
			return new Point(Math.cos(angle) * radius+centerPoint.x, Math.sin(angle ) * radius+centerPoint.y);
		}
		
	}
}