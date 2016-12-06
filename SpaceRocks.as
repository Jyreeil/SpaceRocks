package {	import flash.display.*;	import flash.events.*;	import flash.text.*;	import flash.utils.getTimer;	import flash.utils.Timer;	import flash.geom.Point;
	import flash.media.SoundChannel;
	import flash.net.SharedObject;		public class SpaceRocks extends MovieClip {		static const shipRotationSpeed:Number = .1;		static const rockSpeedStart:Number = .03;		static const rockSpeedIncrease:Number = .02;		static const missileSpeed:Number = .2;		static const thrustPower:Number = .15;		static const shipRadius:Number = 20;		static const startingShips:uint = 3;
		
		// SO objects
		var so1:SharedObject = SharedObject.getLocal("userData");
		var so2:SharedObject = SharedObject.getLocal("userData");
					// game objects		private var ship:Ship;		private var rocks:Array;		private var missiles:Array;
		private var crystals:Array;//my change
		private var shopItems:Array;//my change
		private var explosiveMissiles:Array;
		private var missileStartx:Array;
		private var missileStarty:Array;
		private var explosiveMissileStartx:Array;
		private var explosiveMissileStarty:Array;
		/*private var bonusShipIcons:Array;
		private var bonusShieldIcons:Array;
		private var doubleShotIcons:Array;*/				// animation timer		private var lastTime:uint;				// arrow keys		private var rightArrow:Boolean = false;		private var leftArrow:Boolean = false;		private var upArrow:Boolean = false;
		private var downArrow:Boolean = false;
		
		// bool shop boughts all my changes
		private var autoShieldBought:Boolean = false;
		private var explosiveShotBought:Boolean = false;
		private var extraShipBought:Boolean = false;
		private var multiStream2Bought:Boolean = false;
		private var multiStream3Bought:Boolean = false;
		private var multiStream4Bought:Boolean = false;
		private var multiStream5Bought:Boolean = false;
		private var turnSpeedBought:Boolean = false;
		private var shopOpen:Boolean = false;				// ship velocity		private var shipMoveX:Number;		private var shipMoveY:Number;				// timers		private var delayTimer:Timer;		private var shieldTimer:Timer;
		private var resetTimer:Timer;
		private var shopTimer:Timer;				// game mode		private var gameMode:String;		private var shieldOn:Boolean;
		private var rockHitCount:int = 0;//my change
		private var doubleShot:Boolean;//my change(not currently in use)				// ships and shields		private var shipsLeft:uint;		private var shieldsLeft:uint;		private var shipIcons:Array;		private var shieldIcons:Array;		private var scoreDisplay:TextField;
		private var crystalAmount:TextField;//my change the counter that shows how many crystals the player has		// score and level		private var gameScore:Number;		private var gameLevel:uint;
		private var crystalNum:Number;//my change variable that hold the amount of crystals		// sprites		private var gameObjects:Sprite;		private var scoreObjects:Sprite;
		private var bonusObjects:Sprite;//my change(not currently in use
		private var shopObjects:Sprite;//my change for the shop		
		
		// start the login feature
		// for app security class
		public function regLog(){
			registerBtn1.addEventListener(MouseEvent.CLICK, createSO);
			logInBtn1.addEventListener(MouseEvent.CLICK, retrieveSO);
		}//end app security class stuff, more down below the next function				// start the game		public function startSpaceRocks() {			// set up sprites			gameObjects = new Sprite();			addChild(gameObjects);			scoreObjects = new Sprite();			addChild(scoreObjects);
			bonusObjects = new Sprite();//my change and down to next one
			addChild(bonusObjects);
			shopObjects = new Sprite();
			addChild(shopObjects);//my change						// reset score objects			gameLevel = 1;			shipsLeft = startingShips;			gameScore = 0;
			crystalNum = 0;			createShipIcons();			createScoreDisplay();//my change
			createCrystalDisplay();//my change									// set up listeners
			
			saveBtn1.addEventListener(MouseEvent.CLICK, saveSO);			addEventListener(Event.ENTER_FRAME,moveGameObjects);			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownFunction);			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpFunction);						// start 			gameMode = "delay";			shieldOn = false;			missiles = new Array();
			crystals = new Array();//my change
			shopItems = new Array();
			explosiveMissiles = new Array();
			missileStartx = new Array();
			missileStarty = new Array();
			explosiveMissileStartx = new Array();
			explosiveMissileStarty = new Array();
			/*bonusShipIcons = new Array();
			bonusShieldIcons = new Array();
			doubleShotIcons = new Array();*///my change			nextRockWave(null);			newShip(null);		}
		
		// LOGIN OBJECTS  app security class stuff starting here
		

		function createSO(event:MouseEvent):void{
			
			var username:String;
			var password:String;
			var passwordUnicode:Array;
			var passwordChars:Array;
			var usernameUnicode:Array;
			var usernameChars:Array;
			username = usernameText.text;
			password = passwordText.text;
			//trace(username);
			//trace(password);
			//beginning the encryption
			usernameChars = username.split("");
			passwordChars = password.split("");
			//trace(usernameChars);
			//trace(passwordChars);
			
			
			passwordUnicode = new Array();
			usernameUnicode = new Array();
			
			for (var j:int=0; j<=passwordChars.length-1; j++){
                passwordUnicode.push(passwordChars[j].charCodeAt());
            }
			for (var k:int=0; k<=usernameChars.length-1; k++){
                usernameUnicode.push(usernameChars[k].charCodeAt());
            }
			//trace(passwordUnicode);
			//trace(usernameUnicode);
			for (var l:int=0; l<=passwordUnicode.length-1; l++){
                passwordUnicode[l] = passwordUnicode[l]-(l+1);
            }
			for (var m:int=0; m<=usernameUnicode.length-1; m++){
                usernameUnicode[m] = usernameUnicode[m]-(m+1);
            }
			//trace(passwordUnicode);
			//trace(usernameUnicode);
			
			for (var n:int=0; n<=passwordChars.length-1; n++){
                passwordChars[n] = String.fromCharCode(passwordUnicode[n]);
            }
			for (var o:int=0; o<=usernameChars.length-1; o++){
                usernameChars[o] = String.fromCharCode(usernameUnicode[o]);
            }
			/*trace(passwordChars);
			trace(usernameChars);*/
			
			//writing to shared object
			so1.data.username=usernameChars;
			so1.data.pwdhash=passwordChars;
			so1.flush();
			so2.data.username=usernameChars;
			so2.data.pwdhash=passwordChars;
			so2.flush();
			//clearing the arrays
			for(var p:int=passwordChars.length-1;p>=0;p--){
				passwordChars.splice(p,1);
			}
			for(var q:int=usernameChars.length-1;q>=0;q--){
				usernameChars.splice(q,1);
			}
			for(var r:int=passwordUnicode.length-1;r>=0;r--){
				passwordUnicode.splice(r,1);
			}
			for(var s:int=usernameUnicode.length-1;s>=0;s--){
				usernameUnicode.splice(s,1);
			}
		}
		
		
		function retrieveSO(event:MouseEvent):void{
			var dat:Date = new Date();
			var username:String;
			var password:String;
			var so2Username:String;
			var so2Password:String;
			var enteredUsername:String;
			var enteredPassword:String;
			var passwordUnicode:Array;
			var passwordChars:Array;
			var usernameUnicode:Array;
			var usernameChars:Array;
			enteredUsername = logUsernameText.text;
			enteredPassword = logPasswordText.text;
			username = so1.data.username;
			password = so1.data.pwdhash;
			so2Username = so2.data.username;
			so2Password = so2.data.pwdhash;
			if (username != so2Username){
				logUNNote.text = "Username Modification detected";
			}else if (password != so2Password){
				logPWNote.text = "Password Modification detected";
			} else if (so1.data.score != so2.data.score){
				logUNNote.text = "Score Modification detected";
			}else if (so1.data.crystals != so2.data.crystals){
				logUNNote.text = "Crystal Modification detected";
			}else {
			}
				/*trace(username);
				trace(password);*/
			//decrypting
				usernameChars = username.split(",");
				passwordChars = password.split(",");
				/*trace(usernameChars);
				trace(passwordChars);*/
				passwordUnicode = new Array();
				usernameUnicode = new Array();
				for (var j:int=0; j<=passwordChars.length-1; j++){
					passwordUnicode.push(passwordChars[j].charCodeAt());
				}
				for (var k:int=0; k<=usernameChars.length-1; k++){
					usernameUnicode.push(usernameChars[k].charCodeAt());
				}
				/*trace(passwordUnicode);
				trace(usernameUnicode);*/
			
				for (var l:int=0; l<=passwordUnicode.length-1; l++){
					passwordUnicode[l] = passwordUnicode[l]+(l+1);
				}
				for (var m:int=0; m<=usernameUnicode.length-1; m++){
					usernameUnicode[m] = usernameUnicode[m]+(m+1);
				}
				/*trace(passwordUnicode);
				trace(usernameUnicode);*/
				for (var n:int=0; n<=passwordChars.length-1; n++){
					passwordChars[n] = String.fromCharCode(passwordUnicode[n]);
				}
				for (var o:int=0; o<=usernameChars.length-1; o++){
					usernameChars[o] = String.fromCharCode(usernameUnicode[o]);
				}
				/*trace(passwordChars);
				trace(usernameChars);*/
				username = usernameChars.join("");
				password = passwordChars.join("");
				/*trace(username);
				trace(password);*/
				//retrieving shared objects
				if(username != enteredUsername){
					logUNNote.text = "Bad Username";
				}else if(password != enteredPassword){
					logPWNote.text = "Bad Password";
				}else{
					gameScore = so1.data.score;
					crystalNum = so1.data.crystals;
					date.text = so1.data.date1;
				}//clearing the arrays
				for(var p:int=passwordChars.length-1;p>=0;p--){
					passwordChars.splice(p,1);
				}
				for(var q:int=usernameChars.length-1;q>=0;q--){
					usernameChars.splice(q,1);
				}
				for(var r:int=passwordUnicode.length-1;r>=0;r--){
					passwordUnicode.splice(r,1);
				}
				for(var s:int=usernameUnicode.length-1;s>=0;s--){
					usernameUnicode.splice(s,1);
				}
		}
		
		function saveSO(event:MouseEvent):void{
			//creating shared object properties for the score and crystals and date
			var dat:Date = new Date();
			var date1:Object = new Object();
			date1.prop = dat;
			so1.data.userobj = date1;
			so2.data.userobj = date1;
			var score:Object = new Object();
			score.prop = gameScore;
			so1.data.userobj = score;
			so2.data.userobj = score;
			var crystals:Object = new Object();
			crystals.prop = crystalNum;
			so1.data.userobj = crystals;
			so2.data.userobj = crystals;
			so1.flush();
			so2.flush();
			gotoAndStop("intro");
			
			// remove all objects and listeners
			removeChild(gameObjects);
			removeChild(scoreObjects);
			gameObjects = null;
			scoreObjects = null;
			removeEventListener(Event.ENTER_FRAME,moveGameObjects);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownFunction);
			stage.removeEventListener(KeyboardEvent.KEY_UP,keyUpFunction);
		}//end app security stuff here						// SCORE OBJECTS		
		public function crystal(x, y:int) {//my change whole function
			var newCrystal:Crystal = new Crystal();
			newCrystal.x = x;
			newCrystal.y = y;
			bonusObjects.addChild(newCrystal);
			crystals.push(newCrystal);
			
		}
		
				// draw number of ships left		public function createShipIcons() {			shipIcons = new Array();			for(var i:uint=0;i<shipsLeft;i++) {				var newShip:ShipIcon = new ShipIcon();				newShip.x = 20+i*15;				newShip.y = 375;				scoreObjects.addChild(newShip);				shipIcons.push(newShip);			}		}
		
		public function addShipIcon(i:int) {
			var newShip:ShipIcon = new ShipIcon();
			newShip.x = 5+i*15;
			newShip.y = 375;
			scoreObjects.addChild(newShip);
			shipIcons.push(newShip);
		}				// draw number of shields left		public function createShieldIcons() {			shieldIcons = new Array();			for(var i:uint=0;i<shieldsLeft;i++) {				var newShield:ShieldIcon = new ShieldIcon();				newShield.x = 530-i*15;				newShield.y = 375;				scoreObjects.addChild(newShield);				shieldIcons.push(newShield);			}		}				// put the numerical score at the upper right		public function createScoreDisplay() {			scoreDisplay = new TextField();			scoreDisplay.x = 500;			scoreDisplay.y = 10;			scoreDisplay.width = 40;			scoreDisplay.selectable = false;			var scoreDisplayFormat = new TextFormat();			scoreDisplayFormat.color = 0xFFFFFF;			scoreDisplayFormat.font = "Arial";			scoreDisplayFormat.align = "right";			scoreDisplay.defaultTextFormat = scoreDisplayFormat;			scoreObjects.addChild(scoreDisplay);			updateScore();		}
		
		public function createCrystalDisplay() {//this function is my change for the crystal display
			crystalAmount = new TextField();
			crystalAmount.x = 10;
			crystalAmount.y = 10;
			crystalAmount.width = 40;
			crystalAmount.selectable = false;
			var crystalAmountFormat = new TextFormat();
			crystalAmountFormat.color = 0xFFFFFF;
			crystalAmountFormat.font = "Arial";
			crystalAmountFormat.align = "right";
			crystalAmount.defaultTextFormat = crystalAmountFormat;
			scoreObjects.addChild(crystalAmount);
			updateCrystals();
		}				// new score to show		public function updateScore() {			scoreDisplay.text = String(gameScore);		}
		
		public function updateCrystals() {
			crystalAmount.text = String(crystalNum);
		}				// remove a ship icon		public function removeShipIcon() {			scoreObjects.removeChild(shipIcons.pop());		}				// remove a shield icon		public function removeShieldIcon() {			scoreObjects.removeChild(shieldIcons.pop());		}				// remove the rest of the ship icons		public function removeAllShipIcons() {
			while (shipIcons.length > 0) {
				removeShipIcon();
			}		}				// remove the rest of the shield icons		public function removeAllShieldIcons() {			while (shieldIcons.length > 0) {				removeShieldIcon();			}		}						// SHIP CREATION AND MOVEMENT				// create a new ship		public function newShip(event:TimerEvent) {			// if ship exists, remove it			if (ship != null) {				gameObjects.removeChild(ship);				ship = null;			}						// no more ships			if (shipsLeft < 1) {				endGame();				return;			}						// create, position, and add new ship			ship = new Ship();			ship.gotoAndStop(1);			ship.x = 275;			ship.y = 200;			ship.rotation = -90;			ship.shield.visible = false;			gameObjects.addChild(ship);						// set up ship properties			shipMoveX = 0.0;			shipMoveY = 0.0;			gameMode = "play";						// set up shields
			shieldsLeft = 3;			createShieldIcons();						// all lives but the first start with a free shield			if (shipsLeft != startingShips) {				startShield(true);			}		}				// register key presses		public function keyDownFunction(event:KeyboardEvent) {			if (event.keyCode == 37) {					leftArrow = true;			} else if (event.keyCode == 39) {					rightArrow = true;			}
			if (event.keyCode == 38) {					upArrow = true;					// show thruster					if (gameMode == "play") ship.gotoAndStop(2);			} else if (event.keyCode == 32) {// space
				if (multiStream2Bought == false) {//all this all the way down to the next one are my changes
					if (multiStream3Bought == false) {
						if (multiStream4Bought == false) {
							if (multiStream5Bought == false) {//these are all to make sure that the highest
								newMissile(0);					//level multistream is used if multiple
							} else {							//of them are bought
								newMissile(0);	
								newMissile(.1);
								newMissile(-.1);
								newMissile(.2);
								newMissile(-.2);
							}
						} else if (multiStream5Bought == true) {
							newMissile(0);
							newMissile(.1);
							newMissile(-.1);
							newMissile(.2);
							newMissile(-.2);
						} else {
							newMissile(.05);
							newMissile(-.05);
							newMissile(.15);
							newMissile(-.15);
						}
					} else if (multiStream5Bought == true) {
						newMissile(0);
						newMissile(.1);
						newMissile(-.1);
						newMissile(.2);
						newMissile(-.2);
					} else if (multiStream4Bought == true) {
						newMissile(.05);
						newMissile(-.05);
						newMissile(.15);
						newMissile(-.15);
					} else {
						newMissile(0);
						newMissile(.1);
						newMissile(-.1);
					}
				} else if (multiStream5Bought == true) {
					newMissile(0);
					newMissile(.1);
					newMissile(-.1);
					newMissile(.2);
					newMissile(-.2);
				} else if (multiStream4Bought == true) {
					newMissile(.05);
					newMissile(-.05);
					newMissile(.15);
					newMissile(-.15);
				} else if (multiStream3Bought == true) {
					newMissile(0);
					newMissile(.1);
					newMissile(-.1);
				} else {
					newMissile(.05);
					newMissile(-.05);
				}//my changes stop here			} else if (event.keyCode == 90) { // z					startShield(false);			}else if (event.keyCode == 40) {
					downArrow = true;
			}		}					// register key ups		public function keyUpFunction(event:KeyboardEvent) {			if (event.keyCode == 37) {				leftArrow = false;			} else if (event.keyCode == 39) {				rightArrow = false;			}
			if (event.keyCode == 38) {				upArrow = false;				// remove thruster				if (gameMode == "play") ship.gotoAndStop(1);			}else if (event.keyCode == 40) {
					downArrow = false;
			}		}				// animate ship		public function moveShip(timeDiff:uint) {			var mod:Number;
			mod = shipRotationSpeed;
			if (turnSpeedBought == true) {
				mod = shipRotationSpeed*2;
			}			// rotate and thrust			if (leftArrow) {				ship.rotation -= mod*timeDiff;			} else if (rightArrow) {				ship.rotation += mod*timeDiff;			}
			if (upArrow) {				shipMoveX += Math.cos(Math.PI*ship.rotation/180)*thrustPower;				shipMoveY += Math.sin(Math.PI*ship.rotation/180)*thrustPower;			} else if (downArrow) {
				shipMoveX = 0
				shipMoveY = 0
			}						// move			ship.x += shipMoveX;			ship.y += shipMoveY;						// wrap around screen			if ((shipMoveX > 0) && (ship.x > 570)) {				ship.x -= 590;			}			if ((shipMoveX < 0) && (ship.x < -20)) {				ship.x += 590;			}			if ((shipMoveY > 0) && (ship.y > 420)) {				ship.y -= 440;			}			if ((shipMoveY < 0) && (ship.y < -20)) {				ship.y += 440;			}		}				// remove ship		public function shipHit() {			gameMode = "delay";
			ship.gotoAndPlay("explode");
			removeAllShieldIcons();
			delayTimer = new Timer(2000,1);
			delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,newShip);
			delayTimer.start();
			removeShipIcon();
			shipsLeft--;		}				// turn on shield for 3 seconds		public function startShield(freeShield:Boolean) {			if (shieldsLeft < 1) return; // no shields left			if (shieldOn) return; // shield already on						// turn on shield and set timer to turn off			ship.shield.visible = true;			shieldTimer = new Timer(3000,1);			shieldTimer.addEventListener(TimerEvent.TIMER_COMPLETE,endShield);			shieldTimer.start();						// update shields remaining			if (!freeShield) {				removeShieldIcon();				shieldsLeft--;			}			shieldOn = true;		}				// turn off shield		public function endShield(event:TimerEvent) {			ship.shield.visible = false;			shieldOn = false;		}				// ROCKS						// create a single rock of a specific size		public function newRock(x,y:int, rockType:String) {						// create appropriate new class			var newRock:MovieClip;			var rockRadius:Number;			if (rockType == "Big") {				newRock = new Rock_Big();				rockRadius = 35;			} else if (rockType == "Medium") {				newRock = new Rock_Medium();				rockRadius = 20;			} else if (rockType == "Small") {				newRock = new Rock_Small();				rockRadius = 10;			}						// Here is an alternate way to do the above, without a case statement			// Need to import flash.utils.getDefinitionByName to use			/*			var rockClass:Object = getDefinitionByName("Rock_"+rockType);			var newRock:MovieClip = new rockClass();			*/						// choose a random look			newRock.gotoAndStop(Math.ceil(Math.random()*3));						// set start position			newRock.x = x;			newRock.y = y;						// set random movement and rotation			var dx:Number = Math.random()*2.0-1.0;			var dy:Number = Math.random()*2.0-1.0;			var dr:Number = Math.random();						// add to stage and to rocks list			gameObjects.addChild(newRock);			rocks.push({rock:newRock, dx:dx, dy:dy, dr:dr, rockType:rockType, rockRadius: rockRadius});		}				// create four rocks		public function nextRockWave(event:TimerEvent) {
			if (shopOpen == true) {
				removeAllShopItems();
				shopOpen = false;
			}			rocks = new Array();			newRock(100,100,"Big");			newRock(100,300,"Big");			newRock(450,100,"Big");			newRock(450,300,"Big");
			nextLevelRocks(1);
			nextLevelRocks(2);
			nextLevelRocks(3);
			nextLevelRocks(4);
			nextLevelRocks(5);			gameMode = "play";		}
		
		public function nextLevelRocks(level:int) {
			if (gameLevel > level) {
				newRock(0,0,"Big");
			}
		}				// animate all rocks		public function moveRocks(timeDiff:uint) {			for(var i:int=rocks.length-1;i>=0;i--) {								// move the rocks				var rockSpeed:Number = rockSpeedStart + rockSpeedIncrease*gameLevel;				rocks[i].rock.x += rocks[i].dx*timeDiff*rockSpeed;				rocks[i].rock.y += rocks[i].dy*timeDiff*rockSpeed;								// rotate rocks				rocks[i].rock.rotation += rocks[i].dr*timeDiff*rockSpeed;								// wrap rocks				if ((rocks[i].dx > 0) && (rocks[i].rock.x > 570)) {					rocks[i].rock.x -= 590;				}				if ((rocks[i].dx < 0) && (rocks[i].rock.x < -20)) {					rocks[i].rock.x += 590;				}				if ((rocks[i].dy > 0) && (rocks[i].rock.y > 420)) {					rocks[i].rock.y -= 440;				}				if ((rocks[i].dy < 0) && (rocks[i].rock.y < -20)) {					rocks[i].rock.y += 440;				}			}		}				public function rockHit(rockNum:uint) {
			if (Math.random() > .6) {//my change
					crystal(rocks[rockNum].rock.x,rocks[rockNum].rock.y);
				}			// create two smaller rocks			if (rocks[rockNum].rockType == "Big") {				newRock(rocks[rockNum].rock.x,rocks[rockNum].rock.y,"Medium");				newRock(rocks[rockNum].rock.x,rocks[rockNum].rock.y,"Medium");			} else if (rocks[rockNum].rockType == "Medium") {				newRock(rocks[rockNum].rock.x,rocks[rockNum].rock.y,"Small");				newRock(rocks[rockNum].rock.x,rocks[rockNum].rock.y,"Small");			}			// remove original rock			gameObjects.removeChild(rocks[rockNum].rock);			rocks.splice(rockNum,1);		}				// MISSILES				// create a new Missile		public function newMissile(direction:Number) {
			var missileSound:lasersoundmp3 = new lasersoundmp3();
			var channel:SoundChannel = missileSound.play();			// create			var newMissile:Missile = new Missile();						// set direction			newMissile.dx = Math.cos((Math.PI*ship.rotation/180)+direction);//I changed the 180 to the variable			newMissile.dy = Math.sin((Math.PI*ship.rotation/180)+direction);// "direction" so that I could call																	//the new missile function with whatever			// placement											//direction I wanted but currently seems			newMissile.x = ship.x + newMissile.dx*shipRadius;		//to be a little bit off			newMissile.y = ship.y + newMissile.dy*shipRadius;
			
			var startx:int = ship.x;
			var starty:int = ship.y;
			
			missileStartx.push(startx)
			missileStarty.push(starty)				// add to stage and array			gameObjects.addChild(newMissile);			missiles.push(newMissile);		}
		
		public function newExplosiveMissile(x, y:int, directiondx:Number, directiondy:Number) {
			var missileSound:lasersoundmp3 = new lasersoundmp3();
			var channel:SoundChannel = missileSound.play();
			
			var newMissile:Missile = new Missile();
			
			// set direction
			newMissile.dx = directiondx;
			newMissile.dy = directiondy;
																	
			// placement											
			newMissile.x = x + newMissile.dx;		
			newMissile.y = y + newMissile.dy;
			
			explosiveMissileStartx.push(x);
			explosiveMissileStarty.push(y);
	
			// add to stage and array
			gameObjects.addChild(newMissile);
			explosiveMissiles.push(newMissile);
		}				// animate missiles		public function moveMissiles(timeDiff:uint) {			for(var i:int=missiles.length-1;i>=0;i--) {				// move				missiles[i].x += missiles[i].dx*missileSpeed*timeDiff;				missiles[i].y += missiles[i].dy*missileSpeed*timeDiff;				// moved off screen
				
				
				
				if ((missiles[i].dx > 0) && (missiles[i].x > 570)) {
					missiles[i].x -= 590;
					missileStartx[i] -= 590;
				}
				if ((missiles[i].dx < 0) && (missiles[i].x < -20)) {
					missiles[i].x += 590;
					missileStartx[i] += 590;
				}
				if ((missiles[i].dy > 0) && (missiles[i].y > 420)) {
					missiles[i].y -= 440;
					missileStarty[i] -= 440;
				}
				if ((missiles[i].dy < 0) && (missiles[i].y < -20)) {
					missiles[i].y += 440;
					missileStarty[i] += 440;
				}
				
				if (Math.sqrt((missileStartx[i] - missiles[i].x)*(missileStartx[i] - missiles[i].x) +
									(missileStarty[i] - missiles[i].y)*(missileStarty[i] - missiles[i].y))
											> 200){
						if (explosiveShotBought == true) {
							if((missiles[i].dx > 0 && missiles[i].dy > 0) || (missiles[i].dx < 0 && missiles[i].dy < 0)) {
								var newdx:Number;
								newdx = Math.cos(Math.acos(missiles[i].dx)+(Math.PI/2));
								var newdy:Number;
								newdy = Math.sin(Math.asin(missiles[i].dy)+(Math.PI/2));
							}else {
								newdx = Math.cos(Math.acos(missiles[i].dx)-(Math.PI/2));
								newdy = Math.sin(Math.asin(missiles[i].dy)+(Math.PI/2));
							}
							newExplosiveMissile(missiles[i].x, missiles[i].y, newdx, newdy);
							if((missiles[i].dx > 0 && missiles[i].dy > 0) || (missiles[i].dx < 0 && missiles[i].dy < 0)) {
								newdx = Math.cos(Math.acos(missiles[i].dx)-(Math.PI/2));
								newdy = Math.sin(Math.asin(missiles[i].dy)-(Math.PI/2));
							} else {
								newdx = Math.cos(Math.acos(missiles[i].dx)+(Math.PI/2));
								newdy = Math.sin(Math.asin(missiles[i].dy)-(Math.PI/2));
							}
						
							newExplosiveMissile(missiles[i].x, missiles[i].y, newdx, newdy);
							missileHit(i);
					}
					missileHit(i);
					/*gameObjects.removeChild(missiles[i]);
					delete missiles[i];
					missiles.splice(i,1);*/
					missileStartx.splice(i,1);
					missileStarty.splice(i,1);
				}
							}
			for(var j:int=explosiveMissiles.length-1;j>=0;j--) {
				// move
				explosiveMissiles[j].x += explosiveMissiles[j].dx*missileSpeed*timeDiff;
				explosiveMissiles[j].y += explosiveMissiles[j].dy*missileSpeed*timeDiff;
				// moved off screen
				
				
				if ((explosiveMissiles[j].dx > 0) && (explosiveMissiles[j].x > 570)) {
					explosiveMissiles[j].x -= 590;
					explosiveMissileStartx[j] -= 590;
				}
				if ((explosiveMissiles[j].dx < 0) && (explosiveMissiles[j].x < -20)) {
					explosiveMissiles[j].x += 590;
					explosiveMissileStartx[j] += 590;
				}
				if ((explosiveMissiles[j].dy > 0) && (explosiveMissiles[j].y > 420)) {
					explosiveMissiles[j].y -= 440;
					explosiveMissileStarty[j] -= 440;
				}
				if ((explosiveMissiles[j].dy < 0) && (explosiveMissiles[j].y < -20)) {
					explosiveMissiles[j].y += 440;
					explosiveMissileStarty[j] += 440;
				}
				if (Math.sqrt((explosiveMissileStartx[j] - explosiveMissiles[j].x)*
									(explosiveMissileStartx[j] - explosiveMissiles[j].x) +
									(explosiveMissileStarty[j] - explosiveMissiles[j].y)*
									(explosiveMissileStarty[j] - explosiveMissiles[j].y))
											> 200){
												gameObjects.removeChild(explosiveMissiles[j]);
												delete explosiveMissiles[j];
												explosiveMissiles.splice(j,1);
												explosiveMissileStartx.splice(j,1);
												explosiveMissileStarty.splice(j,1);
											}
			}		}
		
				// remove a missile		public function missileHit(missileNum:uint) {			gameObjects.removeChild(missiles[missileNum]);			missiles.splice(missileNum,1);		}				// GAME INTERACTION AND CONTROL
		
		public function resetCount(event:TimerEvent) {//my change
			rockHitCount = 0;
			resetTimer.stop();
		}
		
		public function showShop() {//this is all my changes down to the next one
			//if (autoShieldBought == false) {
				var newAutoShield:AutoShield = new AutoShield();
				newAutoShield.x = 60;
				newAutoShield.y = 50;
				shopObjects.addChild(newAutoShield);
				shopItems.push(newAutoShield);
			//}
			//if (explosiveShotBought == false) {
				var newExplosiveShot:ExplosiveShot = new ExplosiveShot();
				newExplosiveShot.x = 60;
				newExplosiveShot.y = 150;
				shopObjects.addChild(newExplosiveShot);
				shopItems.push(newExplosiveShot);
			//}
			//if (extraShipBought == false) {
				var newExtraShip:ExtraShip = new ExtraShip();
				newExtraShip.x = 60;
				newExtraShip.y = 250;
				shopObjects.addChild(newExtraShip);
				shopItems.push(newExtraShip);
			//}
			//if (turnSpeedBought == false) {
				var newTurnSpeed:TurnSpeed = new TurnSpeed();
				newTurnSpeed.x = 60;
				newTurnSpeed.y = 350;
				shopObjects.addChild(newTurnSpeed);
				shopItems.push(newTurnSpeed);
			//}
			//if (multiStream2Bought == false) {
				var newMultiStream2:MultiStream2 = new MultiStream2();
				newMultiStream2.x = 490;
				newMultiStream2.y = 50;
				shopObjects.addChild(newMultiStream2);
				shopItems.push(newMultiStream2);
			//}
			//if (multiStream3Bought == false) {
				var newMultiStream3:MultiStream3 = new MultiStream3();
				newMultiStream3.x = 490;
				newMultiStream3.y = 150;
				shopObjects.addChild(newMultiStream3);
				shopItems.push(newMultiStream3);
			//}
			//if (multiStream4Bought == false) {
				var newMultiStream4:MultiStream4 = new MultiStream4();
				newMultiStream4.x = 490;
				newMultiStream4.y = 250;
				shopObjects.addChild(newMultiStream4);
				shopItems.push(newMultiStream4);
			//}
			//if (multiStream5Bought == false) {
				var newMultiStream5:MultiStream5 = new MultiStream5();
				newMultiStream5.x = 490;
				newMultiStream5.y = 350;
				shopObjects.addChild(newMultiStream5);
				shopItems.push(newMultiStream5);
			//}
			var newExit:Exit = new Exit();
			newExit.x = 275;
			newExit.y = 350;
			shopObjects.addChild(newExit);
			shopItems.push(newExit);
		}
		
		public function removeShopItem() {
			shopObjects.removeChild(shopItems.pop());
		}
		
		public function removeAllShopItems() {
			while (shopItems.length > 0) {
				removeShopItem();
			}
		}				public function moveGameObjects(event:Event) {			// get timer difference and animate			var timePassed:uint = getTimer() - lastTime;			lastTime += timePassed;			moveRocks(timePassed);			if (gameMode != "delay") {				moveShip(timePassed);			}			moveMissiles(timePassed);			checkCollisions();		}				// look for missiles colliding with rocks		public function checkCollisions() {			// loop through rocks			rockloop: for(var j:int=rocks.length-1;j>=0;j--) {				// loop through missiles				missileloop: for(var i:int=missiles.length-1;i>=0;i--) {					// collision detection 					if (Point.distance(new Point(rocks[j].rock.x,rocks[j].rock.y),
							new Point(missiles[i].x,missiles[i].y))
								< rocks[j].rockRadius) {
									
									
					if (explosiveShotBought == true) {
						var newdx:Number;
						newdx = Math.cos(Math.acos(missiles[i].dx)-(Math.PI/2));
						var newdy:Number;
						newdy = Math.sin(Math.asin(missiles[i].dy)+(Math.PI/2));
						
						newExplosiveMissile(missiles[i].x, missiles[i].y,
							newdx, newdy);
						newdx = Math.cos(Math.acos(missiles[i].dx)+(Math.PI/2));
						newdy = Math.sin(Math.asin(missiles[i].dy)-(Math.PI/2));
						
						newExplosiveMissile(missiles[i].x, missiles[i].y, 
							newdx, newdy);
						
					}												// remove rock and missile						rockHit(j);						missileHit(i);
						missileStartx.splice(i,1);
						missileStarty.splice(i,1);												// add score						gameScore += 10;						updateScore();
						continue rockloop;					}				}
				for(var f:int=explosiveMissiles.length-1;f>=0;f--) {
					// collision detection 
					if (Point.distance(new Point(rocks[j].rock.x,rocks[j].rock.y),
							new Point(explosiveMissiles[f].x,explosiveMissiles[f].y))
								< rocks[j].rockRadius) {
						
						// remove rock and missile
						rockHit(j);
						gameObjects.removeChild(explosiveMissiles[f]);
						delete explosiveMissiles[f];
						explosiveMissiles.splice(f,1);
						explosiveMissileStartx.splice(f,1);
						explosiveMissileStarty.splice(f,1);
						
						// add score
						gameScore += 10;
						updateScore();
						
						// break out of this loop and continue next one
						continue rockloop;
					}
				}								// check for rock hitting ship				if (gameMode == "play") { // only if shield is off						if (Point.distance(new Point(rocks[j].rock.x,rocks[j].rock.y),								new Point(ship.x,ship.y))									< rocks[j].rockRadius+shipRadius) {							
							if (shieldOn == false) {//my changes are peppered in here
								if (autoShieldBought == false) {
									shipHit();
									rockHit(j);
								} else if (shieldsLeft > 0) {
									startShield(false);
									rockHit(j);
								} else {
									shipHit();
									rockHit(j);
								}							// remove ship and rock							}else {
								if (rockHitCount == 0) {
									rockHit(j);
									rockHitCount++
								}else {
								
								resetTimer = new Timer(2000,1);
								resetTimer.addEventListener(TimerEvent.TIMER_COMPLETE,resetCount);
								resetTimer.start();
							}
						}					}				}
				
							}
			
			//This is the collision detection that does work now.
			//
			if (crystals.length!=0){
				if (gameMode == "play") {
					for(var h:int=crystals.length-1;h>=0;h--){
						if (Point.distance(new Point(crystals[h].x, crystals[h].y), 
							new Point(ship.x,ship.y)) < 15+shipRadius) {
												crystalNum += 1;
												updateCrystals();
												/*createShipIcons();*/
												bonusObjects.removeChild(crystals[h]);
												crystals.splice(h,1);
						}
					}
					
				}
			}
			if (shopItems.length!=0){
				if (gameMode == "betweenlevels") {
					shopItemsloop: for(var g:int=shopItems.length-1;g>=0;g--){
						if (Point.distance(new Point(shopItems[g].x, shopItems[g].y), 
							new Point(ship.x,ship.y)) < 25+shipRadius) {
												if (g == 0) {
										if (crystalNum >= 15){
											if (autoShieldBought == false) {
												autoShieldBought = true;
												crystalNum -= 15;
												updateCrystals();
											}
										}
									}
				if (g == 1) {
					if (crystalNum >= 40) {
						if (explosiveShotBought == false) {
							explosiveShotBought = true;
							crystalNum -= 40;
							updateCrystals();
						}
					}
				}
				if (g == 2) {
					if (crystalNum >= 5) {
						if (extraShipBought == false) {
							extraShipBought = true;
							shipsLeft += 1;
							addShipIcon(shipsLeft);
							crystalNum -= 5;
							updateCrystals();
						}
					}
				}
				if (g == 3) {
					if (crystalNum >= 10) {
						if (turnSpeedBought == false) {
							turnSpeedBought = true;
							crystalNum -= 10;
							updateCrystals();
						}
					}
				}
				if (g == 4) {
					if (crystalNum >= 15) {
						if (multiStream2Bought == false) {
							multiStream2Bought = true;
							crystalNum -= 15;
							updateCrystals();
						}
					}
				}
				if (g == 5) {
					if (crystalNum >= 20) {
						if (multiStream3Bought == false) {
							multiStream3Bought = true;
							crystalNum -= 20;
							updateCrystals();
						}
					}
				}
				if (g == 6) {
					if (crystalNum >= 30) {
						if (multiStream4Bought == false) {
							multiStream4Bought = true;
							crystalNum -= 30;
							updateCrystals();
						}
					}
				}
				if (g == 7) {
					if (crystalNum >= 40) {
						if (multiStream5Bought == false) {
							multiStream5Bought = true;
							crystalNum -= 40;
							updateCrystals();
						}
					}
				}
				if (g == 8) {
					removeAllShopItems();
					newShip(null);
					nextRockWave(null);
					shopOpen = false;
					extraShipBought = false;
				}
						continue shopItemsloop;
						}
					}
					
				}
			}						// all out of rocks, change game mode and trigger more			if ((rocks.length == 0) && (gameMode == "play")) {				gameMode = "betweenlevels";				gameLevel++; // advance a level
				showShop();//few changes right here
				shopOpen = true;			}		}				public function endGame() {			// remove all objects and listeners			removeChild(gameObjects);			removeChild(scoreObjects);			gameObjects = null;			scoreObjects = null;			removeEventListener(Event.ENTER_FRAME,moveGameObjects);			stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownFunction);			stage.removeEventListener(KeyboardEvent.KEY_UP,keyUpFunction);						gotoAndStop("gameover");		}			}}			