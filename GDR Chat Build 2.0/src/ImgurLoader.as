package
{
    import com.adobe.images.PNGEncoder;
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.SecurityErrorEvent;
    import flash.events.IOErrorEvent
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.utils.ByteArray;
	import ugLabs.net.Kong;

    public class ImgurLoader
    {
        private var loader:URLLoader;

        private const API_KEY:String = "7eb1e4f3fe1ec214d3613e715b7a7c5d";
        private const UPLOAD_URL:String = "http://api.imgur.com/2/upload.xml";

        public function ImgurLoader() {

            loader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.VARIABLES;
            loader.addEventListener(Event.COMPLETE, onCookieSent);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);

            // Create a bitmapdata instance of a movieclip on the stage.
            var mc:MovieClip;
            var b:BitmapData = new BitmapData(mc.width, mc.height, true);
            b.draw(mc);
            var png:ByteArray = PNGEncoder.encode(b);
			
			var uniqueName:String = "gdrIM" + Kong.userName.substr(0, 7) + getTimer();
            var vars:String = "?key=" + API_KEY + "&name=name&title=title";
            var request:URLRequest = new URLRequest(UPLOAD_URL + vars);
            request.contentType = "application/octet-stream";
            request.method = URLRequestMethod.POST;
            request.data = png; // set the data object of the request to your image.

            loader.load(request);
        }
        // privates
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