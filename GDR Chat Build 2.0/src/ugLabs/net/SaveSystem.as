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
	import ugLabs.net.Slot;
	
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	
	public class SaveSystem
	{
		//singleton variables
		private static var _instance:SaveSystem;
		private static var _okToCreate:Boolean = false;
		
		//current slot open
		private static var currentSlotOpen:Slot;
		
		//the array of slots of shared data
		private static var saveSlots:Array = [];
		
		/**
		 * SaveSystem() constructor. Do not use.
		 * @since 	06/15/2011
		 * @return  Void
		 */
		public function SaveSystem()
		{
			if( !SaveSystem._okToCreate ){
				throw new Error("[SaveSystem] Error: " + this + " is not a singleton and must be accessed with the getInstance() method");				
			}
		}
		
		/**
		 * SaveSystem() accessor. Do not use.
		 * @since 	06/15/2011
		 * @return	SaveSystem				The current instance of SaveSystem. No current reason to call this function
		 */
		public static function getInstance():SaveSystem
		{
			if( !SaveSystem._instance ){
				SaveSystem._okToCreate = true;
				SaveSystem._instance = new SaveSystem();
				SaveSystem._okToCreate = false;
			}
			return SaveSystem._instance;
		}
		
		/**
		 * createOrLoadSlot(name:String):void
		 * @since 	06/15/2011
		 * @param	name					Name of the save slot to be loaded or created if not found.
		 * @return  Void
		 */
		public static function createOrLoadSlot(name:String):void
		{
			saveSlots.push(new Slot(name));
		}
		
		/**
		 * createOrLoadSlots(slotNames:Array):void
		 * @since 	06/15/2011
		 * @param	slotNames				Names of the save slots to be loaded or created if not found.
		 * @return  Void
		 */
		public static function createOrLoadSlots(slotNames:Array):void
		{
			for (var i:int = 0; i < slotNames.length; i++)
			{
				if (slotNames[i] is String)
				{
					saveSlots.push(new Slot(slotNames[i]));
				}
				else
				{
					throw new Error("[SaveSystem] createSlots() Error: Pass in an array of Strings representing the names of each slot.");
				}
			}
		}
		
		/**
		 * openSlot(num:int = 0):Boolean
		 * @since 	06/15/2011
		 * @param	num						The index of a slot to open.
		 * @return  Boolean					If opening the slot is successful.
		 */
		public static function openSlotIndex(num:int = 0):Boolean
		{
			if (saveSlots.length <= num || num < 0) return false;
			currentSlotOpen = saveSlots[num];
			return true;
		}
		
		/**
		 * openSlot(name:String):Boolean
		 * @since 	06/15/2011
		 * @param	name					Name of the slot to open.
		 * @return  Boolean					If opening the slot is successful.
		 */
		public static function openSlot(name:String):Boolean
		{
			for (var i:int = 0; i < saveSlots.length; i++)
			{
				if (saveSlots[i].getName() == name)
				{
					currentSlotOpen = saveSlots[i];
					return true;
				}
			}
			return false;
		}
		
		/**
		 * closeCurrentSlot(shouldSave:Boolean = true ):Boolean
		 * @since 	06/15/2011
		 * @param	shouldSave				If the current slot should save before closing
		 * @return  Boolean					If closing the slot is successful.
		 */
		public static function closeCurrentSlot(shouldSave:Boolean = true ):Boolean
		{
			if (currentSlotOpen == null) return false;
			if (shouldSave) currentSlotOpen.save();
			currentSlotOpen = null;
			return true;
		}
		
		/**
		 * saveCurrentSlot():Boolean
		 * @since 	06/15/2011
		 * @return  Boolean					If saving the current slot is successful.
		 */
		public static function saveCurrentSlot():Boolean
		{
			if (currentSlotOpen == null) return false;
			currentSlotOpen.save();
			return true;
		}
		
		/**
		 * clearSlot(num:int = 0):Boolean
		 * @since 	06/15/2011
		 * @param	num						Index of the slot to clear.
		 * @return  Boolean					If clearing the slot is successful.
		 */
		public static function clearSlotIndex(num:int = 0):Boolean
		{
			if (saveSlots.length <= num || num < 0) return false;
			saveSlots[num].clear();
			return true;
		}
		
		/**
		 * clearSlot(name:String):Boolean
		 * @since 	06/15/2011
		 * @param	name					Name of the slot to clear
		 * @return  Boolean					If clearing the slot is successful.
		 */
		public static function clearSlot(name:String):Boolean
		{
			for (var i:int = 0; i < saveSlots.length; i++)
			{
				if (saveSlots[i].getName() == name)
				{
					saveSlots[i].clear();
					return true;
				}
			}
			return false;
		}
		
		/**
		 * clearCurrentSlot():Boolean
		 * @since 	06/15/2011
		 * @return  Boolean					If clearing the current slot is successful.
		 */
		public static function clearCurrentSlot():Boolean
		{
			if (currentSlotOpen == null) return false;
			currentSlotOpen.clear();
			return true;
		}
		
		/**
		 * clearAllSlots():void
		 * @since 	06/15/2011
		 * @return  Void
		 */
		public static function clearAllSlots():void
		{
			for (var i:int = 0; i < saveSlots.length; i++)
			{
				saveSlots[i].clear();
			}
		}
		
		/**
		 * getCurrentSlot():Slot
		 * @since 	06/15/2011
		 * @return	Slot					The current open slot. Null if no open slot.
		 */
		public static function getCurrentSlot():Slot
		{
			return currentSlotOpen;
		}		
	}
}