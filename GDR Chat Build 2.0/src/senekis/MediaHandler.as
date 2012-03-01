package senekis
{
	
//{ IMPORTS	
	import org.flashdevelop.utils.FlashConnect;
	//import com.adobe.images.PNGEncoder;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.IOErrorEvent
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
//}
	
	final public class MediaHandler extends Sprite
	{
//{ VARIABLES
		// PRIVATE / PROTECTED ****************************************************************
		//VARIABLES  
		private var imageTimes:Array, swfTimes:Array, shared:Boolean, pic:Bitmap, bitmapdata:BitmapData, load:Button, share:Button, clear:Button, open:Button, download:Button, swfData:ByteArray, imgData:ByteArray, container:Container, media:DisplayObject, 
		// > .bmp for global/images filter and get image?
			globalFilter:FileFilter = new FileFilter("Media", "*.swf;*.jpg;*.gif;*.png"), imageFilter:FileFilter = new FileFilter("Images", "*.jpg;*.gif;*.png"), SWFFilter:FileFilter = new FileFilter("Flash Movies", "*.swf"), reference:FileReference, w:int = 615, h:int = 545, loader:Loader, swf:Loader, logo:Logo, matrix:Matrix, scale:Number = 1.0, ui:Sprite, status:Text, colorField:TextField, urlLoader:URLLoader;
		//CONSTANTS 
		private const IMAGE_LIMIT:int = 5, SWF_LIMIT:int = 10, SPACING:int = 5, Y:int = h - 30, SIZE:int = 250, MAXW:int = 500, MAXH:int = 450, IMGUR_KEY:String = "2b0aea9d0c043686be41f9854f0a5de3", IMGUR:String = "http://api.imgur.com/2/upload.xml", SWF_PHP:String = "http://senekis.net/swf/gdr/gdr.php";
		
		// PUBLIC / INTERNAL   ****************************************************************
		//VARIABLES  
		public var isExpanded:Boolean, url:String, type:String, title:String;
		
		//CONSTANTS  
		
		// PUBLIC STATIC     ****************************************************************
		//VARIABLES  
		
		//CONSTANTS 
//}
		
		/*CONSTRUCTOR*/
		public function MediaHandler():void
		{
			addEventListener(Event.ADDED_TO_STAGE, go);
			Security.allowDomain("senekis.net");
			checkSave();
		}
		
		/*---------------------------------------------------------------------------------------------*/
		//              PRIVATE / PROTECTED ****************************************************************
		
//{ STARTUP		
		
		/*ADDED TO STAGE*/
		private function go(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, go);
			stage.addEventListener(KeyboardEvent.KEY_UP, forceUnload);
			buildUI();
		}
		
		/*UI*/
		private function buildUI():void
		{
			container = new Container(0, 0, w, h);
			ui = new Sprite();
			addChild(container);
			load = new Button("Load");
			load.addEventListener(MouseEvent.CLICK, lod);
			ui.addChild(load);
			load.x = 360;
			share = new Button("Share");
			ui.addChild(share);
			share.x = load.x + load.width + SPACING;
			open = new Button("Open");
			open.addEventListener(MouseEvent.CLICK, ope);
			ui.addChild(open);
			open.x = load.x - open.width - SPACING;
			download = new Button("Download");
			download.addEventListener(MouseEvent.CLICK, downloa);
			ui.addChild(download);
			download.x = open.x - download.width - SPACING;
			clear = new Button("Clear");
			clear.addEventListener(MouseEvent.CLICK, unload);
			ui.addChild(clear);
			clear.x = download.x - clear.width - SPACING;
			load.y = share.y = download.y = clear.y = open.y = Y;
			status = new Text(w * .95, Y);
			status.x = 10;
			ui.addChild(status);
			addChild(ui);
			color = 0x1A1A1A;
			status.text = "Welcome.";
			logo = new Logo();
			container.addChild(logo);
			logo.x = (w - logo.width) * .5;
			logo.y = h * .35;
			media = logo;
		}
		
//}
		
//{ SELECT AND LOAD
		
		/*LOAD LOCAL*/
		private function lod(e:MouseEvent):void
		{
			reference = new FileReference();
			reference.browse([globalFilter, imageFilter, SWFFilter]);
			reference.addEventListener(Event.SELECT, select);
		}
		
		/*SELECT LOCAL*/
		private function select(e:Event):void
		{
			reference.removeEventListener(Event.SELECT, select);
			title = type = reference.name;
			status.text = "Selected: " + title;
			type = type.substring(type.length - 4, type.length).toLowerCase();
			title = title.substring(0, title.indexOf(type));
			if (SWF)
			{
				if ((reference.size / 1024) > SIZE)
				{
					status.text = "File is too big. Max allowed size is " + SIZE.toString() + " kb.";
					return;
				}
			}
			reference.load();
			reference.addEventListener(Event.COMPLETE, complete);
		}
		
		/*FILE SELECTED*/
		private function complete(e:Event):void
		{
			reference.removeEventListener(Event.COMPLETE, complete);
			reference = FileReference(e.target);
			loader = new Loader();
			//loader.addEventListener(IOErrorEvent.IO_ERROR,error);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleMedia);
			if (SWF)
				swfData = reference.data as ByteArray;
			else
				imgData = reference.data as ByteArray;
			try
			{
				loader.loadBytes(reference.data as ByteArray, new LoaderContext(false, new ApplicationDomain(null)));
			}
			catch (e:Error)
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleMedia);
				status.text = "Bad file.";
			}
			status.text = status.text.split("Selected").join("Loading");
		}
		
		/*MEDIA LOADED*/
		private function handleMedia(e:Event):void
		{
			//loader.removeEventListener(IOErrorEvent.IO_ERROR,error);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleMedia);
			scale = 1.00;
			url = "";
			if (media)
				clearMedia();
			if (image)
			{
				if (loader.width > loader.height)
				{
					if (loader.width > MAXW)
						scale = MAXW / loader.width;
				}
				else
				{
					if (loader.height > MAXH)
						scale = MAXH / loader.height;
				}
				matrix = new Matrix;
				matrix.scale(scale, scale);
				bitmapdata = new BitmapData(loader.width * scale, loader.height * scale, true, 0);
				bitmapdata.draw(loader, matrix);
				pic = (new Bitmap(bitmapdata));
				container.addChild(pic);
				pic.x = (w - pic.width) * .5;
				pic.y = ((h * .8) - pic.height) * .5;
				media = pic;
				status.text = "Image loaded. Use the share button to upload and share.";
			}
			else if (SWF)
			{
				//{ Unused? Add loader to screen
				/*media=swf=loader;
				   container.addChild(swf);
				   var movie:DisplayObject=swf.content;
				   if(movie.width>movie.height){
				   if(movie.width>MAXW)scale=MAXW/movie.width;
				   } else{
				   if(movie.height>MAXH)scale=MAXH/movie.height;
				   }
				 movie.scaleX=media.scaleX=movie.scaleY=media.scaleY=scale;*/
				//}
				showSWF();
				status.text = "SWF loaded. Use the share button to upload and share.";
			}
			shared = false;
			share.addEventListener(MouseEvent.CLICK, shar);
		}
		
