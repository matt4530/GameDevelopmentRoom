package ugLabs.util
{
	
	
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class StringUtil 
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
		 * 
		 * //also located in the Math.Util class, because it relates to numbers
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
		
		
		
		
		
		
		
		/**
		 * HTML Stripper. Strips all html text from a string
		 * @source http://www.johncblandii.com/index.php/2007/09/as3-remove-html-regex.html
		 * @since   07/01/2010
		 * @param	s						String to remove html from.
		 * @return  Returns the final html-stripped String.
		 */
		static public function stripHTML(s:String):String
		{
			return s.replace(/<.*?>/g, "");
		}
		
		
		
		
		
		/**
		 * HTML neutralizer. Replaces < and > from strings with their ascii equivalent
		 * @since   07/18/2010
		 * @param	s	String to simulate html from.
		 * @return  Returns the final html-neutralized/simulated String.
		 */
		static public function neutralizeHTML(s:String):String
		{
			s = s.split("<").join('&lt;');
			s = s.split(">").join('&gt;');
			return s;
		}
		
		
		
		
		
	}
}