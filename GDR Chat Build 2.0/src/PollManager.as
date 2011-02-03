package  
{
	import com.bit101.components.ComboBox;
	import com.bit101.components.Component;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.RadioButton;
	import com.bit101.components.Style;
	import com.bit101.components.TextArea;
	import com.bit101.components.Window;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import playerio.Message;
	import ugLabs.net.Kong;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class PollManager extends Sprite
	{
		//question create specific
		public var creatorWindow:Window;
		public var typeLabel:Label;
		public var typeList:ComboBox;
		public var hashLabel:Label;
		public var hashInput:InputText;
		public var questionInput:TextArea;
		public var submitButton:PushButton;
		
		//question type specific
		public var choiceA:RadioButton;
		public var choiceAInput:InputText
		public var choiceB:RadioButton;
		public var choiceBInput:InputText
		public var choiceC:RadioButton;
		public var choiceCInput:InputText
		public var choiceText:TextArea;
		
		public var isPollCreator:Boolean;
		public var isExpanded:Boolean = false;
		public var pollData:Object;
		
		public function PollManager(isCreator:Boolean) 
		{
			isPollCreator = isCreator;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.showDefaultContextMenu = false;
			stage.stageFocusRect = false;
			
			if (isPollCreator)
			{
				creatorWindow = new Window();
				creatorWindow.width = 300;
				creatorWindow.height = 300;
				creatorWindow.draggable = true;
				creatorWindow.hasMinimizeButton = true;
				creatorWindow.hasCloseButton = true;
				creatorWindow.title = "Poll Creator";
				addChild(creatorWindow);
				creatorWindow.addEventListener(Event.CLOSE, closeWindow);
				
				typeLabel = new Label(creatorWindow.content, 5, 5, "Type: ");
				
				typeList = new ComboBox(creatorWindow.content, typeLabel.x + typeLabel.width, typeLabel.y, "Choose: ", ["Yes/No", "ABC", "Text"]);
				typeList.addEventListener(Event.SELECT, changePollType);
				
				hashLabel = new Label(creatorWindow.content, 5, typeLabel.y + typeLabel.height + 5 , "Poll Identifier: ");
				hashInput = new InputText(creatorWindow.content, hashLabel.x + hashLabel.width, hashLabel.y, "Enter Short Poll Name");
				hashInput.width = 295-hashInput.x;
				hashInput.restrict = "a-z A-Z 0-9";
				
				questionInput = new TextArea(creatorWindow.content, 5, hashLabel.y + hashLabel.height + 5, "Enter Your Poll Question");
				questionInput.width = 290;
				questionInput.height = 75;
				questionInput.editable = true;
				
				
				
				choiceA = new RadioButton(creatorWindow.content, 5, questionInput.y + questionInput.height + 8, "Choice A");
				choiceAInput = new InputText(creatorWindow.content, 195, choiceA.y, "Enter Option Description", changeRadioName);
				choiceB = new RadioButton(creatorWindow.content, 5, choiceA.y + choiceA.height + 8, "Choice B");
				choiceBInput = new InputText(creatorWindow.content, 195, choiceB.y, "Enter Option Description", changeRadioName);
				choiceC = new RadioButton(creatorWindow.content, 5, choiceB.y + choiceB.height + 8, "Choice C");
				choiceCInput = new InputText(creatorWindow.content, 195, choiceC.y, "Enter Option Description", changeRadioName);
				choiceText = new TextArea(creatorWindow.content, 5, choiceC.y + choiceC.height + 8, "Question Response Will Go Here");
				choiceText.width = 290;
				choiceText.height = 85;
				choiceA.enabled = false;
				choiceB.enabled = false;
				choiceC.enabled = false;
				choiceAInput.enabled = false;
				choiceBInput.enabled = false;
				choiceCInput.enabled = false;
				choiceText.enabled = false;
				
				submitButton = new PushButton(creatorWindow.content, 195, 5, "Submit Poll",submitPollOrResponse);
			}
			else
			{
				creatorWindow = new Window();
				creatorWindow.width = 300;
				creatorWindow.height = 300;
				creatorWindow.draggable = true;
				creatorWindow.hasMinimizeButton = true;
				creatorWindow.hasCloseButton = true;
				creatorWindow.title = pollData.Title;
				creatorWindow.shadow = false;
				addChild(creatorWindow);
				creatorWindow.addEventListener(Event.CLOSE, closeWindow);
				
				questionInput = new TextArea(creatorWindow.content, 5, 5, pollData.Question);
				questionInput.width = 290;
				questionInput.height = 75;
				questionInput.editable = false;
				
				if (pollData.Type == "Text")
				{
					creatorWindow.height = 300;
					
					choiceText = new TextArea(creatorWindow.content, 5, questionInput.y + questionInput.height + 8, "Your Response Goes Here...");
					choiceText.width = 290;
					choiceText.height = 160;
					submitButton = new PushButton(creatorWindow.content, 5, 255, "Submit Response",submitPollOrResponse);
				}
				else if (pollData.Type == "ABC")
				{
					creatorWindow.height = 185;
					
					choiceA = new RadioButton(creatorWindow.content, 5, questionInput.y + questionInput.height + 8, "Choice A");
					choiceB = new RadioButton(creatorWindow.content, 5, choiceA.y + choiceA.height + 8, "Choice B");
					choiceC = new RadioButton(creatorWindow.content, 5, choiceB.y + choiceB.height + 8, "Choice C");
					submitButton = new PushButton(creatorWindow.content, 5, 140, "Submit Response",submitPollOrResponse);
				}
				else if (pollData.Type == "Y/N")
				{
					creatorWindow.height = 165;
					
					choiceA = new RadioButton(creatorWindow.content, 5, questionInput.y + questionInput.height + 8, "Yes");
					choiceB = new RadioButton(creatorWindow.content, 5, choiceA.y + choiceA.height + 8, "No");
					submitButton = new PushButton(creatorWindow.content, 5, 120, "Submit Response",submitPollOrResponse);
				}
			}
		}
		
		public function closeWindow(e:Event):void
		{
			handleLabelClick();
		}
		
		public function changePollType(e:Event):void
		{
			choiceA.enabled = false;
			choiceB.enabled = false;
			choiceC.enabled = false;
			choiceAInput.enabled = false;
			choiceBInput.enabled = false;
			choiceCInput.enabled = false;
			choiceText.enabled = false;
			if (typeList.selectedItem == "Yes/No")
			{
				choiceA.label = "Yes";
				choiceA.enabled = true;
				choiceB.label = "No";
				choiceB.enabled = true;
			}
			else if (typeList.selectedItem == "ABC")
			{
				choiceA.label =  "Choice A";
				choiceA.enabled = true;
				choiceAInput = new InputText(creatorWindow.content, 195, choiceA.y, "Enter Option Description", changeRadioName);
				choiceAInput.enabled = true;
				choiceB.label = "Choice B";
				choiceB.enabled = true;
				choiceBInput = new InputText(creatorWindow.content, 195, choiceB.y, "Enter Option Description", changeRadioName);
				choiceBInput.enabled = true;
				choiceC.label = "Choice C";
				choiceC.enabled = true;
				choiceCInput = new InputText(creatorWindow.content, 195, choiceC.y, "Enter Option Description", changeRadioName);
				choiceCInput.enabled = true;
			}
			else if (typeList.selectedItem == "Text")
			{
				choiceText.enabled = true;
			}
			/*
			if (typeList.selectedItem == "Yes/No")
			{
				choiceA = new RadioButton(creatorWindow.content, 5, questionInput.y + questionInput.height + 8, "Yes");
				choiceB = new RadioButton(creatorWindow.content, 5, choiceA.y + choiceA.height + 8, "No");
			}
			else if (typeList.selectedItem == "ABC")
			{
				choiceA = new RadioButton(creatorWindow.content, 5, questionInput.y + questionInput.height + 8, "Choice A");
				choiceAInput = new InputText(creatorWindow.content, 195, choiceA.y, "Enter Option Description", changeRadioName);
				choiceB = new RadioButton(creatorWindow.content, 5, choiceA.y + choiceA.height + 8, "Choice B");
				choiceBInput = new InputText(creatorWindow.content, 195, choiceB.y, "Enter Option Description", changeRadioName);
				choiceC = new RadioButton(creatorWindow.content, 5, choiceB.y + choiceB.height + 8, "Choice C");
				choiceCInput = new InputText(creatorWindow.content, 195, choiceC.y, "Enter Option Description", changeRadioName);
			}
			else if (typeList.selectedItem == "Text")
			{
				choiceText = new TextArea(creatorWindow.content, 5, choiceC.y + choiceC.height + 5, "Question Response Will Go Here");
			}
			*/
		}
		
		public function changeRadioName(e:Event):void
		{
			if (e.currentTarget == choiceAInput)
			{
				choiceA.label = choiceAInput.text;
			}
			else if (e.currentTarget == choiceBInput)
			{
				choiceB.label = choiceBInput.text;
			}
			else if (e.currentTarget == choiceCInput)
			{
				choiceC.label = choiceCInput.text;
			}
		}
		
		public function submitPollOrResponse(e:Event):void
		{
			var serialize:String;
			if (!isPollCreator)
			{
				//var serialize:String = Kong.userName + "|";
				serialize = "UG" + "|";
				if (pollData.Type == "Text")
				{
					serialize = choiceText.text;
				}
				else if (pollData.Type == "ABC")
				{
					serialize = choiceA.selected ? "A" : choiceB.selected ? "B" : choiceC.selected ? "C" : "ERROR";
				}
				else if (pollData.Type == "Y/N")
				{
					serialize = choiceA.selected ? "Y" : choiceB.selected ? "N" : "ERROR";
				}
				Main.connection.send("PollResponse", [pollData.id, serialize]);
			}
			else
			{
				serialize = hashInput + "|" + typeList.selectedItem + "|" + questionInput.text;
				if (pollData.Type == "ABC")
				{
					serialize += choiceA.label + "|" + choiceB.label + "|" + choiceC.label;
				}
				Main.connection.send("PollCreate", serialize);
			}
			
		}
		
		public function handleLabelClick():void
		{
			if (isExpanded)
			{
				//creatorWindow.x = 100;
				TweenLite.to(creatorWindow,1,{x:stage.stageWidth, y:125});
			}
			else
			{
				//creatorWindow.x = 200;
				//x = (stage.stageWidth + width) / 2;
				//y = (stage.stageHeight + height) / 2;
				TweenLite.to(creatorWindow,1,{x:175, y:125});
			}
			//change to opposite
			isExpanded = !isExpanded;
			trace("[PollManager] isExpanded =", isExpanded, " x =", x);
		}
			
	}

}

//var p:PollManager = new PollManager(true);
//p.pollData = { Title:"Cake", Type:"Y/N", Question:"What is Cake's true Name" };
//addChild(p);