//}
		
//{ UPLOAD
		
		/*SHARE MEDIA*/
		private function shar(e:MouseEvent):void
		{
			if (!type)
			{
				status.text = "There's nothing to share!";
				return;
			}
			if (!shared)
			{
				checkTime();
				share.removeEventListener(MouseEvent.CLICK, shar);
				if (image)
				{
					if (imageTimes.length < IMAGE_LIMIT)
					{
						urlLoader = new URLLoader();
						urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
						urlLoader.addEventListener(Event.COMPLETE, imgurUpload);
						urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, error);
						urlLoader.addEventListener(IOErrorEvent.IO_ERROR, error);
						var vars:String = "?key=" + IMGUR_KEY + "&name=name&title=title", request:URLRequest = new URLRequest(IMGUR + vars);
						request.contentType = "application/octet-stream";
						request.method = URLRequestMethod.POST;
						//request.data=PNGEncoder.encode(pic.bitmapData); 
						request.data = imgData;
						urlLoader.load(request);
						status.text = "Uploading file to Imgur...";
					}
					else
					{
						share.addEventListener(MouseEvent.CLICK, shar);
						status.text = "You can only upload " + IMAGE_LIMIT.toString() + " images every hour.";
					}
				}
				else if (SWF)
				{
					if (swfTimes.length < SWF_LIMIT)
					{
						request = new URLRequest(SWF_PHP)
						request.method = URLRequestMethod.POST;
						request.requestHeaders.push(new URLRequestHeader("Content-type", "application/octet-stream"));
						request.data = swfData;
						urlLoader = new URLLoader();
						urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, error);
						urlLoader.addEventListener(IOErrorEvent.IO_ERROR, error);
						urlLoader.addEventListener(Event.COMPLETE, swfUpload);
						urlLoader.load(request);
						status.text = "Uploading SWF file...";
					}
					else
					{
						share.addEventListener(MouseEvent.CLICK, shar);
						status.text = "You can only upload " + SWF_LIMIT.toString() + " Flash files every hour.";
					}
				}
				else
				{
					status.text = "Select a valid file first!"
					share.addEventListener(MouseEvent.CLICK, shar);
				}
			}
			else
			{
				var mode:String;
				if (SWF)
					mode = "swf";
				else if (image)
					mode = type;
				dispatchEvent(new MediaEvent(MediaEvent.SHARE, mode));
					//trace(mode);
					//status.text="You already shared this file.";
			}
		}
		
		/*SWF UPLOAD*/
		private function swfUpload(e:Event):void
		{
			urlLoader.removeEventListener(Event.COMPLETE, swfUpload);
			var s:String = urlLoader.data.toString(), v:URLVariables = new URLVariables();
			status.text = s;
			v.decode(s);
			url = "http://" + (v.url.substr(0, v.url.indexOf("<!--")) + v.url.substr(v.url.lastIndexOf(">") + 1, v.url.length - 1)).split(/\s/).join("");
			urlLoader.removeEventListener(Event.COMPLETE, swfUpload);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, error);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, error);
			urlLoader = null;
			share.addEventListener(MouseEvent.CLICK, shar);
			shared = true;
			status.text = "File uploaded. Use the \"open\" button to view it in a new window.";
			dispatchEvent(new MediaEvent(MediaEvent.SHARE, "swf"));
			swfTimes[swfTimes.length] = new Date().getTime();
			updateSave(2);
		}
		
		/*IMGUR UPLOAD*/
		private function imgurUpload(e:Event):void
		{
			var xml:XML = new XML(unescape(urlLoader.data));
			//trace(xml);
			url = xml.toString();
			//url=url.substring(url.indexOf("<original>")+10,url.indexOf(type)+4);
			//var i:int=url.indexOf("<original>")+10;
			//url=url.substring(i,url.indexOf("</original>",i));
			url = XML(url).descendants("original")[0];
			urlLoader.removeEventListener(Event.COMPLETE, imgurUpload);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, error);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, error);
			urlLoader = null;
			share.addEventListener(MouseEvent.CLICK, shar);
			shared = true;
			status.text = "File uploaded to Imgur. Use the \"open\" button to view it in a new window.";
			dispatchEvent(new MediaEvent(MediaEvent.SHARE, type));
			imageTimes[imageTimes.length] = new Date().getTime();
			updateSave(1);
		}
		
