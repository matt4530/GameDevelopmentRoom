package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class TabLinks extends Sprite
	{
		
		public function TabLinks() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			graphics.beginFill(0x000000,0.7);
			graphics.drawRect(0,5,stage.stageWidth-33,stage.stageHeight);
			graphics.endFill();
			
			var cou:Font = new CourierCode();
			
			myText = new TextField();
			myText.defaultTextFormat = new TextFormat(cou.fontName);
			myText.background = true;
			myText.x = 5;
			myText.y = 10;
			myText.width = stage.stageWidth - 57;
			myText.height = stage.stageHeight - 20 - 23 - 15; //23 is for buttons, 15 for scroll bar
			myText.wordWrap = false;
			myText.multiline = true;
			myText.useRichTextClipboard = true;
			myText.type = "input";
			addChild(myText);
			
			verticalScroll = new UIScrollBar();
			verticalScroll.scrollTarget = myText;
			verticalScroll.x = myText.x + myText.width + 1;
			verticalScroll.y = myText.y;
			verticalScroll.height = myText.height;
			addChild(verticalScroll);
			
			horizontalScroll = new UIScrollBar();
			horizontalScroll.direction = "horizontal";
			horizontalScroll.scrollTarget = myText;
			horizontalScroll.x = myText.x;
			horizontalScroll.y = myText.y + myText.height + 1;
			horizontalScroll.width = myText.width;
			addChild(horizontalScroll);
			
			
			
			loadField = new TextArea();
			loadField.x = 5;
			loadField.y = stage.stageHeight - 31;
			loadField.width = 150;
			loadField.height = 23;
			loadField.text = "";
			addChild(loadField);
			
			loadButton = new Button();
			loadButton.label = "Load Code";
			loadButton.x = 160;
			loadButton.y = stage.stageHeight - 31;
			addChild(loadButton);
			
			loadButton.addEventListener(MouseEvent.CLICK,loadCode);
			
			postButton = new Button();
			postButton.label = "Post Code";
			postButton.x = loadButton.x + loadButton.width + 5;
			postButton.y = stage.stageHeight - 31;
			addChild(postButton);
			
			postButton.addEventListener(MouseEvent.CLICK,postCode);
			
			clearButton = new Button();
			clearButton.label = "Clear Code";
			clearButton.x = postButton.x + postButton.width + 5;
			clearButton.y = stage.stageHeight - 31;
			addChild(clearButton);
			
			clearButton.addEventListener(MouseEvent.CLICK,clearCode);
			
			
			highlightSyntaxButton = new Button();
			highlightSyntaxButton.label = "Highlight Code";
			highlightSyntaxButton.x = clearButton.x + clearButton.width + 5;
			highlightSyntaxButton.y = stage.stageHeight - 31;
			addChild(highlightSyntaxButton);
			
			highlightSyntaxButton.addEventListener(MouseEvent.CLICK, HighlightSyntax);
			
			preventTab();
			
			DefaultFormat = new TextFormat(null,null,0x000000);
			var cour:Font = new CourierCode();
			DefaultFormat.font = cour.fontName;
		}
		
	}

}