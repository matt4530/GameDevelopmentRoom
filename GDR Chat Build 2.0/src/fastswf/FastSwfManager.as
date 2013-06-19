package fastswf 
{
	import com.nathancolgate.s3_swf_upload.S3Queue;
	import fl.controls.Button;
	import fl.controls.ProgressBar;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.Security;
	import org.flashdevelop.utils.FlashConnect;
	import ugLabs.net.Kong;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class FastSwfManager extends FastSwf 
	{
		public static var queue:S3Queue;
		public static var _singleFileDialogBox:FileReference;
		private var _fileFilter:FileFilter;
		private var _fileSizeLimit:Number = 20000000; //bytes
		private var _prefixPath:String = "";
		private var _signatureURL:String = "http://www.fastswf.com/s3_uploads.xml";
		public static var progressBar:ProgressBar;
		public static var openBtn:Button;
		public static var browseBtn:Button;
		
		public static var last_loaded:String = "";
		private static var _site:String = "";
		public static var delete_site:String = "";
		private static var i:FastSwfManager;
		private static var hasSendInformation:Boolean = false;
		public function FastSwfManager() 
		{
			i = this;
			Security.allowDomain("*");
			browse.enabled = true;
			browse.addEventListener(MouseEvent.CLICK, clickHandler);
			queue = new S3Queue(_signatureURL, _prefixPath);
			FastSwfManager.progressBar = preloader;
			FastSwfManager.openBtn = open;
			FastSwfManager.browseBtn = browse;
			
			FastSwfManager.progressBar.enabled = false;
			FastSwfManager.progressBar.mode = "manual";
			
			_fileFilter = new FileFilter("SWFs", "*.swf");
		}
		
		private function startUploading(e:MouseEvent):void
		{
			queue.startUploadingHandler();
			
			
			
			browseBtn.enabled = false;
			browseBtn.label = "Uploading...";
			browseBtn.removeEventListener(MouseEvent.CLICK, clickHandler);
			trace("Added file to queue, opening up uploading");
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			FastSwfManager.openBtn.enabled = false;
			FastSwfManager.openBtn.removeEventListener(MouseEvent.CLICK, gotoSite);
			_singleFileDialogBox = new FileReference();
			_singleFileDialogBox.browse([_fileFilter]);
			_singleFileDialogBox.addEventListener(Event.SELECT, selectFileHandler);
		}
		
		private function selectFileHandler(e:Event):void 
		{
			addFile(FileReference(e.target));
		}
		
		private function addFile(file:FileReference):void{
			// ExternalInterface.call('s3_swf.jsLog','addFile');
			if (!file) return;
			if (queue.length > 0)
				queue.removeAll();
			if (checkFileSize(file.size)){
				// ExternalInterface.call('s3_swf.jsLog','Adding file to queue...');
				queue.addItem(file);
				
				browseBtn.removeEventListener(MouseEvent.CLICK, clickHandler);
				browseBtn.label = "Upload";
				browseBtn.enabled = true;
				browseBtn.addEventListener(MouseEvent.CLICK, startUploading);
				trace("Added file to queue, opening up uploading");
			}
		}
		
		// Checks the files do not exceed maxFileSize | if maxFileSize == 0 No File Limit Set
		private function checkFileSize(filesize:Number):Boolean{
			var r:Boolean = false;
			//if  filesize greater then maxFileSize
			if (filesize > _fileSizeLimit){
				r = false;
			} else if (filesize <= _fileSizeLimit){
				r = true;
			}
			if (_fileSizeLimit == 0){
				r = true;
			}
			return r;
		}
		
		static public function get site():String 
		{
			return _site;
		}
		
		static public function set site(value:String):void 
		{
			_site = value;
			last_loaded = _singleFileDialogBox.name.replace(/[^a-zA-Z 0-9\.]+/g, "");
			
			hasSendInformation = false;
			
			FastSwfManager.progressBar.enabled = false;
			FastSwfManager.browseBtn.label = "Upload New";
			FastSwfManager.browseBtn.enabled = true;
			FastSwfManager.browseBtn.addEventListener(MouseEvent.CLICK, FastSwfManager.i.clickHandler);
			
			FastSwfManager.openBtn.enabled = true;
			FastSwfManager.openBtn.addEventListener(MouseEvent.CLICK, FastSwfManager.i.gotoSite);
		}
		
		private function gotoSite(e:MouseEvent):void 
		{
			FlashConnect.trace(FastSwfManager.site);
			navigateToURL(new URLRequest("http://www.fastswf.com" + FastSwfManager.site));
			
			if (!hasSendInformation)
			{
				hasSendInformation = true;
				
				
				Kong.services.privateMessage( {
					content:('You shared _' + last_loaded + '_ in GDR: *View*: http://www.fastswf.com'+FastSwfManager.site + '   and   ' + '*Delete*: http://www.fastswf.com' + FastSwfManager.delete_site)
				});
			}
		}
		
		
		
	}

}