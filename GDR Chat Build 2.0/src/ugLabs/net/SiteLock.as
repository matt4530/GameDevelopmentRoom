//package ugLabs.net
//{
	//import flash.display.Stage;
	//import flash.events.Event;
	//import flash.net.navigateToURL;
	//import flash.net.URLRequest;
	//import flash.net.URLVariables;
	//
	///**
	 //* ...
	 //* @author UnknownGuardian
	 //* 
	 //* @source Based of a Sitelock: fast&dirty domain lock in as3
	 //* @by by dx0ne http://dx0ne.laislacorporation.com
	 //* @link http://www.flashrights.com/domaincontrol.htm
	 //*/
	//public class SiteLock
	//{
		//private static var stage:Stage;
		//
		//private static var URLS:Array = ["swfcabin.com", "flashgamelicense.com"];
		//
		//public function SiteLock():void
		//{
		//}
		//
		//
		///**
		 //* Register the stage for SiteLock
		 //* @author  UnknownGuardian
		 //* @param	_stage The stage of the swf.
		 //* @return  void
		 //*/
		//public static function registerStage(_stage:Stage):void
		//{
			//SiteLock.stage = _stage;
			//trace("[SiteLock] Stage registered");
		//}
		//
		//
	//
		///**
		 //* Checks the URL of the swf and destroys the swf if necessary
		 //* @author  UnknownGuardian
		 //* @param	destroy If hosted illegally, attempt to destroy the swf internally
		 //* @return  Boolean Returns true if the swf is hosted on an approved location
		 //*/
		//public static function checkURL(destroy:Boolean = false, acceptedURLs:Array = null ):Boolean
		//{
			//set urls
			//if (acceptedURLs != null)
			//{
				//SiteLock.URLS = acceptedURLs.concat();
			//}
			//
			//
			//
			//get url
			//var url:String = SiteLock.stage.loaderInfo.url;
			//remove http and
			//var urlStart:Number = url.indexOf("://") + 3;
			//find first slash after the .com/.net/.etc
			//var urlEnd:Number = url.indexOf("/", urlStart);
			//get the domain name, eg: www.yahoo.com or www.google.com
			//var domain:String = url.substring(urlStart, urlEnd);
			//strip subdomains, etc
			//var LastDot:Number = domain.lastIndexOf(".") - 1;
			//remove the subdomains if located on any
			//var domEnd:Number = domain.lastIndexOf(".", LastDot) + 1;
			//get the real domain name
			//domain = domain.substring(domEnd, domain.length);
			//get the protocol, like if its a file hosted locally
			//var protocol:String = url.substring(0, url.indexOf(":"));
			//debug
			//trace("[SiteLock] " +  ((protocol == "file")?"The .swf is locally hosted.": "This .swf is hosted at " + domain));
			//
			//
			//loop through
			//var temp:Boolean = false;
			//for (var a:int = 0; a < SiteLock.URLS.length; a++)
			//{
				//if (domain == SiteLock.URLS[a])
				//{
					//temp = true;
					//break;
				//}
			//}
			//
			//
			//domains allowed located here. Hardcoded to prevent memory editors.
			//if (!temp && protocol != "file")
			//{ 
				//trace("[SiteLock] This .swf is hosted illegally");
				//navigateToURL(new URLRequest("http://kdugames.wordpress.com"), '_blank');
				//
				//
				//if (destroy)
				//{
					//insert .swf destruction code here
					//examples:				
						//remove main enter frame loop
						//set key vars to null/undefined
						//go to a certain frame
						//bring up stolen message
						//throw an error
					//
					//literally kill game
					//for (var i:int = 0; i < SiteLock.stage.numChildren; i++)
					//{
						//SiteLock.stage.removeChild(SiteLock.stage.getChildAt(i));
					//}
					//
				//}
				//return false;
			//}
			//else
			//{
				//do nothing
				//or continue
				//return true;
			//}
			//
		//}
	//}
	//
//}










/***
 * Revision 2
 *
 */