//}
		
//{ LOAD FROM URL
		
		/*LOADED URL (IMAGE)*/
		private function urlImage(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, urlImage);
			type = title;
			type = type.substring(type.length - 4, type.length).toLowerCase();
			//status.text="File loaded.";
			if (media)
				clearMedia();
			scale = 1.0;
			if (loader.width > loader.height)
			{
				if (loader.width > MAXW)
					scale = MAXW / loader.width;
			}
			else
			{
				if (loader.height > MAXH)
					scale = MAXH / loader.height;
			}
			matrix = new Matrix;
			matrix.scale(scale, scale);
			bitmapdata = new BitmapData(loader.width * scale, loader.height * scale, true, 0);
			bitmapdata.draw(loader, matrix);
			pic = (new Bitmap(bitmapdata));
			container.addChild(pic);
			pic.x = (w - pic.width) * .5;
			pic.y = ((h * .8) - pic.height) * .5;
			media = pic;
			shared = true;
		/*else if(SWF){
		   media=swf=loader;
		   container.addChild(swf);
		   shared=true;
		 }*/
		}
		
//{ unused: old code to handle SWF downloads
		
		/*LOADED URL (SWF)*/ /*private function urlSWF(e:Event):void{
		   swfData=e.target.data;
		   urlLoader.removeEventListener(Event.COMPLETE,urlSWF);
		   urlLoader=null;
		   type=".swf";
		   showSWF();
		   status.text="SWF loaded. Use the download button to get it.";
		   shared=true;
		 }*/
		
