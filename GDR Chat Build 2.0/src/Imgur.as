package {

	import flash.display.BitmapData;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.describeType;

	import mx.graphics.codec.PNGEncoder;
	import mx.utils.Base64Encoder;

	/**
	 * My AS3 implementation of the imgur-api
	 *
	 * @author  Julien Castelain	<jcastelain@gmail.com>
	 * @see     http://code.google.com/p/imgur-api
	 * @version 0.1
	 *
	 *
	 * dependencies:
	 * Flex SDK >= 3.3.0
	 * mx.graphics.codec.PNGEncoder
	 * mx.utils.Base64Encoder)
	 *
	 * created on 2009/12/14
	 *
	 */

	[Event(name="complete", type="flash.events.Event")]
	[Event(name="progress", type="flash.events.ProgressEvent")]

	 public class Imgur extends EventDispatcher {

		private var _key:String;

		private var _response:ImgurResponse;

		private var _responseFormat:String;

		private var _loaders:Array;

		//----------------------------------------------------------------------
		// constants #wtf
		//----------------------------------------------------------------------

		public static const GALLERY_SORT_LATEST:String =  "gallerySortAll";
		public static const GALLERY_SORT_POPULAR:String = "gallerySortPopular";
		public static const GALLERY_VIEW_ALL:String =     "galleryViewAll";
		public static const GALLERY_VIEW_MONTH:String =   "galleryViewMonth";
		public static const GALLERY_VIEW_WEEK:String =    "galleryViewWeek";
		public static const GALLERY_COUNT_MIN:int =       0;
		public static const GALLERY_COUNT_MAX:int =       50;
		public static const GALLERY_PAGE_MIN:int =        1;

		public static const IMAGE_DELETE_URL:String =  "http://imgur.com/api/delete";
		public static const IMAGE_GALLERY_URL:String = "http://imgur.com/api/gallery";
		public static const IMAGE_UPLOAD_URL:String =  "http://imgur.com/api/upload";

		public static const RESPONSE_FORMAT_JSON:String = "json";
		public static const RESPONSE_FORMAT_XML:String =  "xml";

		public static const KEY_ERROR_MESSAGE:String = "You must specify an API KEY for this service. " +
			"check http://imgur.com/register/api/."

		public function Imgur(key:String, responseFormat:String = "xml") {
			_key = key;
			_responseFormat = responseFormat;
			_loaders = [ ];
		}

		//----------------------------------------------------------------------
		// getter/setters
		//----------------------------------------------------------------------

		public function get key():String {
			return _key;
		}

		public function set key(value:String):void {
			if (value == _key)
				return;
			_key = value;
		}

		public function get response():ImgurResponse {
			return _response;
		}

		public function get responseFormat():String {
			return _responseFormat;
		}

		public function set responseFormat(value:String):void {
			if (value == _responseFormat)
				return;

			if(value != RESPONSE_FORMAT_JSON || value != RESPONSE_FORMAT_XML)
				throw new Error("The reponse format can either be JSON or XML.");

			_responseFormat = value;
		}

		//----------------------------------------------------------------------
		//  service methods
		//----------------------------------------------------------------------

		// since "delete" is an ActionScript3 reserved keyword,
		// I decided to change the name of this method
		public function destroy(deleteHash:String):void {
			if (!validKey())
				throw new Error(Imgur.KEY_ERROR_MESSAGE);

			var request:URLRequest = new URLRequest(Imgur.IMAGE_DELETE_URL +
				"/" + deleteHash + "." + _responseFormat);

			var loader:URLLoader = createLoader();
			loader.load(request);
		}

		public function upload( image: * ):void {
			if (!validKey())
				throw new Error(Imgur.KEY_ERROR_MESSAGE);

			var data:*;

			if (image is String)
				data = image
			else if (image is BitmapData) {

				var byteArray:ByteArray = new PNGEncoder().encode(image);

				data = new Base64Encoder();
				data.encodeBytes(byteArray);
			}

			var variables:URLVariables = new URLVariables();
			variables.key   = key;
			variables.image = data;

			var request:URLRequest = new URLRequest(Imgur.IMAGE_UPLOAD_URL + "." + _responseFormat);
			request.data = variables;
			request.method = URLRequestMethod.POST;

			var loader:URLLoader = createLoader();
			loader.load(request);
		}

		public function gallery(sort:String = "latest", view:String = "all", count:int = 20, page:int = 1 ):void {
			if (!validKey())
				throw new Error(Imgur.KEY_ERROR_MESSAGE);

			var variables:URLVariables = new URLVariables();
			variables.sort = sort;
			variables.view = view;
			variables.count = count;
			variables.page = page;

			var request:URLRequest = new URLRequest(Imgur.IMAGE_GALLERY_URL + "." + _responseFormat);
			request.data = variables;

			var loader:URLLoader = createLoader();
			loader.load(request);
		}


		//----------------------------------------------------------------------
		// private methods
		//----------------------------------------------------------------------

		private function validKey():Boolean {
			if (key == null || key == "" || key.length < 32)
				return false;
			else
				return true;
		}


		private function createLoader( ):URLLoader {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.addEventListener(ProgressEvent.PROGRESS, loaderProgessHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderErrorHandler);

			_loaders.push(loader);

			return loader;
		}

		private function destroyLoader(loader:URLLoader):void {
			for (var i:int = 0; i < _loaders.length; i++) {
				if (_loaders[i] == loader) {
					loader.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
					loader.removeEventListener(ProgressEvent.PROGRESS, loaderProgessHandler);
					loader.removeEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
					loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderErrorHandler);

					_loaders.splice(i, 1);
					loader = null;
				}
			}
		}

		//----------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------

		protected function loaderCompleteHandler(event:Event):void {

			var loader:URLLoader = event.currentTarget as URLLoader;

			var rsp:XML = new XML(loader.data);
			rsp = rsp.normalize();
			// trace("rsp : ", new XMLList( rsp.image ) );

			_response = ImgurResponse.fromObject(rsp);

			dispatchEvent(new Event(Event.COMPLETE));
			destroyLoader(loader);
		}

		protected function loaderProgessHandler(event:ProgressEvent):void {

			if (event.bytesTotal == 0) // we don't always need a progress handler
				return;

			dispatchEvent(event);
		}

		protected function loaderErrorHandler(event:Event):void {
			trace("error : ", event);
			dispatchEvent(event);
			destroyLoader(event.currentTarget as URLLoader);
		}
	}

}















/*package
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
}*/