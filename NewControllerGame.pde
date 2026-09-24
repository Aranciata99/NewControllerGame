/* Current To-Dos
 
 Basil
 
 Alex
 
 */

import java.io.BufferedReader;
import java.io.InputStreamReader;

//Classes
Player[] player = new Player[2];

//Angles
float[] betaAngles = { 0.0, 0.0 };

//controller
int [] shake = {0, 0};
int controllerInput_2;
int controllerInput_1 = 0;
boolean[] abilityCooldownInactive_controller =  {true, true};

//Player Values
//Abilities
int[] abilityCounter = { 3, 2 };
int[] abilityCounterCap = { 10, 8};
//Shaking
boolean[] isShaking = { false, false };
boolean[] shakeCooldown = { false, false };
boolean[] abilityUse = { false, false };
int[] shakeState = { 0, 0 };
int[] shakeCap = { 150, 100 };
//Speed
float[] playerSpeedAbs = { 0.25, 0 };
float[] playerSpeed = { playerSpeedAbs[0], playerSpeedAbs[1] };
//Size
float[] playerSize = { 40, 80 };
//Colors
color[] playerColor = { 0, #ed4d0e }; //#828282
//Inputs
int[][] playerKeyInputs = {{ 38 /*UP*/, 40 /*DOWN*/, 16 /*SHIFT R*/}, { 83 /*W*/, 87 /*S*/, 32 /*SPACE*/}};

//Placeholder Key Input Controll
float[] increaseSteps = { 0.5, 0.5 };
float maxBetaAngle = 2;
float minBetaAngle = -2;

//Imput Numbers
String line;
String controllerIndex ="1";
String poti_value_1 = "110";
String shake_value_1 = "10";

String poti_value_2 = "0", shake_value_2 = "0";

//Collectibles
ArrayList<Collectible> collectible = new ArrayList<Collectible>();

//Envoirenment
color backgroundColor = #FFFFFF; //#002138
Background Background;

//Spawn Timer
int[][] collectableSpawnTime = {{0, 0, 0}, {0, 0, 0}}; //Current, Next
int minSpawnTime = 1000;
int maxSpawnTime = 200000;

//Game Sate
boolean keyboardEnable = false;
boolean controllerEnable = false;

//Game Time
int gameLength = 20;


float potiSteps = maxBetaAngle/(940/2);
float [] potiConvertetAngle = {0.0, 0.0};
//UI
TextBlock TextBlock;
String[] text;

//Sate machine
public enum State {
  CONTROLLER_SELECT,
    PLAY_KEYBOARD,
    PLAY_CONTROLLER
}

//UI

//Text
float generallMargin = 30;
String[] textBlock;

State currentState;

//–––
//Start Function – nur einmal am anfang
//–––

void setup() {
  rectMode(CENTER);
  //Instantiate Classes
  setupStart();

  //Window Setup
  size(1400, 900);

  //Store current Time
  for (int i = 0; i < collectableSpawnTime[0].length; i++) {
    collectableSpawnTime[0][i] = millis();
    collectableSpawnTime[1][i] = int(random(minSpawnTime, maxSpawnTime));
  }

  //State Setup
  //currentState = State.CONTROLLER_SELECT;
  currentState = State.PLAY_KEYBOARD;
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
  
  abilityCounter[0] = 3;
  abilityCounter[1] = 3;
}

//–––
//Draw Function – 60 mal in der Sekunde
//–––

void draw() {
  //Draw Background
  background(backgroundColor);

  switch(currentState) {
    //startfenster
    //menue frage controller o oder p
  case CONTROLLER_SELECT:

    text = new String[]{
      "START GAME",
      "",
      "O > Keyboard",
      "P > BLE_Controller",
    };
    TextBlock.display(text, generallMargin, generallMargin);

    break;

    // wenn mit Keyboard gespielt wird
  case PLAY_KEYBOARD:

    //Background
    float BackgroundOffsetX;
    float BackgroundOffsetY;
    color backColor;
    
    if ((gameLength - millis()/1000) < gameLength/2) {
      BackgroundOffsetX = (player[1].x[1])/4;
      BackgroundOffsetY = (player[1].y[1])/4;
      backColor = #ed4d0e;
    } else {
      BackgroundOffsetX = (player[0].x[0])/4;
      BackgroundOffsetY = (player[0].y[0])/4;
      backColor = #000000;
    }

    Background.display(width/2 - width/8 + BackgroundOffsetX, height/2  - height/8 + BackgroundOffsetY, gameLength - millis()/1000, backColor);

    println(player[1].y[1]);

    //Display Player
    for (int p = 0; p < player.length; p++) {
      ability(p);
      player[p].move(playerSpeed[p], betaAngles[p]);
      player[p].display(backgroundColor, abilityCounter[p]);
    }

    shake();

    //Collectibles
    //Timer
    for (int c = 0; c < collectableSpawnTime[0].length; c++) {
      if (millis() - collectableSpawnTime[0][c] >= collectableSpawnTime[1][c]) {
        spawnCollectible(c);
        //Next Spawn
        collectableSpawnTime[0][c] = millis();//also update the stored time
        collectableSpawnTime[1][c] = int(random(minSpawnTime, maxSpawnTime));
      }
    };

    //Collectibles
    //displayCollectibles
    for (Collectible c : collectible) {
      c.display();
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
      "X " + player[0].x[0],
      "Y " + player[0].y[0],
      "",
      "PLAYER BIG",
      "",
      "Speed " + betaAngles[1],
      "ABILITY USE " + abilityCounter[1],
      "SHAKE " + shakeState[1],
      "X " + player[1].x[1],
      "Y " + player[1].y[1],
    };
    TextBlock.display(text, width / 3 * 2, generallMargin);


    break;

    //wen mit BLE Controller gespielt wird
  case PLAY_CONTROLLER:
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

    //konvertierung von potentiometer input zu angle output
    potiConvertetAngle[0] = minBetaAngle + (controllerInput_1*potiSteps);
    potiConvertetAngle[1] = minBetaAngle + (controllerInput_2*potiSteps);
    for (int p = 0; p < player.length; p++) {
      //also wenn cooldown aktiv ist
      if (abilityCooldownInactive_controller[p]==false) {
        if (shake[p]<=30) {
          abilityCooldownInactive_controller[p]=true;
        }
      }
      ability(p);
      player[p].move(playerSpeed[p], potiConvertetAngle[p]);
      player[p].display(backgroundColor, abilityCounter[p]);

      //wenn shake grösser als 200 dann ability auslösen
      if ((shake[p] >=200)&& abilityCooldownInactive_controller[p]) {
        abilityUse[p] = true;

        //cooldwon wird gestartet
        abilityCooldownInactive_controller[p] = false;

        if (abilityCounter[p] != 0) {
          abilityCounter[p]--;
        }
      }
    }



    for (int c = 0; c < collectableSpawnTime[0].length; c++) {
      if (millis() - collectableSpawnTime[0][c] >= collectableSpawnTime[1][c]) {
        spawnCollectible(c);
        //Next Spawn
        collectableSpawnTime[0][c] = millis();//also update the stored time
        collectableSpawnTime[1][c] = int(random(minSpawnTime, maxSpawnTime));
      }
    };

    //Collectibles
    //displayCollectibles
    for (Collectible c : collectible) {
      c.display();
    }

    //Debug Text
    text = new String[]{
      "PLAYER SMALL",
      "",
      "ANGLE " + betaAngles[0],
      "SPEED " + playerSpeed[0],
      "ABILITY USE " + abilityCounter[0],
      "SHAKE " + shake[0],
      "X " + player[0].x[0],
      "Y " + player[0].y[0],
      "",
      "PLAYER BIG",
      "",
      "Speed " + betaAngles[1],
      "ABILITY USE " + abilityCounter[1],
      "SHAKE " + shake[1],
      "X " + player[1].x[1],
      "Y " + player[1].y[1],
    };
    TextBlock.display(text, width / 3 * 2, generallMargin);


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

//UI StartScreen
void keyPressed() {
  //p = 80
  //o = 79
  //Choose BLECONTROLLER or KEYBOARD for game
  if (currentState == State.CONTROLLER_SELECT) {
    if (keyCode == 80) {
      currentState = State.PLAY_CONTROLLER;
    }
    if (keyCode == 79) {
      currentState = State.PLAY_KEYBOARD;
    }
  }

  //Restart Button
  if (keyCode == 82) {
    setupStart();
  }

  if (keyCode == 77) {
    currentState = State.CONTROLLER_SELECT;
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
      if (keyCode == playerKeyInputs[p][2] && abilityCounter[p] > 0) {
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
    shakeState[p] += isShaking[p] && !shakeCooldown[p] ? 1 : -1;
    shakeState[p] = constrain(shakeState[p], 0, shakeCap[p]);
    //slow Down Big when shaked
    if (p == 1 && isShaking[p] && !shakeCooldown[p]) {
      if (betaAngles[p] > 0.1) {
        betaAngles[p] -= 0.02;
      } else if (betaAngles[p] < -0.1) {
        betaAngles[p] += 0.02;
      } else {
        betaAngles[p] = 0.0;
      }
    }
    //Execute
    if (shakeState[p] == shakeCap[p] && abilityCounter[0] > 0) {
      shakeCooldown[p] = true;
      abilityUse[p] = true;
      if (abilityCounter[p] != 0) {
        abilityCounter[p]--;
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

  //Plyer Small – Expload
  if (p == 1) {
    if (abilityUse[p]) {
      if (explosionDurationTimer > 0) {
        if (explosionExpansion <= height/1.5) {
          explosionExpansion += 75;
        }
        explosionDurationTimer -= 3;
        player[p].explosion(explosionExpansion, explosionDurationTimer, explosionDuration);
      } else {
        abilityUse[p] = false;
        explosionExpansion = playerSize[0];
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