//}
		
		/*HANDLE URL DOWNLOAD*/
		private function urlFile(e:Event):void
		{
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, error);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, error);
			if (SWF)
			{
				swfData = e.target.data;
				showSWF();
			}
			else if (image)
			{
				imgData = e.target.data;
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, urlImage);
				loader.loadBytes(imgData);
			}
			urlLoader.removeEventListener(Event.COMPLETE, urlFile);
			urlLoader = null;
			status.text = "File loaded. Use the \"download\" button to get it or the \"open\" button to load it in a new window.";
			shared = true;
		}
		
//}
		
		/*OPEN*/
		private function ope(e:MouseEvent):void
		{
			if (url)
				navigateToURL(new URLRequest(url), "_blank");
			else
				status.text = "There's no URL to navigate to.";
		}
		
		/*DOWNLOAD*/
		private function downloa(e:MouseEvent):void
		{
			var reference:FileReference = new FileReference();
			if (SWF)
			{
				if (swfData)
					reference.save(swfData, "SWF_FILE.swf");
			}
			else if (image)
			{
				if ( /*pic*/imgData)
					reference.save( /*PNGEncoder.encode(pic.bitmapData)*/imgData, "IMAGE_FILE" + type);
			}
			else
				status.text = "There's nothing to download.";
		}
		
//{ OTHER
		
		/*CHECK TIME*/
		private function checkTime():void
		{
			var d:Number = new Date().getTime();
			if (imageTimes.length)
				while (((d - imageTimes[0]) * .001) > 3600)
				{
					imageTimes.splice(0, 1);
					if (!imageTimes.length)
						break;
				}
			if (swfTimes.length)
				while (((d - swfTimes[0]) * .001) > 3600)
				{
					swfTimes.splice(0, 1);
					if (!swfTimes.length)
						break;
				}
		}
		
		/*SAVE FILE*/
		private function checkSave():void
		{
			if (!Save.data.times)
				Save.create();
			imageTimes = Save.data.times;
			swfTimes = Save.data.times2;
			Save.flush();
		}
		
		/*UPATE SAVE*/
		private function updateSave(a:int):void
		{
			if (a == 1)
				Save.data.times = imageTimes;
			else
				Save.data.times2 = swfTimes;
		}
		
		/*CLEAR*/
		private function clearMedia(e:MouseEvent = null):void
		{
			if (media.stage)
				container.removeChild(media);
			if (media is Bitmap)
				(media as Bitmap).bitmapData.dispose();
			//else if(media is Loader)(media as Loader).unloadAndStop();
			//else if(media is Logo)(media as Logo).stop();
			if (e)
				url = "";
			media = null;
		/*if(e){
		   logo=new Logo();
		   container.addChild(logo);
		   logo.x=(w-logo.width)*.5;
		   logo.y=h*.35;
		   media=logo;
		   status.text="You can't get rid of the heart!";
		 }*/
		}
		
		/*KEYBOARD UNLOAD*/
		private function forceUnload(e:KeyboardEvent):void
		{
			if (e.keyCode == 27)
				unload();
		}
		
		/*SWF ICON*/
		private function showSWF():void
		{
			media = new SWFIcon();
			container.addChild(media);
			media.x = (container.width - media.width) * .5;
			media.y = (container.height - media.height) * .5;
		}
		
		/*IS IMAGE*/
		private function get image():Boolean
		{
			if (!type)
				return false;
			var allowed:Vector.<String> = new <String>[".png", ".jpg", /*".bmp"*/ "♥", ".gif"], i:int = -1, l:int = allowed.length;
			while (++i < l)
				if (type == allowed[i])
					return true;
			return false;
		}
		
		/*IS SWF*/
		private function get SWF():Boolean
		{
			return type == ".swf";
		}
		
		/*COLOR*/
		private function set color(c:uint):void
		{
			container.background = c //status.color=c;
		}
		
		/*ERROR*/
		private function error(e:Event):void
		{
			status.text = "Error. :sadface:";
			//FlashConnect.trace(e);
		}
		
