package  
{
	/**
	 * ...
	 * @author ...
	 */
	public class Poll 
	{
		public var hasVoted:Vector.<String>;
		public var voteCounts:Vector.<int>;
		public var choices:Vector.<String>;
		public var choiceDescriptions:Vector.<String>;
		public var question:String;
		
		public function Poll(question:String) 
		{
			this.question = question;
			
			hasVoted = new Vector.<String>();
			voteCounts = new Vector.<int>();
			choices = new Vector.<String>();
			choiceDescriptions = new Vector.<String>();
		}
		public function checkVote(message:String,id:String):void
		{
			if (hasVoted.indexOf(id) != -1)
				return;
			var msg:String = message.toLowerCase(); 
               for (var i:int = 0; i < choices.length; i++) 
               { 
                    if (msg.indexOf(choices[i]+" ") == 0 || msg.indexOf(choices[i]+",") == 0 || msg == choices[i]) 
                    {
					voteCounts[i]++;
					hasVoted.push(id);
					break;
				}
			}
		}
		public function getMessage():String
		{
			var msg:String ="Poll Started|/|";
			msg +=			"Question: " + question+"|/|";
			msg += 			"Choices:|/|";
			for (var i:int = 0; i < choices.length; i++)
				msg +=		choices[i] + " - " + choiceDescriptions[i] + "|/|";
			return msg;
		}
		public function getResult():String
		{
			//Find top vote, including ties
			var maxPos:int = 0;
			var ties:Vector.<int> = new Vector.<int>();
			for (var i:int = 1; i < voteCounts.length; i++)
			{
				if (voteCounts[i] > voteCounts[maxPos])
				{
					maxPos = i;
					ties.length = 0;
				}
				else if (voteCounts[i] == voteCounts[maxPos])
				{
					ties.push(i);
				}
			}
			//Format results
			var msg:String = "Poll Ended|/|";
			msg +=			"Question: " + question + "|/|";
			if(ties.length == 0)
				msg += 		"The winner is: " + choices[maxPos] + " (" + choiceDescriptions[maxPos] + ") with "+voteCounts[maxPos]+" vote(s)|/|";
			else
			{
				msg +=		"There was a " + (ties.length + 1) + "-way tie between " + choices[maxPos] + " (" + choiceDescriptions[maxPos] + ")";
				for (i = 0; i < ties.length; i++)
				{
					if(i == choices.length -1)
						msg += " and " + choices[ties[i]] + " (" + choiceDescriptions[ties[i]] + ")";
					else
						msg += ", " + choices[ties[i]] + " (" + choiceDescriptions[ties[i]] + ")";
				}
				msg += " with "+voteCounts[i]+" votes|/|"
			}
			return msg;
		}
		public static function parsePoll(command:String):Poll
		{
			var split:Array = command.split(/\/vote\s+"(.+?)"\s+/);
			if (split.length != 3)
				return null;
				
			var question:String = split[1];
			var poll:Poll = new Poll(question);
			
			var choiceString:String = split[2];
			
			var re:RegExp = /-(\w+)\s+"(.+?)"\s*/g;
			var result:Array = re.exec(choiceString);
			
			if (result == null)
				return null;
				
			while(result)
			{
				poll.choices.push(result[1].toLowerCase());
				poll.choiceDescriptions.push(result[2]);
				poll.voteCounts.push(0);
				result = re.exec(choiceString);
			}
			return poll;
		}
	}

}