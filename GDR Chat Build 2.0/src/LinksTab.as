package  
{
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
	import flash.events.TextEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class LinksTab extends Sprite
	{
		public var general:List;
		public var specific:List
		public var des:TextArea;
		public var go:Button;
		public var sug:Button;
		public var logo:TextField
		public var GOTW:TextField;
		
		public var myLabel:Label
		public var isExpanded:Boolean = false;
		
		
		
		public function LinksTab() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			drawBorder();
			createGeneralSelector();
			createSpecificSelector();
			createDescriptionField();
		}
		public function drawBorder():void
		{			
			graphics.beginFill(0x000000,0.7);
			graphics.drawRect(0,5,stage.stageWidth-33,stage.stageHeight);
			graphics.endFill();			
		}
		
		public function handleLabelClick(e:MouseEvent = null):void
		{
			if (isExpanded)
			{
				TweenLite.to(this,1,{x:stage.stageWidth});
			}
			else
			{
				TweenLite.to(this,1,{x:0});
			}
			//change to opposite
			isExpanded = !isExpanded;
		}
		
		public function createGeneralSelector():void
		{
			general = new List();
			general.x = 10;
			general.y = 50
			general.width = 180;
			general.height = 300;
			addChild(general);
			
			var _items:Array = [];	
			
			_items.push({label:"Actionscript", 	sub:[	{ label:"AS3 Shootorials", 				link:"http://www.kongregate.com/accounts/Moly", 									data:"Start easy in AS3 with this tutorial series ported to AS3 by Moly (recommended)" },
														{ label:"AS2 Shootorials", 				link:"http://www.kongregate.com/labs", 												data:"Get started in making flash games, using easy to learn AS2" },
														{ label:"Adobe Tutorials",				link:"http://www.adobe.com/support/flash/tutorial_index.html", 						data:"Get a feel of Flash and actionscript right from the creators" },
														{ label:"AS3 Avoider Tutorial", 		link:"http://gamedev.michaeljameswilliams.com/as3-avoider-game-tutorial-base/",		data:"Advance in to deeper parts of AS3 by making a complete Avoider game (recommended)" },
														{ label:"Kirupa Tutorials", 			link:"http://www.kirupa.com/developer/flash/index.htm",								data:"A very wide variety of Flash concepts and tutorials (recommended)" },
														{ label:"GotoAndLearn()", 				link:"http://gotoandlearn.com/",													data:"Video and text tutorials on intermediate Flash concepts (recommended)" },
														{ label:"Republic of Code",				link:"http://www.republicofcode.com/tutorials/",									data:"AS3 and AS2 tutorials, with a wide variety and a very easy learning curve (recommended)" },
														{ label:"Senocular",					link:"http://www.senocular.com/",													data:"Tutorials, extensions, and source files for ActionScript, Flash, and other Adobe products (recommended)" },
														{ label:"ASgamer Tutorials",			link:"http://asgamer.com/"	,														data:"A good series on creating a shooter in AS3" }
													]
						});
			_items.push( { label:"Flash IDEs", 		sub:[	{ label:"FlashDevelop",				link:"http://www.flashdevelop.org/",			data:"Free. Code completion, syntax highlighting, and everything else a programmer wished for. (recommended)" },
															{ label:"Adobe Flash Pro",			link:"http://www.adobe.com/products/flash/",	data:"$699. Adobe® Flash® Professional software is the industry standard for interactive authoring and delivery of immersive experiences that present consistently across personal computers, mobile devices, and screens of virtually any size and resolution" },
															{ label:"Eclipse",					link:"http://www.eclipse.org/",					data:"Free. Eclipse is an open source community, whose projects are focused on building an open development platform comprised of extensible frameworks, tools and runtimes for building, deploying and managing software across the lifecycle." },
															{ label:"FDT",						link:"http://www.fdt.powerflasher.com/",		data:"$129-$699. FDT enables you to focus on what you love best: coding. It offers a non-intrusive, intuitive way to help you write, debug, test, and refactor your code." },
															{ label:"Flash Minibuilder",		link:"http://code.google.com/p/minibuilder/",	data:"Free. Online AS3 IDE, edit (with code assist) and compile SWF. Runs in the browser. Note: not recommended at all to beginners" }
														]
						});
			
			_items.push( { label:"Flash Blogs", 	sub:[	{ label:"Emanuele Feronato",		link:"http://www.emanueleferonato.com/",		data:"Lots of AS3 and AS2 game tutorials and advice (recommended)" },
															{ label:"xDragonx10",				link:"http://kaitol.com/",						data:"A very interesting and detailed blog about flash development and how to get rich (recommended)" }
														]
						});
			
			
			_items.push( { label:"Game Engines",	sub:[	{ label:"Flixel",					link:"http://flixel.org/", 									data:"A completely free collection of Actionscript 3 files that helps organize, automate, and optimize Flash games; an object-oriented framework that lets anyone create original and complex games with thousands of objects on screen in just a few hours (recommended)" },
															{ label:"FlashPunk",				link:"http://flashpunk.net/",								data:"FlashPunk is a free ActionScript 3 library designed for developing 2D Flash games. It provides you with a fast, clean framework to prototype and develop your games in. This means that most of the dirty work (timestep, animation, input, and collision to name a few) is already coded for you and ready to go, giving you more time and energy to concentrate on the design and testing of your game (recommended)" },
															{ label:"PushButton",				link:"http://pushbuttonengine.com/", 						data:"Open Source Flash game engine and framework that's designed for a new generation of games. PushButton Engine makes it easy to bring together great existing libraries and components for building Flash games" },
															{ label:"PixelBlitz",					link:"http://www.photonstorm.com/pixelblitz-engine",		data:"PixelBlitz Engine is a game framework for Actionscript3 created by Norm Soule and Richard Davey. It provides quick and easy access to game-related features such as sprite handling, pixel blitting, collision detection, bitmap fonts, game related math, keyboard and mouse handling, parallax scrolling, filter effects and more (recommended)" }
														]
						});
			_items.push( { label:"Game Dev Resources",	sub:[	{ label:"FlashKit",				link:"http://www.flashkit.com/",										data:"Sound, code, everything for flash. Lots of licensed resources, available for free" },
																{ label:"Blackbone's Toolbox",	link:"http://www.kongregate.com/forums/4-programming/topics/44720", 	data:"This thread was made to put many resources for developers of all skill to use and appreciate. In this thread there will be listed resources by they type that they are e.g Art, Music, etc" },
																{ label:"SFXR-Audio Tool",		link:"http://www.drpetter.se/project_sfxr.html",						data:"A free downloadable program which makes it easy to create sound effects (recommended)" }
															]
						});
			_items.push( { label:"Kongregate",	sub:[	{ label:"Developer Forums",			link:"http://www.kongregate.com/forums/developers", 						data:"Consists of the Programming, Collaboration, and Kongregate Labs forum"},
														{ label:"Programming Forums",		link:"http://www.kongregate.com/forums/4-programming", 						data:"The programming forum to get detailed programming help"},
														{ label:"AS3 API",					link:"http://www.kongregate.com/developer_center/docs/as3-api", 			data:"The Kongregate API for Actionscript 3.0"},
														{ label:"AS2 API",					link:"http://www.kongregate.com/developer_center/docs/as2-api", 			data:"The Kongregate API for Actionscript 2.0"},
														{ label:"Developer Center",			link:"http://www.kongregate.com/developer_center", 							data:"The Kongregate Developer center, with links to uploading, APIs, revenue, and developer resources"},
														{ label:"Upload Game",				link:"http://www.kongregate.com/games/new", 								data:"Upload your new game"},
														{ label:"Contests",					link:"http://www.kongregate.com/contests", 									data:"Take a peek at the montly and weekly contests"}
													]
						});
			_items.push( { label:"User Sites",	sub:[	{ label:"BobTheCoolGuy", 			link:"http://bobthecoolguy.wordpress.com/",									data:"Musings and thoughts on programming and more."},
														{ label:"RTL_Shadow",				link:"http://www.aftershockstudioshq.com", 							data:"Aftershock Studio's main site, stuffed with exclusive content and great tutorials! AS3 and AS2 game tutorials, games, and exclusive content."},
														{ label:"Sanchex",					link:"http://www.highupstudio.com/", 										data:"we are currently developing flash and iPone games. In a few months, we will expand our portfolio and offer many great and addicting games."},
														{ label:"skyboy",					link:"http://www.skyript.com/", 											data:"AS3, in-depth, hard-core scripting. Not for the weak minded." },
														{ label:"ST3ALTH15", 				link:"http://randomprogrammerking.wordpress.com/",							data:"A programming blog aimed toward people trying to learn OOP and AS3."},
														{ label:"UnknownGuardian",			link:"http://profusiongames.com/", 											data:"News on upcoming games, team updates, and game tutorials."}
													]
						});
			
			/*
			_items.push("Thread: HOW TO MAKE GAMES@http://www.kongregate.com/forums/4-programming/topics/89-faq-making-games-read-first");
			_items.push("Kongregate API@http://www.kongregate.com/developer_center/docs/kongregate-api");
			_items.push("Programming Forum@http://www.kongregate.com/forums/4-programming");
			_items.push("Getting Started with FlashDevelop@http://www.kongregate.com/games/Paltar/flashdevelop-tutorial");
			_items.push("Make An Avoider - MJW@http://gamedev.michaeljameswilliams.com/as3-avoider-game-tutorial-base/");
			_items.push("Emanuele Feronato Flash Blog@http://www.emanueleferonato.com/");
			_items.push("FlashGameLicense.com@http://www.flashgamelicense.com/developer_home.php");
			_items.push("Shootorials for AS2 by Kongregate@http://www.kongregate.com/labs");
			_items.push("Shootorials for AS3 by Moly@http://www.kongregate.com/accounts/Moly");
			_items.push("Tutorial Games on Kongregate@http://www.kongregate.com/tutorials-games");
			_items.push("Official Suggestions Thread@http://www.kongregate.com/forums/4-programming/topics/93529-game-development-room-gdr");
			_items.push("Made By Profusion Dev Team@http://kdugames.wordpress.com/");
			*/
			
			general.dataProvider = new DataProvider(_items);
			general.addEventListener(ListEvent.ITEM_CLICK, clickedGeneral);
			
			
			var gL:Label = new Label();
			gL.autoSize = 'center'
			gL.htmlText = '<font size="15" color="#FFFFFF" face="Zekton">General Categories</font>'
			gL.x = general.x + general.width / 2 - gL.width / 2;
			gL.y = general.y - gL.height - 5;
			addChild(gL);
			
			sug = new Button();
			sug.label = "Suggest More Resources";
			sug.name = "http://www.kongregate.com/accounts/UnknownGuardian/private_messages?focus=true"
			sug.x = general.x;
			sug.y = general.y + general.height + 5;
			sug.width = 150;
			sug.useHandCursor = true;
			sug.addEventListener(MouseEvent.CLICK, direct);
			addChild(sug);
			
			logo = new TextField();
			logo.autoSize = 'center'
			logo.htmlText = '<font size="20" face="Zekton"><a href=\"event:Profusion"><font color="#0098FF">Pro</font><font color="#FFFFFF">fusion</font> <font color="#FFFFFF">Dev Team</font></a>';
			logo.selectable = false;
			logo.addEventListener(TextEvent.LINK, textLink);
			logo.x = 10;
			logo.y = stage.stageHeight - logo.height;
			logo.name = "Logo";
			addChild(logo);
			
			/*
			GOTW = new TextField();
			GOTW.autoSize = 'center'
			GOTW.defaultTextFormat = new TextFormat("Zekton", 20, 0xFFFFFF, null, null, null, null, null, 'center');
			GOTW.htmlText = "The winner of the GiTD #4 was saybox with \n" + '<a href=\"event:Profusion"><bold><font color="#000000">Coin Collector</font></bold></a>\n<font size="10" color="#000000">Explosion at the bank! Collect the coins but watch out for flying bricks.</font>'; //http://www.kongregate.com/games/ST3ALTH15/entrigo //"This space is reserved for Game of the Week winner,\nif they so choose to promote their game."
			GOTW.border = true;
			GOTW.selectable = false;
			GOTW.x = (stage.stageWidth - GOTW.width)/2 + 20;
			GOTW.y = (stage.stageHeight - GOTW.height) / 2 + 175;
			GOTW.addEventListener(TextEvent.LINK, gitdLink);
			GOTW.name = "GOTW";
			addChild(GOTW);
			*/
		}
		
		public function createSpecificSelector():void
		{
			specific = new List();
			specific.x = general.x + general.width + 10;
			specific.y = 50
			specific.width = 180;
			specific.height = 300;
			addChild(specific);
			specific.addEventListener(ListEvent.ITEM_CLICK, clickedSpecific);
			
			
			var sL:Label = new Label();
			sL.autoSize = 'center'
			sL.htmlText = '<font size="15" color="#FFFFFF" face="Zekton">Specific Categories</font>'
			sL.x = specific.x + specific.width / 2 - sL.width / 2;
			sL.y = specific.y - sL.height - 5;
			addChild(sL);
		}
		public function createDescriptionField():void
		{
			des = new TextArea();
			des.x = specific.x + specific.width + 10;
			des.y = 50;
			des.width = 200;
			des.height = 300;
			des.editable = false
			
			addChild(des);
			
			var dL:Label = new Label();
			dL.autoSize = 'center'
			dL.htmlText = '<font size="15" color="#FFFFFF" face="Zekton">Details</font>'
			dL.x = des.x + des.width / 2 - dL.width / 2;
			dL.y = des.y - dL.height - 5;
			addChild(dL);
		}
		
		
		
		
		
		public function clickedGeneral(e:ListEvent):void
		{
			specific.dataProvider = new DataProvider(e.item.sub);			
		}
		public function clickedSpecific(e:ListEvent):void
		{
			des.text = 	"                     Details                   \n" + 
						"-----------------------------------------------\n" + 
						"\n" + e.item.data + "\n\n" + 
						"-----------------------------------------------\n" + 
						"                       Link                    \n" + 
						"-----------------------------------------------\n" + 
						e.item.link;
			
			if (go && go.parent)
			{
				removeChild(go);
			}
			go = new Button();
			go.label = "Go to Site";
			go.x = des.x + des.width / 2 - go.width / 2;
			go.y = des.y + des.height + 5;
			go.useHandCursor = true;
			addChild(go);
			go.name = e.item.link;
			go.addEventListener(MouseEvent.CLICK, direct);
		}
		public function direct(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(e.currentTarget.name));
		}
		public function textLink(e:TextEvent):void
		{
			navigateToURL(new URLRequest("http://profusiongames.com/"));
		}
		public function gitdLink(e:TextEvent):void
		{
			navigateToURL(new URLRequest("http://www.kongregate.com/games/saybox/coin-collector"));
		}
		
	}

}