//}
		
		//              PUBLIC / INTERNAL   ****************************************************************
		
		/*DESTROY*/
		public function destroy():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_UP, forceUnload);
			removeEventListener(Event.ADDED_TO_STAGE, go);
			if (reference)
			{
				reference.removeEventListener(Event.SELECT, select);
				reference.removeEventListener(Event.COMPLETE, complete);
				reference = null;
			}
			if (loader)
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleMedia);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, urlImage);
				loader = null;
			}
			if (urlLoader)
			{
				//urlLoader.removeEventListener(Event.COMPLETE,urlSWF);
				urlLoader.removeEventListener(Event.COMPLETE, imgurUpload);
				urlLoader.removeEventListener(Event.COMPLETE, swfUpload);
				urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, error);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, error);
				urlLoader = null;
			}
			imageFilter = null;
			SWFFilter = null;
			globalFilter = null;
			matrix = null;
			container = null;
			load.removeEventListener(MouseEvent.CLICK, lod);
			ui.removeChild(load);
			load = null;
			share.removeEventListener(MouseEvent.CLICK, shar);
			ui.removeChild(share);
			share = null;
			clear.removeEventListener(MouseEvent.CLICK, unload);
			ui.removeChild(clear);
			clear = null;
			download.removeEventListener(MouseEvent.CLICK, downloa);
			ui.removeChild(download);
			download = null;
			open.removeEventListener(MouseEvent.CLICK, ope);
			ui.removeChild(open);
			open = null;
			ui.removeChild(status);
			status = null;
			if (pic)
			{
				if (pic.stage)
					container.removeChild(pic);
				pic = null;
			}
			if (swf)
			{
				if (swf.stage)
					container.removeChild(swf);
				swf = null;
			}
			if (bitmapdata)
			{
				bitmapdata.dispose();
				bitmapdata = null;
			}
			if (media)
			{
				if (media.stage)
					container.removeChild(media);
				media = null;
			}
			if (logo)
			{
				logo.stop();
				if (logo.stage)
					container.removeChild(logo);
				logo = null;
			}
			removeChild(container);
			removeChild(ui);
			ui = null;
		}
		
		/*UNLOAD MEDIA*/
		public function unload(e:MouseEvent = null):void
		{
			if (media)
				clearMedia(e);
			status.text = "Media unloaded."
		}
		
		/*LOAD FROM URL*/
		public function loadURL(id:String):void
		{
			if (id.indexOf("http") == -1)
			{
				id = id.substring(5, id.length);
				var m:int = parseInt(id.charAt(0));
				id = id.substring(1, id.length);
				if (m == 1)
					id = "http://senekis.net/swf/gdr/temp/" + id + ".swf";
				else
				{
					var modes:Vector.<String> = new <String>[".png", ".jpg", ".bmp", ".gif"], ext:String = modes[m - 2];
					id = "http://i.imgur.com/" + id + ext;
				}
			}
			status.text = "Loading file from URL...";
			type = id.substring(id.length - 4, id.length);
			urlLoader = new URLLoader();
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, error);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, error);
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, urlFile);
			urlLoader.load(new URLRequest(id));
			title = id.substring(id.lastIndexOf("/"), id.length);
			url = id;
		
			//{ old code: merged into single method to handle any filetype
		/*var t:String=id.substring(id.length-4,id.length);
		   try{
		   if(t==".png"){
		   loader=new Loader();
		   loader.contentLoaderInfo.addEventListener(Event.COMPLETE,urlImage);
		   loader.load(new URLRequest(id),new LoaderContext(true,new ApplicationDomain(null)));
		   title=id.substring(id.lastIndexOf("/"),id.length);
		   }
		   else if(t==".swf"){
		   urlLoader=new URLLoader();
		   urlLoader.dataFormat=URLLoaderDataFormat.BINARY;
		   urlLoader.addEventListener(Event.COMPLETE,urlSWF);
		   urlLoader.load(new URLRequest(id));
		   title=id.substring(id.lastIndexOf("/"),id.length);
		   }
		   url=id;
		   }
		   catch(e:Error){
		   status.text="Error.";
		 }*/
			 //}
		
		}
		
		/*TWEEN*/
		public function handleLabelClick(e:MouseEvent = null):void
		{
			TweenLite.to(this, 1, {x: (isExpanded ? stage.stageWidth : 0)});
			isExpanded = !isExpanded;
		}
	
		//                PUBLIC STATIC     ****************************************************************
	
	/*END OF CLASS   class*/
	} /*package*/
}

//{ EXTRA CLASSES

//{ SHARED OBJECT
import flash.net.SharedObject;

class Save
{
	
	private static const SO:SharedObject = SharedObject.getLocal("senekis.net/save/GDR", "/");
	
	public static const data:Object = SO.data;
	
	public function Save()
	{
	}
	
