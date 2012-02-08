package  
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import ugLabs.net.Kong;
	import ugLabs.net.SaveSystem;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class ProfilePanel extends UserProfilePanel 
	{
		
		public function ProfilePanel() 
		{
			checkMuted.addEventListener(MouseEvent.CLICK, checkData);
			checkBeep.addEventListener(MouseEvent.CLICK, checkData);
			checkBold.addEventListener(MouseEvent.CLICK, checkData);
			nicknames.addEventListener(TextEvent.TEXT_INPUT, checkData);
		}
		
		private function checkData(e:Event):void 
		{
			if (nameField.text == "User Panel") return;
			var playerName:String = nameField.text.substr(9);
			var nickSection:String = "";
			if (nicknames.enabled && nicknames.text != "Nicknames: Separate by space")
				nickSection = nicknames.text;
			var genString:String = nickSection + "|" + checkMuted.selected.toString() + "|" + checkBeep.selected.toString() + "|" + checkBold.selected;
			SaveSystem.getCurrentSlot().write("UserInfo_" + playerName, genString);
			//KongChat.log("[debug] [ProfilePanel] [checkdata] SaveSystem Write: " + genString + " @ " + playerName);
			
			Main.playerList.getPlayerFromName(playerName).getSavedData();
		}
		
		public function changeProfile(n:String):void
		{
			KongChat.log("[debug] " + n + " profile loaded" );
			if (SaveSystem.getCurrentSlot() == null)
			{
				SaveSystem.createOrLoadSlots(["GDR_SaveSystem"]);
				SaveSystem.openSlot("GDR_SaveSystem");
			}
			var data:String = SaveSystem.getCurrentSlot().readString("UserInfo_" + n);
			if (data != null && data.length > 0)
			{
				var sub:Array = data.split("|");
				checkMuted.selected = sub[1] == "true";
				checkBeep.selected = sub[2] == "true";
				checkBold.selected = sub[3] == "true";
			}
			else
			{
				checkMuted.selected = false;
				checkBeep.selected = false;
				checkBold.selected = false;
			}
			checkMuted.enabled = true;
			checkBeep.enabled = true;
			checkBold.enabled = true;
			
			if (Main.chatDisplay.isUserAdmin(Kong.userName)/* || Main.chatDisplay.isUserMod(Kong.userName)*/)
			{
				silenceMenu.enabled = true;
				banMenu.enabled = true;
				silenceBanButton.enabled = true;
			}
			else
			{
				silenceMenu.enabled = false;
				banMenu.enabled = false;
				silenceBanButton.enabled = false;
			}
			
			if (n == Kong.userName)
			{
				nicknames.enabled = true;
				checkMuted.enabled = false;
				checkMuted.selected = false;
				checkBeep.enabled = false;
				checkBeep.selected = false;
				checkBold.enabled= false;
				checkBold.selected = false;
				if (data != null)
				{
					var sub2:Array = data.split("|");
					nicknames.text = sub2[0];
				}
			}
			else
			{
				nicknames.enabled = false;
			}
			nameField.text = "Profile: " + n;
		}
		
	}

}