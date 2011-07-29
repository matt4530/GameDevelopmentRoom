package {
	
	public class ImgurResponse {
		
		public var image_hash:String;
		public var delete_hash:String;
		public var original_image:String;
		public var large_thumbnail:String;
		public var small_thumbnail:String;
		public var imgur_page:String;
		public var delete_page:String;
		
		public var message:String;
		
		public var error_code:String;
		public var error_msg:String;
		
		public var images:XMLList;

		public static function fromObject(value:Object):ImgurResponse {
			var rsp:ImgurResponse = new ImgurResponse();
			
			// only set when updloading images
			rsp.image_hash = value.image_hash ? rsp.image_hash = value.image_hash : rsp.image_hash = null;
			rsp.delete_hash = value.delete_hash ? rsp.delete_hash = value.delete_hash : rsp.delete_hash = null;
			rsp.original_image = value.original_image ? rsp.original_image = value.original_image : rsp.original_image = null;
			rsp.large_thumbnail = value.large_thumbnail ? rsp.large_thumbnail = value.large_thumbnail : rsp.large_thumbnail = null;
			rsp.small_thumbnail = value.small_thumbnail ? rsp.small_thumbnail = value.small_thumbnail : rsp.small_thumbnail = null;
			rsp.imgur_page = value.imgur_page ? rsp.imgur_page = value.imgur_page : rsp.imgur_page = null;
			rsp.delete_page = value.delete_page ? rsp.delete_page = value.delete_page : rsp.delete_page = null;
			
			// only set when deleting images
			rsp.message = value.message ? rsp.message = value.message : rsp.message = null;
			
			// only set when errors occcur 
			rsp.error_code = value.error_code ? rsp.error_code = value.error_code : rsp.error_code = null;
			rsp.error_code = value.error_msg ? rsp.error_msg = value.error_msg : rsp.error_msg = null;
			
			// only set when requesting "gallery"
			// @see Imgur			
			rsp.images = value.images ? rsp.images = new XMLList(value.image) : rsp.images = null;
			
			
			return rsp;
		}
	}

}