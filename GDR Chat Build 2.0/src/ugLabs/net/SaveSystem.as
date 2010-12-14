package ugLabs.net
{
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	
	public class SaveSystem
	{
		//the overall shared object
		private static var mySharedObject:SharedObject;
		
		//extra general information data
		private static var saveObject:Object;
		
		//the array of slots of shared data
		private static var saveSlots:Array = [];
		
		/**
		 * init, a semi-constructor for the class
		 * @since 	05/10/2010
		 * @param	name					Name of the file.
		 * @param	localPath				The full or partial path to the SWF file that created the shared object.
		 * @param	isSecure				Determines whether access to this shared object is restricted to SWF files that are delivered over an HTTPS connection.
		 * @param	overwriteOnStart		Deletes the save file on the first load
		 * @return  Void
		 */
		static public function init(name:String = "savefile", localPath:String = null, isSecure:Boolean = false, overwriteOnStart:Boolean = false ):void
		{
			//get the shared object
			SaveSystem.mySharedObject = SharedObject.getLocal(name, localPath, isSecure);
			trace("[SaveSystem] Object retrieved/created: " + SaveSystem.mySharedObject);
			
			//if allowed to overwrite
			if (overwriteOnStart)
			{
				//clear the saved file
				SaveSystem.mySharedObject.clear();
				trace("[SaveSystem] Overwrite performed");
			}
			
		}
		
		
		
		
		
		
		
	}
}