package ugLabs.net
{
	import flash.display.Stage;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.external.ExternalInterface;//
	
	/**
	 * ...
	 * @author UnknownGuardian
	 * 
	 * @source Based of a Sitelock: fast&dirty domain lock in as3
	 * @by by dx0ne http://dx0ne.laislacorporation.com
	 * @link http://www.flashrights.com/domaincontrol.htm
	 */
	public class SiteLock
	{
		private static var stage:Stage;
		
		private static var allowLocal:Boolean = false;
		
		private static var acceptedSites:Array = [];
		
		private static var deniedSites:Array = [];
		
		
		public function SiteLock():void
		{
		}
		
		
		/**
		 * Register the stage for SiteLock
		 * @author  UnknownGuardian
		 * @param	_stage The stage of the swf.
		 * @return  void
		 */
		public static function registerStage(_stage:Stage):void
		{
			SiteLock.stage = _stage;
			trace("[SiteLock] Stage registered");
		}
		
		
		/**
		 * Sets a list of allowed sites
		 * @author  UnknownGuardian
		 * @param	sitesArray  Array of strings of the url. Use base URL, like google.com, yahoo.com.
		 * @return  void
		 */
		public static function allowSites(sitesArray:Array):void
		{
			SiteLock.acceptedSites = sitesArray.concat();
			trace("[SiteLock] Accepted sites: " + SiteLock.acceptedSites);
		}
		
		/**
		 * Sets a list of denied sites
		 * @author  UnknownGuardian
		 * @param	sitesArray  Array of strings of the url. Use base URL, like google.com, yahoo.com.
		 * @return  void
		 */
		public static function denySites(sitesArray:Array):void
		{
			SiteLock.deniedSites = sitesArray.concat();
			trace("[SiteLock] Denied sites: " + SiteLock.deniedSites);
		}
		
		/**
		 * Sets local testing restrictions
		 * @author  UnknownGuardian
		 * @return  void
		 */
		public static function allowLocalPlay(permission:Boolean = true ):void
		{
			SiteLock.allowLocal = permission
		}
		
		
		//May or may not work. Unsure. Do NOT use
		public static function checkAllowNetworking():Boolean
		{
			var allowNetworking:Object;
			 
			try{
				allowNetworking = ExternalInterface.call(null);
			}catch ( e:SecurityError ) {
				trace("[SiteLock] External links blocked.");
				return false;
			}
			trace("[SiteLock] External links enabled.");
			return true;
		}
		
		
		
		
		
		
		
		
		
		
		/**
		 * Checks the URL of the swf and destroys the swf if necessary
		 * @author  UnknownGuardian
		 * @param	destroy If hosted illegally, attempt to destroy the swf internally
		 * @return  Boolean Returns true if the swf is hosted on an approved location
		 */
		public static function checkURL(destroy:Boolean = false ):Boolean
		{
			//get url
			var url:String = SiteLock.stage.loaderInfo.url;
			//remove http and
			var urlStart:Number = url.indexOf("://") + 3;
			//find first slash after the .com/.net/.etc
			var urlEnd:Number = url.indexOf("/", urlStart);
			//get the domain name, eg: www.yahoo.com or www.google.com
			var domain:String = url.substring(urlStart, urlEnd);
			//strip subdomains, etc
			var LastDot:Number = domain.lastIndexOf(".") - 1;
			//remove the subdomains if located on any
			var domEnd:Number = domain.lastIndexOf(".", LastDot) + 1;
			//get the real domain name
			domain = domain.substring(domEnd, domain.length);
			//get the protocol, like if its a file hosted locally
			var protocol:String = url.substring(0, url.indexOf(":"));
			//debug
			trace("[SiteLock] " +  ((protocol == "file")?"The .swf is locally hosted.": "This .swf is hosted at " + domain));
			
			
					
			// if not located on the accepted sites list and its not a file				 OR         if its a file and do not allow local playing
			if ((SiteLock.acceptedSites.indexOf(domain) == -1  && protocol != "file")    ||          (protocol == "file" && !SiteLock.allowLocal))
			
			
			//domains allowed located here. Hardcoded to prevent memory editors.
			//if (domain != "megaswf.com" && domain != "flashgamelicense.com" && protocol != "file")
			{ 
				trace("[SiteLock] This .swf is hosted illegally");
				navigateToURL(new URLRequest("http://profusiongames.com"), '_blank');
				
				
				if (destroy)
				{
					//insert .swf destruction code here
					//examples:				
						//remove main enter frame loop
						//set key vars to null/undefined
						//go to a certain frame
						//bring up stolen message
						//throw an error
					
					//literally kill game
					while( SiteLock.stage.numChildren > 0)
					{
						SiteLock.stage.removeChild(SiteLock.stage.getChildAt(0));
					}
					//throw error for debugger version
					//throw new Error("This game is hosted illegally. If you find this game here, please contact Team Profusion at kdugames.wordpress.com", 9001);
				}
				return false;
			}
			else
			{
				//do nothing
				//or continue
				return true;
			}
		}
			
			
			
		/**
		 * Checks the URL of the swf and destroys the swf if necessary
		 * @author  UnknownGuardian
		 * @param	destroy If hosted illegally, attempt to destroy the swf internally
		 * @return  Boolean Returns true if the swf is hosted on an approved location
		 */
		public static function isLocal():Boolean
		{
			//get url
			var url:String = SiteLock.stage.loaderInfo.url;
			//remove http and
			var urlStart:Number = url.indexOf("://") + 3;
			//find first slash after the .com/.net/.etc
			var urlEnd:Number = url.indexOf("/", urlStart);
			//get the domain name, eg: www.yahoo.com or www.google.com
			var domain:String = url.substring(urlStart, urlEnd);
			//strip subdomains, etc
			var LastDot:Number = domain.lastIndexOf(".") - 1;
			//remove the subdomains if located on any
			var domEnd:Number = domain.lastIndexOf(".", LastDot) + 1;
			//get the real domain name
			domain = domain.substring(domEnd, domain.length);
			//get the protocol, like if its a file hosted locally
			var protocol:String = url.substring(0, url.indexOf(":"));
			
			return protocol == "file";
		}
	}
	
}





