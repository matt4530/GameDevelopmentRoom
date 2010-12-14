package  
{
	import com.greensock.TweenLite;
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.List;
	import fl.controls.TextArea;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import playerio.Client;
	import playerio.Connection;
	import playerio.DatabaseObject;
	import SWFStats.Log;
	import ugLabs.net.Kong;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetaTab extends Sprite
	{
		public var connection:Connection;
		private var client:Client
		
		public var general:List;
		public var des:TextArea;
		public var go:Button;
		public var sug:Button;
		public var feedback:TextArea;
		public var retrieve:Button;
		public var feedbackButton:Button;
		
		public var myLabel:Label
		public var isExpanded:Boolean = false;
		
		public function BetaTab(_client:Client,_connection:Connection) 
		{
			client = _client;
			connection = _connection;
			
			createGeneralSelector();
			createDescriptionField();
			
			addEventListener(Event.ADDED_TO_STAGE, drawBorder);
		}
		
		public function drawBorder(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, drawBorder);
			
			x = stage.stageWidth - 50;
			trace("[BetaTab] drawBorder");
			graphics.beginFill(0x666666, 0.8);
			graphics.lineStyle(1, 0x000000);
			graphics.drawRect(50,0,stage.stageWidth-50,stage.stageHeight);
			graphics.endFill();
			
			graphics.beginFill(0x000000,0.8);
			graphics.drawRect(20,318,30,120);
			graphics.endFill();
			
			var det:Label = new Label();
			det.setStyle("textFormat",new TextFormat("Arial",8,0xFFFFFF,true,null,null,null,null,"center"));
			det.text = "open/\nclose";
			det.x = 20;
			det.y = 410;
			det.height = 30;
			det.width = 30;
			det.useHandCursor = true;
			addChild(det);
			
			
			myLabel = new Label();
			myLabel.setStyle("textFormat",new TextFormat("Arial",15,0xFFFFFF,true,null,null,null,null,"center"));
			myLabel.text = "B\nE\nT\nA\nS";
			myLabel.x = 20;
			myLabel.y = 320;
			myLabel.height = 170;
			myLabel.width = 30;
			addChild(myLabel);
			myLabel.useHandCursor = true;
			myLabel.addEventListener(MouseEvent.CLICK,handleLabelClick);
		}
		public function createDescriptionField():void
		{
			des = new TextArea();
			des.x = general.x + general.width + 10;
			des.y = 25;
			des.width = 200;
			des.height = 150;
			des.editable = false
			addChild(des);
			
			var dL:Label = new Label();
			dL.autoSize = 'center'
			dL.htmlText = '<font size="15" color="#FFFFFF" face="Zekton">Details</font>'
			dL.x = des.x + des.width / 2 - dL.width / 2;
			dL.y = des.y - dL.height - 5;
			addChild(dL);
			
			feedback = new TextArea();
			feedback.x = general.x;
			feedback.y = general.y + general.height + 5;
			feedback.width = 580;
			feedback.height = 360;
			feedback.text = "Feedback Area";
			feedback.editable = false;
			addChild(feedback);
			
			feedbackButton = new Button();
			feedbackButton.label = "Send Feedback";
			feedbackButton.x = des.x + des.width + 5;
			feedbackButton.y = des.y + des.height - feedbackButton.height;
			feedbackButton.useHandCursor = true;
			feedbackButton.addEventListener(MouseEvent.CLICK, directFeedback);
			addChild(feedbackButton);
			
			sug = new Button();
			sug.label = "Add Your Game";
			sug.name = "http://www.kongregate.com/accounts/UnknownGuardian/private_messages?focus=true"
			sug.x = des.x + des.width + 5;
			sug.y = des.y + des.height/2 - sug.height/2;
			sug.useHandCursor = true;
			sug.addEventListener(MouseEvent.CLICK, direct);
			addChild(sug);
		}
		
		public function handleLabelClick(e:MouseEvent = null):void
		{
			var p:Stage = Stage(parent);
			p.addChild(p.removeChild(this));
			
			//if its expanded
			if(isExpanded)
			{
				Log.CustomMetric("Closed", "Beta Tab");
				//shrink off screen
				TweenLite.to(this,1,{x:stage.stageWidth-50});
			}
			else
			{
				Log.CustomMetric("Opened", "Beta Tab");
				//move on screen
				TweenLite.to(this,1,{x:0});
			}
			//change to opposite
			isExpanded = !isExpanded;
		}
		
		public function createGeneralSelector():void
		{
			general = new List();
			general.x = 60;
			general.y = 25
			general.width = 180;
			general.height = 150;
			addChild(general);
			
			var _items:Array = [];	
			
			_items.push(
							{ label:"Unnamed Platformer", 	link:"http://www.box.net/shared/ruu51u12j9", data:"Guide the car to safety, avoiding gru's and drops.", key:"UnnamedPlatformer", dev:"ST3ALTH15" },
							{ label:"Orbital Space Simulator", 	link:"http://megaswf.com/serve/77612/", data:"This is the beta for an up and coming flash game being developed by 2mellow studios. This game will simulate modern space flight to the best of flash's ability.", key:"OrbitalSpaceSimulator", dev:"2mellowstudios" },
							{ label:"SoundShare Beta",  link:"http://www.kongregate.com/games/BobTheCoolGuy/soundshare-beta", data:"The revolutionary new way to communicate on kongregate is here. Now, create and browse audio recordings on kong! Use the simple interface to record a message, listen to others’ messages or save a message as a wav file.", key:"SoundShareBeta",dev:"BobTheCoolGuy" }
						);
			general.dataProvider = new DataProvider(_items);
			general.addEventListener(ListEvent.ITEM_CLICK, clickedGeneral);
			
			var gL:Label = new Label();
			gL.autoSize = 'center'
			gL.htmlText = '<font size="15" color="#FFFFFF" face="Zekton">Game Betas</font>'
			gL.x = general.x + general.width / 2 - gL.width / 2;
			gL.y = general.y - gL.height - 5;
			addChild(gL);
		}
		
		
		
		
		public function clickedGeneral(e:ListEvent):void
		{
			des.text = 	e.item.data;
			
			if (go && go.parent)
			{
				removeChild(go);
			}
			go = new Button();
			go.label = "Play Game";
			go.x = des.x + des.width + 5;
			go.y = des.y;
			go.useHandCursor = true;
			addChild(go);
			go.name = e.item.link;
			go.addEventListener(MouseEvent.CLICK, direct);	
			
			if (Kong._userName == e.item.dev)
			{
				retrieve = new Button();
				retrieve.label = "Get Feedback";
				retrieve.x = des.x + des.width + 5;
				retrieve.y = des.y + des.height - retrieve.height - feedbackButton.height - 5;
				retrieve.useHandCursor = true;
				retrieve.addEventListener(MouseEvent.CLICK, grabFeedback);
				addChild(retrieve);
			}
			else
			{
				if (retrieve != null && retrieve.parent)
				{
					removeChild(retrieve);
				}
			}
			
			
			
			feedback.htmlText = "<b>Feedback for " + e.item.label + "</b>\nPlease fill out this feedback form\nRate: 10 is highest score\nWrite: Comments about the game in the specific area"
						 + "\n\n<b>Ease of Use (Rate 1 - 10):</b> "
						 + "\n<b>How can the game be more intuitive? (Write)</b>"
						 + "\n\n<b>Fun Factor (Rate 1 - 10):</b> "
						 + "\n<b>How can the game be more fun? (Write)</b>"
						 + "\n\n<b>Graphics (Rate 1 - 10):</b> "
						 + "\n<b>How can the graphics be improved? (Write)</b>"
						 + "\n\n<b>Sounds and Music (Rate 1 - 10):</b> "
						 + "\n<b>What would improve the audio? (Write)</b>"
						 + "\n\n<b>Polish and Quality (Rate 1 - 10):</b> "
						 + "\n<b>What would make the game more polished? (Write)</b>"
						 + "\n\n<b>Parting Thoughts To the Developer (Write)</b>";
			
			feedback.editable = true;
			feedbackButton.name = e.item.key;
		}
		
		public function direct(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(e.currentTarget.name));
		}
		
		public function directFeedback(e:MouseEvent):void
		{
			trace(feedback.length);
			if (feedback.length > 7000)
			{
				feedback.htmlText = feedback.htmlText.substr(0, 7000);
			}
			if (feedback.length > 550 && feedback.text.indexOf("Success!") != 0)
			{
				var key:String = feedbackButton.name;
				client.bigDB.loadOrCreate("GameFeedback",key,feedbackObjectLoaded, feedbackObjectFailed);
			}
			
			//lock to prevent edits between load time of object and saving
		}
		public function feedbackObjectLoaded(o:DatabaseObject):void
		{
			if (o.feedbackList == undefined)
			{
				o.feedbackList = [];
			}
			o.feedbackList.push( String(Kong._userName + "\n" + feedback.text));
			o.save(false, false, successInFeedbackSubmitted, feedbackObjectFailed);
			
		}
		
		public function successInFeedbackSubmitted():void
		{
			feedback.htmlText = "Success!\n\n" + feedback.htmlText;
		}
		
		public function feedbackObjectFailed(e:Error = null):void
		{
			feedback.htmlText = "An error has occured. Please PM this feedback to UnknownGuardian\n\n" + feedback.htmlText;
		}
		
		
		
		
		
		//getting feedback back
		public function grabFeedback(e:MouseEvent):void
		{
			var key:String = feedbackButton.name;
			client.bigDB.load("GameFeedback",key,gotFeedback,grabFailed);
		}
		public function gotFeedback(o:DatabaseObject):void
		{
			if (o.feedbackList == undefined)
			{
				feedback.htmlText = "No feedback has been recieved";
			}
			else 
			{
				feedback.htmlText = "";
				for (var i:int = 0; i < o.feedbackList.length; i++)
				{
					if (o.feedbackList[i] != undefined)
					{
						feedback.htmlText += o.feedbackList[i];
						if (i != o.feedbackList.length - 1)
						{
							feedback.htmlText += "\n\n\n\n[-------------]\n\n\n\n"
						}
					}
				}
			}
		}
		public function grabFailed(e:Error = null):void
		{
			feedback.htmlText = "An error has occured. Please PM this feedback to UnknownGuardian\n\n" + feedback.htmlText;
		}
	}

}