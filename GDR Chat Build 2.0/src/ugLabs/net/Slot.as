package ugLabs.net
{
	/**
	 * Kong by UnknownGuardian. November 24th 2010.
	 * Visit http://profusiongames.com/ and http://github.com/UnknownGuardian
	 *
	 * Copyright (c) 2010 ProfusionGames
	 *    All rights reserved.
	 *
	 * Permission is hereby granted, free of charge, to any person
	 * obtaining a copy of this software and associated documentation
	 * files (the "Software"), to deal in the Software without
	 * restriction, including without limitation the rights to use,
	 * copy, modify, merge, publish, distribute, sublicense, and/or sell
	 * copies of the Software, and to permit persons to whom the
	 * Software is furnished to do so, subject to the following
	 * conditions:
	 *
	 * ^ Attribution will be given to:
	 *  	UnknownGuardian http://www.kongregate.com/accounts/UnknownGuardian
	 *
	 * ^ Redistributions of source code must retain the above copyright notice,
	 * this list of conditions and the following disclaimer in all copies or
	 * substantial portions of the Software.
	 *
	 * ^ Redistributions of modified source code must be marked as such, with
	 * the modifications marked and ducumented and the modifer's name clearly
	 * listed as having modified the source code.
	 *
	 * ^ Redistributions of source code may not add to, subtract from, or in
	 * any other way modify the above copyright notice, this list of conditions,
	 * or the following disclaimer for any reason.
	 *
	 * ^ Redistributions in binary form must reproduce the above copyright
	 * notice, this list of conditions and the following disclaimer in the
	 * documentation and/or other materials provided with the distribution.
	 *
	 * THE SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
	 * IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
	 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
	 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
	 * OR COPYRIGHT HOLDERS OR CONTRIBUTORS  BE LIABLE FOR ANY CLAIM, DIRECT,
	 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
	 * OR OTHER LIABILITY,(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
	 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
	 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
	 * WHETHER AN ACTION OF IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
	 * NEGLIGENCE OR OTHERWISE) ARISING FROM, OUT OF, IN CONNECTION OR
	 * IN ANY OTHER WAY OUT OF THE USE OF OR OTHER DEALINGS WITH THIS
	 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * English: Use, distribute, etc to this with keeping credits and copyright
	 */
	
	import flash.net.SharedObject;

	public class Slot
	{
		//The SharedObject the slot uses
		private var object:SharedObject;
		
		//The name of the slot
		private var slotName:String;
		
		/**
		 * Slot(name:String):void
		 * @since 	06/15/2011
		 * @param 	name					Name of the slot to create or load.
		 * @return	Void
		 */
		public function Slot(name:String):void
		{
			object = SharedObject.getLocal(name);
			slotName = name;
		}
		
		/**
		 * read*(name:String):*
		 * @since 	06/15/2011
		 * @param	name					Name of the property to read.
		 * @return  *						The property requested.
		 */
		public function readString(name:String):String { return object.data[name]; }  	//null
		public function readInt(name:String):int { return object.data[name]; }			//0
		public function readUint(name:String):uint { return object.data[name]; }		//0
		public function readNumber(name:String):Number { return object.data[name]; }	//NaN
		public function readBoolean(name:String):Boolean { return object.data[name]; }	//false
		public function readObject(name:String):Object { return object.data[name]; }	//null
		public function readArray(name:String):Array { return object.data[name]; }		//null
		public function read(name:String):* { trace(object.data[name]);  return object.data[name]; } //undefined
		
		/**
		 * write(name:String, obj:*):void
		 * @since 	06/15/2011
		 * @param	name					Name of the property to read.
		 * @param	obj						A property to save.
		 * @return  Void
		 */
		public function write(name:String, data:*):void { object.data[name] = data; }
		
		/**
		 * getName():String
		 * @since 	06/15/2011
		 * @return  String					The name of the slot.
		 */
		public function getName():String { return slotName; }
		
		/**
		 * write(name:String, obj:*):void	Saves the SharedObject.
		 * @since 	06/15/2011
		 * @return  Void
		 */
		internal function save():void { object.flush(); }
		
		/**
		 * clear():void 					Clears the SharedObject.
		 * @since 	06/15/2011
		 * @return  Void
		 */
		internal function clear():void { object.clear(); }
	}
}