	public static function create():void
	{
		SO.data.times = [];
		SO.data.times2 = [];
	}
	
	public static function flush():void
	{
		SO.flush();
	}

}

//}

//{ FLEX LOGO

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.BlurFilter;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

class SWFIcon extends Bitmap
{
	
	public function SWFIcon():void
	{
		var holder:Sprite = new Sprite(), data:BitmapData, shape:Shape = new Shape, matrix:Matrix = new Matrix(), S:int = 1, field:TextField = new TextField;
		matrix.createGradientBox(150 * S, 150 * S, 180);
		shape.graphics.beginGradientFill("linear", [0, 0x999999], [1, 1], [0, 255], matrix);
		shape.graphics.drawRect(0, 0, 150 * S, 150 * S);
		holder.addChild(shape);
		field.text = "Fx";
		field.width = 0;
		field.autoSize = "left";
		field.setTextFormat(new TextFormat("_serif", 90 * S, 0));
		field.filters = [new BlurFilter(2, 1, 1)];
		holder.addChild(field);
		field.x = (shape.width - field.width) * .5;
		field.y = (shape.height - field.height) * .5;
		data = new BitmapData(holder.width, holder.height, true, 1);
		data.draw(holder);
		bitmapData = data;
		holder = null;
		field = null;
		shape = null;
		matrix = null;
	}
}

//}

//{ LOGO
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.BevelFilter;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

class Logo extends Sprite
{
	private var V:String = "Beta 1.0", pixels:Vector.<Pixel> = new <Pixel>[], bd:BitmapData, bit:Bitmap, last:int, length:int, time:int, delay:int = 70, h:int;
	
	public function Logo():void
	{
		var G:int = 2, shape:Shape = new Shape(), X:int, Y:int, W:int, H:int, heart:Shape = new Shape(), matrix:Matrix = new Matrix(), S:int = 40 * G, _4:Number = S >> 2, _3:Number = S * .33, _2:Number = S >> 1, _34:Number = S * .75, field:TextField = new TextField();
		matrix.createGradientBox(150 * G, 100 * G, 45);
		shape.graphics.beginGradientFill("linear", [0, 0x999999], [1, 1], [0, 255], matrix);
		shape.graphics.drawRect(0, 0, 200 * G, 70 * G);
		shape.graphics.endFill();
		addChild(shape);
		heart.graphics.beginFill(0xD865D5);
		heart.graphics.moveTo(0, _3);
		heart.graphics.curveTo(0, 0, _3, 0);
		heart.graphics.curveTo(_2, 0, _2, _3);
		heart.graphics.curveTo(_2, 0, _34, 0);
		heart.graphics.curveTo(S, 0, S, _4);
		heart.graphics.curveTo(S, _2, _34, _34);
		heart.graphics.lineTo(_2, S);
		heart.graphics.lineTo(_4, _34);
		heart.graphics.curveTo(0, _2, 0, _4);
		heart.graphics.endFill();
		addChild(heart);
		heart.x = 10 * G;
		heart.y = (height - heart.height) * .5;
		heart.rotation = 350;
		heart.filters = [new BevelFilter(3, heart.rotation, 0xFFFFFFFF, 0.8, 0, 0.0, 4, 14, 1.2, 1)];
		field.defaultTextFormat = new TextFormat("_serif", 16 * G, 0x0, true);
		field.autoSize = "left";
		field.wordWrap = false;
		field.text = "Media Manager\n " + V;
		field.x = heart.x + heart.width + (20 * G);
		addChild(field);
		field.y = (height - field.height) * .5;
		W = width;
		H = height;
		h = H * 4;
		bd = new BitmapData(W, H, true, 0);
		bd.draw(this);
		for (X = 0; X < W; ++X)
		{
			for (Y = 0; Y < H; ++Y)
			{
				pixels[pixels.length] = new Pixel(X, Y, bd.getPixel32(X, Y));
			}
		}
		length = pixels.length * .5;
		bd = new BitmapData(width, height, true, 0);
		bit = new Bitmap(bd);
		filters = [new BevelFilter(3, 45, 0, 1, 0, 1, 5, 10, 3, 3)];
		addChild(bit);
		removeChild(shape);
		removeChild(heart);
		removeChild(field);
		addEventListener(Event.ENTER_FRAME, wait);
	}
	
	private function wait(e:Event):void
	{
		if (++time >= delay)
		{
			removeEventListener(Event.ENTER_FRAME, wait);
			addEventListener(Event.ENTER_FRAME, draw);
		}
	}
	
