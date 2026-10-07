/* Current To-Dos
 
 Basil
 
 Alex
 
 */

import java.io.BufferedReader;
import java.io.InputStreamReader;
//Schrift
PFont titleFont;
PFont mainFont;

//Classes
Player[] player = new Player[2];

//Angles
float[] betaAngles = { 0.0, 0.0 };

//-----controller-----
int [] shake = {0, 0};
int controllerInput_2;
int controllerInput_1 = 0;
int [] shake_threashold = {25, 80};
public boolean hardmode = false;



//Player Values
//Abilities
int[] abilityCounter = { 0, 0 };
int[] abilityCounterCap = { 10, 8};
int[] abilityNeeded = {3, abilityCounterCap[1]};
int abilityP2Timer = 0;
int abilityCooldownP2 = 500;
//Shaking
boolean[] isShaking = { false, false };
boolean[] shakeCooldown = { false, false };
boolean[] abilityUse = { false, false };
int[] shakeCap = { 30, 100 };
int[] shakeState = { shakeCap[0]-1, shakeCap[1]-1 };
//Explosion – Collider
float explosionColliderHitboxFactor = 1;
//Speed
float[] playerSpeedAbs = { 0.3, 0 };
float[] playerSpeed = { playerSpeedAbs[0], playerSpeedAbs[1] };
//Size
float[] playerSize = { 40, 80 };
//Colors
color[] playerColor = { 0, #ed4d0e }; //#828282
//Inputs
int[][] playerKeyInputs = {{ 38 /*UP*/, 40 /*DOWN*/, 47 /*— R*/}, { 83 /*W*/, 87 /*S*/, 32 /*SPACE*/}};

//Placeholder Key Input Controll
float[] increaseSteps = { 0.5, 0.5 };
float maxBetaAngle = 3;
float minBetaAngle = -3;

//Imput Numbers
String line;
String controllerIndex ="1";
String poti_value_1 = "110";
String shake_value_1 = "10";

String poti_value_2 = "0", shake_value_2 = "0";

//Collectibles
ArrayList<Collectible> collectible = new ArrayList<Collectible>();
int timeSafe = 5;

//Envoirenment
color backgroundColor = #FFFFFF; //#002138
Background Background;

//Spawn Timer
int[][] collectableSpawnTime = {{0, 0, 0}, {0, 0, 0}}; //Current, Next
int minSpawnTime = 2500;
int maxSpawnTime = 7500;

//Game Sate
boolean keyboardEnable = false;
boolean controllerEnable = false;
boolean gameIsLoading = false;

//Game Time
int gameLength = 60;
int startTime = millis();
int fixedStartTime = millis();
int gameTimer;

//EndScreen Timer
int screenLength = 10;
int startScreenTime = millis();
int ScreenTimer;
int ScreenTimerSeconds = 0;

//HomeScreenIdle

int menueIldeDirection = 1; 

//Score
float gameTimeScore;

String highScoreFile = "highScore.txt";
String lowScoreFile = "lowScore.txt";
float gameTimeHighScore;
float gameTimeLowScore;

float potiSteps = maxBetaAngle/(940/2);
float [] potiConvertetAngle = {0.0, 0.0};
//UI
TextBlock TextBlock;
String[] text;

//Sate machine
public enum State {
    MAIN_MENUE,
    PLAY_KEYBOARD,
    PLAY_CONTROLLER,
    ENDSCREEN,
}

//UI

//Text
float generallMargin = 30;
String[] textBlock;

//Main Menue
float menueTimer = 0;
float increaseMenueBG = 0.1;
float increaseMenueBGSpeed = 0.01;

boolean fadeIn_key = false;
boolean fadeIn_controller = false;

State currentState;

//–––
//Start Function – nur einmal am anfang
//–––

void setup() {
  //Main Setup
  rectMode(CENTER);
  //Typeface
  titleFont = createFont("assets/DOSSCollection-Acid-Trial.ttf", 20);
  mainFont = createFont("assets/TWKBurns-Bold.ttf", 20);
  textFont (mainFont);

  //Instantiate Classes
  setupStart();

  //Window Setup
  //size(1400, 900);
  fullScreen();

  //Store current Time
  for (int i = 0; i < collectableSpawnTime[0].length; i++) {
    collectableSpawnTime[0][i] = millis();
    collectableSpawnTime[1][i] = int(random(minSpawnTime, maxSpawnTime));
  }

  //Score
  String[] fileHighScore = loadStrings(highScoreFile);
  if (fileHighScore.length > 0) {
    gameTimeHighScore = int(fileHighScore[0]);
  } else {
    gameTimeHighScore = 0;
  }
  String[] fileLowScore = loadStrings(lowScoreFile);
  if (fileLowScore.length > 0) {
    gameTimeLowScore = int(fileLowScore[0]);
  } else {
    gameTimeLowScore = 100000000;
  }


  //State Setup
  currentState = State.MAIN_MENUE;
  //currentState = State.PLAY_KEYBOARD;
  //currentState = State.ENDSCREEN;
  //screensetting
  surface.setResizable(true);
  //Start Input Script
  new Thread(() -> {
    startBluetoothBridge();
  }
  ).start();
}

void setupStart() {
  //Inst. Players
  player[0] = new PlayerSmall(playerColor[0], playerSize[0]);
  player[1] = new PlayerBig(playerColor[1], playerSize[1]);
  betaAngles = new float[]{ 0.0, 0.0 };
  TextBlock = new TextBlock();
  Background = new Background();
  abilityCounter[0] = 0;
  abilityCounter[1] = 0;
  shakeState[0] = 0;
  shakeState[1] = 0;
  abilityUse[0] = false;
  abilityUse[1] = false;
  startTime = millis();
  fixedStartTime = millis();
  startScreenTime = millis();
  ScreenTimerSeconds = 0;
  isShaking[0] = false;
  isShaking[1] = false;
  shakeCooldown[0] = false;
  shakeCooldown[1] = false;
  for (int i = collectible.size() - 1; i >= 0; i--) {
    collectible.remove(i);
  }
}

//–––
//Draw Function – 60 mal in der Sekunde
//–––

void draw() {
  //Draw Background
  background(backgroundColor);
  
  //----übertragung von bluetoothcontroler werte zu lokalen variablen------
    if (!poti_value_1.isEmpty()) {
      //Convert Input String to Int
      controllerInput_1 = Integer.parseInt(poti_value_1);
      shake[0] = Integer.parseInt(shake_value_1);
    }
    if (!poti_value_2.isEmpty()) {
      //Convert Input String to Int
      controllerInput_2 = Integer.parseInt(poti_value_2);
      shake[1] = Integer.parseInt(shake_value_2);
    }
    
  switch(currentState) {
    //startfenster
    //menue frage controller o oder p
    
    
    
  case MAIN_MENUE:

    backgroundColor = 255;

    //Shake Value
    shakeState[1] += isShaking[1] ? 1 : -1;
    shakeState[1] = constrain(shakeState[1], 0, shakeCap[1]);

    textAlign(CENTER);
    fill(playerColor[1], 255 - shakeState[1]*3);
    textFont (titleFont);
    textSize(300);
    text("PUFFER", width/2, height/2);
    text("HUNT", width/2, height/2 + 230);
    textSize(50);
    text("SHAKE A CONTROLLER TO START", width/2, height-200);
    textFont (mainFont);
    
    Background.display(width/2, height/2, gameLength, menueTimer*100);
    menueTimer += increaseMenueBG;
    increaseMenueBG += increaseMenueBGSpeed;

    //Display Player
    for (int p = 0; p < player.length; p++) {
      ability(p);
      player[p].display(backgroundColor, abilityCounter[p], abilityNeeded[p]);
    }
    player[0].move(playerSpeed[0], 2 * menueIldeDirection);
    
    player[1].move(playerSpeed[1], 1);
    
    if (abilityCounter[1] < abilityCounterCap[1]) {
      if (abilityP2Timer < abilityCooldownP2/8) {
        abilityP2Timer++;
      } else {
        abilityCounter[1]++;
        abilityP2Timer = 0;
      }
    }
    
    if(abilityCounter[1] == abilityCounterCap[1]){
      abilityUse[1] = true;
      abilityCounter[1] = 0;
    }
    
    //Collider
    if (dist(player[0].x, player[0].y, player[1].x, player[1].y) < playerSize[1] * explosionColliderHitboxFactor) {
      backgroundColor = (playerColor[1]);
    } else {
      backgroundColor = 255;
    }
    
    
    if (menueTimer
      > gameLength*10 || menueTimer < 0) {
      increaseMenueBG *= -1;
    }
    if (increaseMenueBG > 1 || increaseMenueBG < 0) {
      increaseMenueBGSpeed *= -1;
    }
    
    //----START GAME WHEN SHAKED KEYBOARD---

    if (shakeState[1] >= shakeCap[1]) {
      shakeState[1] = shakeCap[1]+1;
      fadeIn_key = true;
    }

    if ( fadeIn() ) {
      setupStart();
      shakeState[0] = 0;
      shakeState[1] = 0;
      gameIsLoading = true;
      currentState = State.PLAY_KEYBOARD;
    }

     //----starte spiel wenn controller small oder big über 50 geschütelt werden----
    if (shake[0] >= 50 || shake[1]>=50) {
      fadeIn_controller = true;
    }
    if (fadeIn_controller) {
      setupStart();
      shake[0] = 0;
      shake[1] = 0;
      currentState = State.PLAY_CONTROLLER;
      fadeIn_controller = false;
    }
    
    //----Text---

    text = new String[]{
      "START GAME",
      "",
      "SHAKE 1 Space " + shakeState[1] + " > Keyboard",
      "P > BLE_Controller",
    };
    TextBlock.display(text, generallMargin, generallMargin);

    break;

    // wenn mit Keyboard gespielt wird
  case PLAY_KEYBOARD:

    //Background
    update_background();

    //Timer
    gameTimer = millis() - startTime;

    //Display Player
    for (int p = 0; p < player.length; p++) {
      ability(p);
      player[p].move(playerSpeed[p], betaAngles[p]);
      player[p].display(backgroundColor, abilityCounter[p], abilityNeeded[p]);
    }

    //Abbility Player 2

    if (abilityCounter[1] < abilityCounterCap[1]) {
      if (abilityP2Timer < abilityCooldownP2/8) {
        abilityP2Timer++;
      } else {
        abilityCounter[1]++;
        abilityP2Timer = 0;
      }
    }

    shake();

    //Collectibles
    if (millis() - collectableSpawnTime[0][1] >= collectableSpawnTime[1][1]) {
      spawnCollectible(1);
      //Next Spawn
      collectableSpawnTime[0][1] = millis();//also update the stored time
      collectableSpawnTime[1][1] = int(random(minSpawnTime, maxSpawnTime));
    }

    //Collectibles
    //displayCollectibles
    for (int i = collectible.size() - 1; i >= 0; i--) {
      Collectible c = collectible.get(i);
      c.display();

      //Colliders
      if (dist(c.xColPos, c.yColPos, player[0].x, player[0].y) < playerSize[0]) {
        collectible.remove(i);
        if (abilityCounter[0] < abilityCounterCap[0]) {
          abilityCounter[0]++;
        }
        startTime += timeSafe * 1000;
      }
    }

    //Enemy Collider
    //Explosion Collider
    if (dist(player[0].x, player[0].y, player[1].x, player[1].y) < playerSize[1] * explosionColliderHitboxFactor) {
      startTime -= timeSafe * 50;
      backgroundColor = (playerColor[1]);
    } else {
      backgroundColor = 255;
    }


    //Game Over Trigger
    if (gameTimer >= gameLength * 1000) {
      println("GAME OVER");
      //Score
      gameTimeScore = millis() - fixedStartTime;
      //Score Longest
      if (gameTimeScore > gameTimeHighScore) {
        gameTimeHighScore = gameTimeScore;
        String[] currentHighScore = { str(gameTimeHighScore) };
        saveStrings(highScoreFile, currentHighScore);
      }
      //Score Shortest
      if (gameTimeScore < gameTimeLowScore) {
        gameTimeLowScore = gameTimeScore;
        String[] currentLowScore = { str(gameTimeLowScore) };
        saveStrings(lowScoreFile, currentLowScore);
      }

      currentState = State.ENDSCREEN;
      setupStart();
    }


    //Settings Text
    text = new String[]{
      "SETTINGS",
      "",
      "R > Restart",
      "M > Menue",
    };
    TextBlock.display(text, generallMargin, generallMargin);

    //Debug Text
    text = new String[]{
      "PLAYER SMALL",
      "",
      "ANGLE " + betaAngles[0],
      "SPEED " + playerSpeed[0],
      "ABILITY USE " + abilityCounter[0],
      "SHAKE " + shakeState[0],
      "X " + player[0].x,
      "Y " + player[0].y,
      "",
      "PLAYER BIG",
      "",
      "Speed " + betaAngles[1],
      "ABILITY USE " + abilityCounter[1],
      "SHAKE " + shakeState[1],
      "X " + player[1].x,
      "Y " + player[1].y,
    };
    TextBlock.display(text, width / 3 * 2, generallMargin);


    break;

    //wen mit BLE Controller gespielt wird
  case PLAY_CONTROLLER:
      
      
    update_background();

    //Timer
    gameTimer = millis() - startTime;

    


    //-----konvertierung von potentiometer input zu angle output relativ zu spieler-----
    potiConvertetAngle[1] = minBetaAngle + (controllerInput_2*potiSteps);

    //hardmode poti angle direkt auf 0 - 360 grad gemaped
    if(hardmode){
      //hardmode
      potiConvertetAngle[0] = minBetaAngle + (controllerInput_1*potiSteps);
    }else{
      //easymode
      potiConvertetAngle[0] = (controllerInput_1*360/940);
    }


    for (int p = 0; p < player.length; p++) {
      ability(p);

      //slow Down Big when shaked controller version
      if (p == 1 && shake[p]>=50) {

        if (shake[p]>=shake_threashold[p]) {
          shake[p] = shake_threashold[p];
        }
        if (potiConvertetAngle[p] > 0.1) {
          potiConvertetAngle[p] -= 2.*shake[p]/shake_threashold[p];
        } else if (potiConvertetAngle[p] < -0.1) {
          potiConvertetAngle[p] += 2.*shake[p]/shake_threashold[p];
        } else {
          potiConvertetAngle[p] = 0.0;
        }
      }

      //---initialisierung von spielern und speed vorgabe--
      player[p].move(playerSpeed[p], potiConvertetAngle[p]);
      player[p].display(backgroundColor, abilityCounter[p], abilityNeeded[p]);

      
     // -----Abilitys------
     
      //player small ability auslösen ab 3
      //wenn shake grösser als shake_threashold dann ability auslösen
       if ((shake[0] >= shake_threashold[0]) && abilityCounter[0]>=3) {
        abilityUse[0] = true;
        abilityCounter[0] -= abilityNeeded[0];
      }
      
      //player big ability auslösen und auf null setzen
      if ((shake[1] >= shake_threashold[1]) && abilityCounter[1]>0) {
        abilityUse[1] = true;
        abilityCounter[1] = 0;
        }
      }
 


    //---Ability Player big Timer---

    if (abilityCounter[1] < abilityCounterCap[1]) {
      if (abilityP2Timer < abilityCooldownP2/8) {
        abilityP2Timer++;
      } else {
        abilityCounter[1]++;
        abilityP2Timer = 0;
      }
    }

    //-----Collectibles------
    if (millis() - collectableSpawnTime[0][1] >= collectableSpawnTime[1][1]) {
      spawnCollectible(1);
      //Next Spawn
      collectableSpawnTime[0][1] = millis();//also update the stored time
      collectableSpawnTime[1][1] = int(random(minSpawnTime, maxSpawnTime));
    }

    //Collectibles
    //displayCollectibles
    for (int i = collectible.size() - 1; i >= 0; i--) {
      Collectible c = collectible.get(i);
      c.display();

      //Colliders
      if (dist(c.xColPos, c.yColPos, player[0].x, player[0].y) < playerSize[0]) {
        collectible.remove(i);
        if (abilityCounter[0] < abilityCounterCap[0]) {
          abilityCounter[0]++;
        }
        startTime += timeSafe * 1000;
      }
    }

    //Enemy Collider
    //Explosion Collider
    if (dist(player[0].x, player[0].y, player[1].x, player[1].y) < playerSize[1] * explosionColliderHitboxFactor) {
      startTime -= timeSafe * 50;
      backgroundColor = (playerColor[1]);
    } else {
      backgroundColor = 255;
    }

    //Game Over Trigger
    if (gameTimer >= gameLength * 1000) {
      println("GAME OVER");
      //----Reset werte----
      
      //Score
      gameTimeScore = millis() - fixedStartTime;
      //Score Longest
      if (gameTimeScore > gameTimeHighScore) {
        gameTimeHighScore = gameTimeScore;
        String[] currentHighScore = { str(gameTimeHighScore) };
        saveStrings(highScoreFile, currentHighScore);
      }
      //Score Shortest
      if (gameTimeScore < gameTimeLowScore) {
        gameTimeLowScore = gameTimeScore;
        String[] currentLowScore = { str(gameTimeLowScore) };
        saveStrings(lowScoreFile, currentLowScore);
      }

      currentState = State.ENDSCREEN;
      setupStart();
    }

    //Debug Text
    text = new String[]{
      "PLAYER SMALL",
      "",
      "ANGLE " + betaAngles[0],
      "SPEED " + playerSpeed[0],
      "ABILITY USE " + abilityCounter[0],
      "SHAKE " + shake[0],
      "X " + player[0].x,
      "Y " + player[0].y,
      "",
      "PLAYER BIG",
      "",
      "Speed " + potiConvertetAngle[1],
      "ABILITY USE " + abilityCounter[1],
      "SHAKE " + shake[1],
      "X " + player[1].x,
      "Y " + player[1].y,
    };
    TextBlock.display(text, width / 3 * 2, generallMargin);

    break;

  case ENDSCREEN:
   //----reset der spielvariablen-------
    for (int p = 0; p < player.length; p++) {
      abilityCounter[p] = 0;
      abilityUse[p]= false;
    }
    //-----reset ability von player Big-----
    ability(1); //führt reset aus
    
    //hitbox wieder klein machen zu 1
        explosionColliderHitboxFactor = 1;
        abilityUse[1] = false;
        explosionExpansion = playerSize[1];
        
        // reset explosionTimer
        explosionDurationTimer = explosionDuration;
    
    
    //----- screen handler------
    ScreenTimer = millis() - startScreenTime;
    if (ScreenTimer / 1000 > ScreenTimerSeconds) {
      ScreenTimerSeconds++;
    }

    println(ScreenTimerSeconds);

    backgroundColor = playerColor[1];
    Background.display(width/2, height/2, screenLength, ScreenTimerSeconds * 1000);

    textAlign(CENTER);
    fill(255);
    textFont (titleFont);
    textSize(60);
    text("SURVIVED", width/2, height/4);
    textSize(250);
    text(int(gameTimeScore / 1000) + " s", width/2, height/4+220);
    textSize(60);
    text("LONGEST AVOIDENCE", width/4, height - (height/4));
    text(int(gameTimeHighScore / 1000) + " s", width/4, height - (height/4)+80);
    text("FASTEST HUNT", width/4*3, height - (height/4));
    text(int(gameTimeLowScore / 1000) + " s", width/4*3, height - (height/4)+80);
    textFont (mainFont);

    if (ScreenTimer >= screenLength * 1000) {
      println("RUN AGAIN");
      currentState = State.MAIN_MENUE;
      setupStart();
    }

    text = new String[]{
      "GAME OVER",
      "",
      "",
      "",
    };
    TextBlock.display(text, generallMargin, generallMargin);

    break;
  }
}

//–––
//Controller Input Function
//–––

void startBluetoothBridge() {
  // Starte einen neuen Thread, damit die while-Schleife das Hauptprogramm nicht blockiert
  Thread bleThread = new Thread(new Runnable() {
    public void run() {
      try {
        System.out.println("Starte Python BLE-Brücke im Hintergrund...");
        String scriptPath = sketchPath("ble_reader.py");
        ProcessBuilder pb = new ProcessBuilder("/Library/Frameworks/Python.framework/Versions/3.14/bin/python3", scriptPath);
        pb.redirectErrorStream(true);
        Process process = pb.start();

        BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String line;

        while ((line = reader.readLine()) != null) {
          if (line.startsWith("DATA:")) {
            String xiaoSignal = line.substring(5);
            if (!(xiaoSignal.isEmpty())) {
              String[] myArray = xiaoSignal.split(",");

              // Sicherheitscheck: Verhindert Abstürze, falls mal ein kaputter String ankommt
              if (myArray.length >= 3) {
                String controllerIndex = myArray[0];

                switch (controllerIndex) {
                case "1":
                  poti_value_1 = myArray[1];
                  shake_value_1 = myArray[2];
                  System.out.println("Controller 1 (klein) -> Poti: " + poti_value_1 + " | Shake: " + shake_value_1);
                  break;
                case "2":
                  poti_value_2 = myArray[1];
                  shake_value_2 = myArray[2];
                  System.out.println("Controller 2 (groß) -> Poti: " + poti_value_2 + " | Shake: " + shake_value_2);
                  break;
                default:
                  System.out.println("Unbekannte Controller-ID: " + controllerIndex);
                  break;
                }
              }
            }
          } else if (line.startsWith("STATUS:")) {
            System.out.println("BLE-System: " + line.substring(7));
          } else {
            System.out.println("Log: " + line);
          }
        }
      }
      catch (Exception e) {
        System.out.println("Fehler in der BLE-Brücke: " + e.getMessage());
        e.printStackTrace();
      }
    }
  }
  );

  // Starte den Thread
  bleThread.start();
}

//––
//Key Inputs
//––

//-------UI StartScreen-------------
void keyPressed() {
  //Choose BLECONTROLLER or KEYBOARD for game
  //p = 80
  if (currentState == State.MAIN_MENUE) {
    if (keyCode == 80) {
      setupStart();
      currentState = State.PLAY_CONTROLLER;
    }

    for (int p = 0; p < player.length; p++) {
      //Is shaking
      if (keyCode == playerKeyInputs[p][2]) {
        isShaking[p] = true;
      }
    }
  }

  //Restart Button
  if (keyCode == 82) {
    setupStart();
  }

  if (keyCode == 77) {
    shakeState[0] = shakeCap[0]-1;
    shakeState[1] = shakeCap[1]-1;
    currentState = State.MAIN_MENUE;
  }

  //Gameplay Keyboard Inputs
  //nur, wenn mit Keyboard gespielt wird
  if (currentState == State.PLAY_KEYBOARD) {

    for (int p = 0; p < player.length; p++) {
      if (keyCode == playerKeyInputs[p][0] && abilityUse[p] == false) {
        if (p == 1) {
          isShaking[p] = false;
        }
        if (betaAngles[p] < maxBetaAngle) {
          betaAngles[p] += increaseSteps[p];
        } else {
          betaAngles[p] = maxBetaAngle;
        }
      }

      if (keyCode == playerKeyInputs[p][1] && abilityUse[p] == false) {
        if (p == 1) {
          isShaking[p] = false;
        }
        if (betaAngles[p] > minBetaAngle) {
          betaAngles[p] -= increaseSteps[p];
        } else {
          betaAngles[p] = minBetaAngle;
        }
      }

      //Is shaking
      if (keyCode == playerKeyInputs[p][2] && abilityCounter[p] > 0 && abilityCounter[p] >= abilityNeeded[p] ) {
        isShaking[p] = true;
      }
    }
  }
}

void keyReleased() {
  for (int p = 0; p < player.length; p++) {
    if (keyCode == playerKeyInputs[p][2]) {
      isShaking[p] = false;
    }
  }
}

void shake() {
  for (int p = 0; p < player.length; p++) {
    //slow Down Big when shaked
    if (p == 1 && isShaking[p] && !shakeCooldown[p] && abilityCounter[p] == abilityCounterCap[p]) {
      if (betaAngles[p] > 0.1) {
        betaAngles[p] -= 0.02;
      } else if (betaAngles[p] < -0.1) {
        betaAngles[p] += 0.02;
      } else {
        betaAngles[p] = 0.0;
      }
    }
    //Execute
    if (p == 0) {
      shakeState[p] += isShaking[p] && !shakeCooldown[p] ? 1 : -1;
      shakeState[p] = constrain(shakeState[p], 0, shakeCap[p]);
      if (shakeState[p] == shakeCap[p] && abilityCounter[p] > 0) {
        shakeCooldown[p] = true;
        abilityUse[p] = true;
        if (abilityCounter[p] != 0) {
          abilityCounter[p] -= abilityNeeded[p];
        }
      }
    } else if (abilityCounter[p] == abilityCounterCap[p]) {
      shakeState[p] += isShaking[p] && !shakeCooldown[p] ? 1 : -100;
      shakeState[p] = constrain(shakeState[p], 0, shakeCap[p]);
      if (shakeState[p] == shakeCap[p] && abilityCounter[p] == abilityCounterCap[p]) {
        shakeCooldown[p] = true;
        abilityUse[p] = true;
        if (abilityCounter[p] != 0) {
          abilityCounter[p] = 0;
        }
      }
    }

    if (shakeCooldown[p] && shakeState[p] <= 0 && !isShaking[p]) {
      shakeCooldown[p] = false;
    }
  }
}

float explosionExpansion = playerSize[0];
float explosionDuration = 255;
float explosionDurationTimer = explosionDuration;

void ability(int p) {
  //Plyer Small – Speed Up
  if (p == 0) {
    if (abilityUse[p]) {
      if (playerSpeed[p] >= 0.02) {
        playerSpeed[p] -= 0.01;
      } else {
        abilityUse[p] = false;
      }
    } else {
      if (playerSpeed[p] <= playerSpeedAbs[p]) {
        playerSpeed[p] += 0.01;
      }
    }
  }

  //Plyer Big – Expload
  if (p == 1) {
    if (abilityUse[p]) {
      if (explosionDurationTimer > 0) {
        explosionColliderHitboxFactor = 6; //Hitbox
        if (explosionExpansion <= height/1.5) {
          explosionExpansion += 75;
        }
        explosionDurationTimer -= 3;
        player[p].explosion(explosionExpansion, explosionDurationTimer, explosionDuration);
      } else {
        //hitbox wieder klein machen zu 1
        explosionColliderHitboxFactor = 1;
        abilityUse[p] = false;
        explosionExpansion = playerSize[1];
        
        // reset explosionTimer
        explosionDurationTimer = explosionDuration;
      }
    }
  }
}

void spawnCollectible(int collType) {

  if (collType == 0) {
    //spawnSpiek
    int edgePosNumber = int(random(4));
    if (edgePosNumber == 0) {
      collectible.add(new SpikeCollectible(random(width), playerSize[1]/3, playerColor[0]));
    } else if (edgePosNumber == 1) {
      collectible.add(new SpikeCollectible(random(width), height - playerSize[1]/3, playerColor[0]));
    } else if (edgePosNumber == 2) {
      collectible.add(new SpikeCollectible(playerSize[1]/3, random(height), playerColor[0]));
    } else {
      collectible.add(new SpikeCollectible(width - playerSize[1]/3, random(height), playerColor[0]));
    };
  } else if (collType == 1) {
    //spawnSpeed
    collectible.add(new SpeedCollectible(random(playerSize[1]*2, width-playerSize[1]*2), random(playerSize[1]*2, height-playerSize[1]*2), playerColor[0]));
  } else if (collType == 2) {
    //spawnShield
  }
}

void spawnCollectableText() {
  textAlign(LEFT);
  textSize(20);
  fill(0, 255);
  text(timeSafe, 100, 100);
}

void update_background() {
  //Background
  float BackgroundOffsetX;
  float BackgroundOffsetY;
  color backColor;

  if ((gameLength + gameTimer)/1000 > gameLength/2) {
    BackgroundOffsetX = (player[1].x)/4;
    BackgroundOffsetY = (player[1].y)/4;
    backColor = #ed4d0e;
  } else {
    BackgroundOffsetX = (player[0].x)/4;
    BackgroundOffsetY = (player[0].y)/4;
    backColor = #000000;
  }

  Background.display(width/2 - width/8 + BackgroundOffsetX, height/2  - height/8 + BackgroundOffsetY, gameLength, gameTimer);
}

float fadeSize = 0;
float fadeMultiplicator = 0.001;

boolean fadeIn() {

  if (fadeIn_key) {
    if (fadeSize < 100) {
      fadeSize += fadeMultiplicator;
      fadeMultiplicator *= 1.1;
    } else {
      fadeSize = 0;
      fadeMultiplicator = 0.001;
      setupStart();
      fadeIn_key = false;
      return true;
    }
  }
  if (fadeIn_controller) {
    if (fadeSize < 100) {
      fadeSize += fadeMultiplicator;
      fadeMultiplicator *= 1.1;
    } else {
      fadeSize = 0;
      fadeMultiplicator = 0.001;
      setupStart();
      fadeIn_controller = false;
      return true;
    }
  }

  fill(255);
  noStroke();
  circle(width/2, height/2, width/100*fadeSize);

  return false;
}