/**
 * Original source code
 */





//
//var myMenu:ContextMenu = new ContextMenu();
//myMenu.hideBuiltInItems();
//this.contextMenu = myMenu;
 //
//// AS3 Version - Protection source : domain restriction
////////////////////////////////////////////////
///*
//fast&dirty domain lock in as3
//by dx0ne http://dx0ne.laislacorporation.com
//based on http://www.flashrights.com/domaincontrol.htm
//*/
//import flash.events.*;
//import flash.display.LoaderInfo;
//
//import flash.display.Sprite;
//import flash.net.navigateToURL;
//import flash.net.URLRequest;
//import flash.net.URLVariables;
//
 //
//addEventListener(Event.ENTER_FRAME, enterFrameHandler);
 //
//function enterFrameHandler(event:Event):void {
//var url:String=stage.loaderInfo.url; // this is the magic _url successor
//var urlStart:Number = url.indexOf("://")+3;
//var urlEnd:Number = url.indexOf("/", urlStart);
//var domain:String = url.substring(urlStart, urlEnd);
//var LastDot:Number = domain.lastIndexOf(".")-1;
//var domEnd:Number = domain.lastIndexOf(".", LastDot)+1;
//domain = domain.substring(domEnd, domain.length);
//var protocol = url.substring(0, url.indexOf(":"));
//txt.text=domain; //dynamic textfield with instance name : "text"
 //
//if (domain != "monkeypro.net" && domain != "flashgamelicense.com" && domain !=
//"aorchard.com" && protocol != "file") { // allowing several domains name and local  
 //
// return false; do nasty things to thief
//gotoAndStop(5279); // Go to an empty frame to punish the thief
 //
// Or redirect to url website
//navigateToURL(new URLRequest("http://www.aorchard.com"), '_self');
//
//}
//else{
// return true; // welcome
//removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
//gotoAndPlay(2); // or let play normally
 //
//}
//}
 //
 //
 //
//////////