	private function draw(e:Event):void
	{
		if (last < length)
		{
			var p:Pixel, l:int = (last + h < length ? last + h : last + (length - last));
			while (last < l)
			{
				p = pixels[last];
				bd.setPixel32(p.x, p.y, p.color);
				p = pixels[(length * 2) - (last + 1)];
				bd.setPixel32(p.x, p.y, p.color);
				++last;
			}
		}
		else
			removeEventListener(Event.ENTER_FRAME, draw);
	}
	
	public function stop():void
	{
		removeEventListener(Event.ENTER_FRAME, wait);
		removeEventListener(Event.ENTER_FRAME, draw);
		bd.dispose();
		bd = null;
		removeChild(bit);
		bit = null;
		pixels = null;
	}
	
	public function start():void
	{
		//addEventListener(Event.ENTER_FRAME,wait);
	}
}

//}

//{ PIXEL

import flash.geom.Point;

class Pixel extends Point
{
	public var color:uint;
	
	public function Pixel(X:int, Y:int, C:uint):void
	{
		super(X, Y);
		color = C;
	}
}

//}

//{ TEXT

import flash.text.TextField;
import flash.text.TextFormat;

class Text extends TextField
{
	private var format:TextFormat, Y:int;
	
	public function Text(w:int, _y:int):void
	{
		selectable = false;
		multiline = wordWrap = true;
		width = w;
		Y = _y;
		autoSize = "left";
		defaultTextFormat = format = new TextFormat("_typewriter", 20, 0x666666, true);
	}
	
	public override function set text(t:String):void
	{
		super.text = t;
		y = Y - (numLines * 30);
	}
	
	public function set color(C:uint):void
	{
		format.color = 0xFFFFFF - C;
		defaultTextFormat = format;
		setTextFormat(format);
		text = "Color changed.";
	}

}

//}

//{ BACKGROUND

import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Graphics;

class Container extends Sprite
{
	
	private var border:Shape = new Shape(), w:Number, h:Number;
	
	public function Container(X:int, Y:int, W:int, H:int):void
	{
		x = X;
		y = Y;
		w = W;
		h = H;
		//addChild(border);
	}
	
	/*public function drawBorder(W:int,H:int):void{
	   border.graphics.clear();
	   border.graphics.lineStyle(2,0);
	   border.graphics.drawRect(((width-W)*.5)-1,((height-H)*.5)-1,W+1,H+1);
	   border.graphics.endFill();
	 }*/
	
	public function set background(C:uint):void
	{
		graphics.clear();
		graphics.beginFill(C);
		graphics.drawRect(0, 0, w, h);
		graphics.endFill();
	}
}

//}

//{ BUTTON

import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

class Button extends SimpleButton
{
	
	private var up:Sprite = new Sprite(), down:Sprite = new Sprite();
	
	private const WIDTH:int = 90, HEIGHT:int = 25, ROUND:int = 7, C1:uint = 0x303030, C2:uint = 0x0, C3:uint = 0x6B6B6B;
	
	public function Button(text:String):void
	{
		var matrix:Matrix = new Matrix(), field:TextField = new TextField(), field2:TextField = new TextField();
		field.selectable = field2.selectable = false;
		field2.defaultTextFormat = new TextFormat("_sans", 13, C2, true);
		field.defaultTextFormat = new TextFormat("_sans", 13, C3, true);
		field.width = field2.width = 0;
		field.autoSize = field2.autoSize = "left";
		field.text = field2.text = text;
		down.addChild(field);
		up.addChild(field2);
		field.y = field2.y = (HEIGHT - field.height) * .5;
		field.x = field2.x = (WIDTH - field.width) * .5;
		matrix.createGradientBox(WIDTH, HEIGHT, 45);
		//down.graphics.lineStyle(2,C3);
		down.graphics.beginGradientFill("radial", [C1, C2], [1, 1], [0, 255], matrix);
		down.graphics.drawRoundRect(1, 1, WIDTH, HEIGHT, ROUND);
		down.graphics.endFill();
		up.graphics.beginGradientFill("linear", [C3, C1], [1, 1], [0, 255], matrix);
		up.graphics.drawRoundRect(1, 1, WIDTH, HEIGHT, ROUND);
		up.graphics.endFill();
		upState = up;
		overState = downState = hitTestState = down;
	}

}
//}

//}

