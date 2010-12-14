package  
{
	import flash.display.Stage;
	import playerio.Client;
	import playerio.Connection;
	import playerio.DatabaseObject;
	import playerio.PlayerIO;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class TimeCorrection
	{
		public var oldTime:Number = 0;
		public var _client:Client
		
		public var n:String = "BraydenBlack";
		public var addAmount:Number = 0;
		
		public function TimeCorrection(_stage:Stage) 
		{
			PlayerIO.connect(
									_stage,								//Referance to stage
									"chat-pfplo6j07kwdjfcqq9bdg",		//Game id (Get your own at playerio.com. 1: Create user, 2:Goto admin pannel, 3:Create game, 4: Copy game id inside the "")
									"public",							//Connection id, default is public
									n,//Username
									"",									//User auth. Can be left blank if authentication is disabled on connection
									handleConnect,						//Function executed on successful connect
									handleError							//Function executed if we recive an error
								);
		}
		public function handleConnect(client:Client):void
		{
			_client = client;
			//_client.bigDB.loadMyPlayerObject(addTime, addTimeError);
			_client.bigDB.load("PlayerObjects", n, addTime, addTimeError);
			trace("Loading PlayerObject for " + n);
		}
		public function handleError(e:Error):void
		{
			trace("Error Loading PlayerObject for " + n);
		}
		
		public function addTime(o:DatabaseObject):void
		{
			trace("Loaded old time from database");
			if(o.Data != null)
			{
				var t:int = o.Data.Time;
				t+=addAmount;
				o.Data = { Time:t };
				trace("Added");
			}
			else
			{
				trace("Adding Failed");
			}
			o.save();
			_client.bigDB.loadMyPlayerObject(check, checkError);
		}
		public function addTimeError(e:Error):void
		{
			trace("could not load old time from database");
		}
		
		public function check(o:DatabaseObject):void
		{
			trace(o.Data.Time);
		}
		public function checkError(o:DatabaseObject):void
		{
			trace("Error in Check");
		}
	}

}