/*
package  
{
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
	import flash.events.TextEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.greensock.TweenLite;
	import SWFStats.Log;
	
	public class LinksTab extends Sprite
	{
		public var general:List;
		public var specific:List
		public var des:TextArea;
		public var go:Button;
		public var sug:Button;
		public var logo:TextField
		public var GOTW:TextField;
		
		public var myLabel:Label
		public var isExpanded:Boolean = false;
		
		
		
		public function LinksTab() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			drawBorder();
			createGeneralSelector();
			createSpecificSelector();
			createDescriptionField();
		}
		public function drawBorder():void
		{
			x = stage.stageWidth - 50;
			
			graphics.beginFill(0x666666,0.8);
			graphics.drawRect(50,0,stage.stageWidth-50,stage.stageHeight);
			graphics.endFill();
			
			graphics.beginFill(0x000000,0.8);
			graphics.drawRect(20,5,30,130);
			graphics.endFill();
			
		}
		
		public function handleLabelClick(e:MouseEvent = null):void
		{
			var p:Stage = Stage(parent);
			p.addChild(p.removeChild(this));
			
			//if its expanded
			if(isExpanded)
			{
				Log.CustomMetric("Closed", "Link Tab");
				//shrink off screen
				TweenLite.to(this,1,{x:stage.stageWidth-50});
			}
			else
			{
				Log.CustomMetric("Opened", "Link Tab");
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
			general.y = 50
			general.width = 180;
			general.height = 300;
			addChild(general);
			
			var _items:Array = [];	
			
			_items.push({label:"Actionscript", 	sub:[	{ label:"AS3 Shootorials", 				link:"http://www.kongregate.com/accounts/Moly", 									data:"Start easy in AS3 with this tutorial series ported to AS3 by Moly (recommended)" },
														{ label:"AS2 Shootorials", 				link:"http://www.kongregate.com/labs", 												data:"Get started in making flash games, using easy to learn AS2" },
														{ label:"Adobe Tutorials",				link:"http://www.adobe.com/support/flash/tutorial_index.html", 						data:"Get a feel of Flash and actionscript right from the creators" },
														{ label:"AS3 Avoider Tutorial", 		link:"http://gamedev.michaeljameswilliams.com/as3-avoider-game-tutorial-base/",		data:"Advance in to deeper parts of AS3 by making a complete Avoider game (recommended)" },
														{ label:"Kirupa Tutorials", 			link:"http://www.kirupa.com/developer/flash/index.htm",								data:"A very wide variety of Flash concepts and tutorials (recommended)" },
														{ label:"GotoAndLearn()", 				link:"http://gotoandlearn.com/",													data:"Video and text tutorials on intermediate Flash concepts (recommended)" },
														{ label:"Republic of Code",				link:"http://www.republicofcode.com/tutorials/",									data:"AS3 and AS2 tutorials, with a wide variety and a very easy learning curve (recommended)" },
														{ label:"ASgamer Tutorials",			link:"http://asgamer.com/"	,														data:"A good series on creating a shooter in AS3" }
													]
						});
			_items.push( { label:"Flash IDEs", 		sub:[	{ label:"FlashDevelop",				link:"http://www.flashdevelop.org/",			data:"Free. Code completion, syntax highlighting, and everything else a programmer wished for. (recommended)" },
															{ label:"Adobe Flash Pro",			link:"http://www.adobe.com/products/flash/",	data:"$699. Adobe® Flash® Professional software is the industry standard for interactive authoring and delivery of immersive experiences that present consistently across personal computers, mobile devices, and screens of virtually any size and resolution" },
															{ label:"Eclipse",					link:"http://www.eclipse.org/",					data:"Free. Eclipse is an open source community, whose projects are focused on building an open development platform comprised of extensible frameworks, tools and runtimes for building, deploying and managing software across the lifecycle." },
															{ label:"FDT",						link:"http://www.fdt.powerflasher.com/",		data:"$129-$699. FDT enables you to focus on what you love best: coding. It offers a non-intrusive, intuitive way to help you write, debug, test, and refactor your code." },
															{ label:"Flash Minibuilder",		link:"http://code.google.com/p/minibuilder/",	data:"Free. Online AS3 IDE, edit (with code assist) and compile SWF. Runs in the browser. Note: not recommended at all to beginners" }
														]
						});
			
			_items.push( { label:"Flash Blogs", 	sub:[	{ label:"Emanuele Feronato",		link:"http://www.emanueleferonato.com/",		data:"Lots of AS3 and AS2 game tutorials and advice (recommended)" },
															{ label:"xDragonx10",				link:"http://kaitol.com/",						data:"A very interesting and detailed blog about flash development and how to get rich (recommended)" }
														]
						});
			
			
			_items.push( { label:"Game Engines",	sub:[	{ label:"Flixel",					link:"http://flixel.org/", 									data:"A completely free collection of Actionscript 3 files that helps organize, automate, and optimize Flash games; an object-oriented framework that lets anyone create original and complex games with thousands of objects on screen in just a few hours (recommended)" },
															{ label:"FlashPunk",				link:"http://flashpunk.net/",								data:"FlashPunk is a free ActionScript 3 library designed for developing 2D Flash games. It provides you with a fast, clean framework to prototype and develop your games in. This means that most of the dirty work (timestep, animation, input, and collision to name a few) is already coded for you and ready to go, giving you more time and energy to concentrate on the design and testing of your game (recommended)" },
															{ label:"PushButton",				link:"http://pushbuttonengine.com/", 						data:"Open Source Flash game engine and framework that's designed for a new generation of games. PushButton Engine makes it easy to bring together great existing libraries and components for building Flash games" },
															{ label:"PixelBlitz",					link:"http://www.photonstorm.com/pixelblitz-engine",		data:"PixelBlitz Engine is a game framework for Actionscript3 created by Norm Soule and Richard Davey. It provides quick and easy access to game-related features such as sprite handling, pixel blitting, collision detection, bitmap fonts, game related math, keyboard and mouse handling, parallax scrolling, filter effects and more (recommended)" }
														]
						});
			_items.push( { label:"Game Dev Resources",	sub:[	{ label:"FlashKit",				link:"http://www.flashkit.com/",										data:"Sound, code, everything for flash. Lots of licensed resources, available for free" },
																{ label:"Blackbone's Toolbox",	link:"http://www.kongregate.com/forums/4-programming/topics/44720", 	data:"This thread was made to put many resources for developers of all skill to use and appreciate. In this thread there will be listed resources by they type that they are e.g Art, Music, etc" },
																{ label:"SFXR-Audio Tool",		link:"http://www.drpetter.se/project_sfxr.html",						data:"A free downloadable program which makes it easy to create sound effects (recommended)" }
															]
						});
			_items.push( { label:"Kongregate",	sub:[	{ label:"Developer Forums",			link:"http://www.kongregate.com/forums/developers", 						data:"Consists of the Programming, Collaboration, and Kongregate Labs forum"},
														{ label:"Programming Forums",		link:"http://www.kongregate.com/forums/4-programming", 						data:"The programming forum to get detailed programming help"},
														{ label:"AS3 API",					link:"http://www.kongregate.com/developer_center/docs/as3-api", 			data:"The Kongregate API for Actionscript 3.0"},
														{ label:"AS2 API",					link:"http://www.kongregate.com/developer_center/docs/as2-api", 			data:"The Kongregate API for Actionscript 2.0"},
														{ label:"Developer Center",			link:"http://www.kongregate.com/developer_center", 							data:"The Kongregate Developer center, with links to uploading, APIs, revenue, and developer resources"},
														{ label:"Upload Game",				link:"http://www.kongregate.com/games/new", 								data:"Upload your new game"},
														{ label:"Contests",					link:"http://www.kongregate.com/contests", 									data:"Take a peek at the montly and weekly contests"}
													]
						});
			_items.push( { label:"User Sites",	sub:[	{ label:"RTL_Shadow",				link:"http://aftershockstudios.wordpress.com/", 							data:"Aftershock Studio's main site, stuffed with exclusive content and great tutorials! AS3 and AS2 game tutorials, games, and exclusive content."},
														{ label:"skyboy",					link:"http://www.skyript.com/", 											data:"AS3, in-depth, hard-core scripting. Not for the weak minded." },
														{ label:"ST3ALTH15", 				link:"http://randomprogrammerking.wordpress.com/",							data:"A programming blog aimed toward people trying to learn OOP and AS3."},
														{ label:"UnknownGuardian",			link:"http://profusiongames.com/", 											data:"News on upcoming games, team updates, and game tutorials."}
													]
						});
			
			/ *
			_items.push("Thread: HOW TO MAKE GAMES@http://www.kongregate.com/forums/4-programming/topics/89-faq-making-games-read-first");
			_items.push("Kongregate API@http://www.kongregate.com/developer_center/docs/kongregate-api");
			_items.push("Programming Forum@http://www.kongregate.com/forums/4-programming");
			_items.push("Getting Started with FlashDevelop@http://www.kongregate.com/games/Paltar/flashdevelop-tutorial");
			_items.push("Make An Avoider - MJW@http://gamedev.michaeljameswilliams.com/as3-avoider-game-tutorial-base/");
			_items.push("Emanuele Feronato Flash Blog@http://www.emanueleferonato.com/");
			_items.push("FlashGameLicense.com@http://www.flashgamelicense.com/developer_home.php");
			_items.push("Shootorials for AS2 by Kongregate@http://www.kongregate.com/labs");
			_items.push("Shootorials for AS3 by Moly@http://www.kongregate.com/accounts/Moly");
			_items.push("Tutorial Games on Kongregate@http://www.kongregate.com/tutorials-games");
			_items.push("Official Suggestions Thread@http://www.kongregate.com/forums/4-programming/topics/93529-game-development-room-gdr");
			_items.push("Made By Profusion Dev Team@http://kdugames.wordpress.com/");
			* /
			
			general.dataProvider = new DataProvider(_items);
			general.addEventListener(ListEvent.ITEM_CLICK, clickedGeneral);
			
			
			var gL:Label = new Label();
			gL.autoSize = 'center'
			gL.htmlText = '<font size="15" color="#FFFFFF" face="Zekton">General Categories</font>'
			gL.x = general.x + general.width / 2 - gL.width / 2;
			gL.y = general.y - gL.height - 5;
			addChild(gL);
			
			sug = new Button();
			sug.label = "Suggest More Resources";
			sug.name = "http://www.kongregate.com/accounts/UnknownGuardian/private_messages?focus=true"
			sug.x = general.x;
			sug.y = general.y + general.height + 5;
			sug.width = 150;
			sug.useHandCursor = true;
			sug.addEventListener(MouseEvent.CLICK, direct);
			addChild(sug);
			
			logo = new TextField();
			logo.autoSize = 'center'
			logo.htmlText = '<font size="20" face="Zekton"><a href=\"event:Profusion"><font color="#FFFFFF">Pro</font><font color="#0098FF">fusion</font> <font color="#FFFFFF">Dev Team</font></a>';
			logo.selectable = false;
			logo.addEventListener(TextEvent.LINK, textLink);
			logo.x = stage.stageWidth - logo.width - 5;
			logo.y = stage.stageHeight - logo.height;
			logo.name = "Logo";
			addChild(logo);
			
			
			GOTW = new TextField();
			GOTW.autoSize = 'center'
			GOTW.defaultTextFormat = new TextFormat("Zekton", 20, 0xFFFFFF, null, null, null, null, null, 'center');
			GOTW.htmlText = "The winner of the GiTD #4 was saybox with \n" + '<a href=\"event:Profusion"><bold><font color="#000000">Coin Collector</font></bold></a>\n<font size="10" color="#000000">Explosion at the bank! Collect the coins but watch out for flying bricks.</font>'; //http://www.kongregate.com/games/ST3ALTH15/entrigo //"This space is reserved for Game of the Week winner,\nif they so choose to promote their game."
			GOTW.border = true;
			GOTW.selectable = false;
			GOTW.x = (stage.stageWidth - GOTW.width)/2 + 20;
			GOTW.y = (stage.stageHeight - GOTW.height) / 2 + 175;
			GOTW.addEventListener(TextEvent.LINK, gitdLink);
			GOTW.name = "GOTW";
			addChild(GOTW);
		}
		
		public function createSpecificSelector():void
		{
			specific = new List();
			specific.x = general.x + general.width + 10;
			specific.y = 50
			specific.width = 180;
			specific.height = 300;
			addChild(specific);
			specific.addEventListener(ListEvent.ITEM_CLICK, clickedSpecific);
			
			
			var sL:Label = new Label();
			sL.autoSize = 'center'
			sL.htmlText = '<font size="15" color="#FFFFFF" face="Zekton">Specific Categories</font>'
			sL.x = specific.x + specific.width / 2 - sL.width / 2;
			sL.y = specific.y - sL.height - 5;
			addChild(sL);
		}
		public function createDescriptionField():void
		{
			des = new TextArea();
			des.x = specific.x + specific.width + 10;
			des.y = 50;
			des.width = 200;
			des.height = 300;
			des.editable = false
			
			addChild(des);
			
			var dL:Label = new Label();
			dL.autoSize = 'center'
			dL.htmlText = '<font size="15" color="#FFFFFF" face="Zekton">Details</font>'
			dL.x = des.x + des.width / 2 - dL.width / 2;
			dL.y = des.y - dL.height - 5;
			addChild(dL);
		}
		
		
		
		
		
		public function clickedGeneral(e:ListEvent):void
		{
			specific.dataProvider = new DataProvider(e.item.sub);			
		}
		public function clickedSpecific(e:ListEvent):void
		{
			des.text = 	"                     Details                   \n" + 
						"-----------------------------------------------\n" + 
						"\n" + e.item.data + "\n\n" + 
						"-----------------------------------------------\n" + 
						"                       Link                    \n" + 
						"-----------------------------------------------\n" + 
						e.item.link;
			
			if (go && go.parent)
			{
				removeChild(go);
			}
			go = new Button();
			go.label = "Go to Site";
			go.x = des.x + des.width / 2 - go.width / 2;
			go.y = des.y + des.height + 5;
			go.useHandCursor = true;
			addChild(go);
			go.name = e.item.link;
			go.addEventListener(MouseEvent.CLICK, direct);
		}
		public function direct(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(e.currentTarget.name));
		}
		public function textLink(e:TextEvent):void
		{
			navigateToURL(new URLRequest("http://profusiongames.com/"));
		}
		public function gitdLink(e:TextEvent):void
		{
			navigateToURL(new URLRequest("http://www.kongregate.com/games/saybox/coin-collector"));
		}
		
	}

}
*/