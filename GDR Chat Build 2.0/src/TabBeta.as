package  
{
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.DataEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class TabBeta extends TabBetaUI
	{
		public var fileRef:FileReference = new FileReference();
		private var loader:URLLoader;

        private const API_KEY:String = "7eb1e4f3fe1ec214d3613e715b7a7c5d";
        private const UPLOAD_URL:String = "http://api.imgur.com/2/upload.xml";
		
		public function TabBeta() 
		{
			browsebutton.addEventListener(MouseEvent.CLICK, browseForFile);
			fileRef.addEventListener(Event.SELECT, selectHandler);
			fileRef.addEventListener(Event.COMPLETE, completeHandler);
			
			loader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.VARIABLES;
            //loader.addEventListener(Event.COMPLETE, onCookieSent);
            fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            fileRef.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			fileRef.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onSend);
		}
		
		private function completeHandler(e:Event):void 
		{
			trace("uploaded");
		}
		
		private function selectHandler(e:Event):void 
		{
			trace("selected");
			var uniqueName:String = "gdrIMagemassivetest";//+ Kong.userName.substr(0, 7) + getTimer();
            var vars:String = "?key=" + API_KEY + "&name=name&title=title";
            var request:URLRequest = new URLRequest(UPLOAD_URL + vars);
            request.contentType = "application/octet-stream";
            request.method = URLRequestMethod.POST;
            //request.data = png; // set the data object of the request to your image.
			
			
			fileRef.upload(request);
		}
		
		private function browseForFile(e:MouseEvent):void 
		{
			fileRef.browse([ new FileFilter("Images", "*.jpg;*.gif;*.png")]);
		}
		
		
		private function onSend(e:Event):void {
            var res:XML = new XML(unescape(loader.data));
            trace(res);
        }
        private function onIOError(e:IOErrorEvent):void {
            trace("ioErrorHandler: " + e);
            // Handle error
        }
        private function onSecurityError(e:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + e);
            // handle error
        }
	}

}