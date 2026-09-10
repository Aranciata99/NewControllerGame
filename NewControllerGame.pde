/* Current To-Dos
 
 Basil
 – Player 2 on Edge
 
 Alex
 
 */

import java.io.BufferedReader;
import java.io.InputStreamReader;

//Classes
PlayerSmall PlayerSmall;
PlayerBig PlayerBig;

//Angles
float betaAnglePlayerSmall = 0.0;
float betaAnglePlayerBig = 0.0; //Speed

//controller
int controllerInput = 0;
int shake = 0;

//Player Values
//Speed
float playerSpeedSmall = 0.25;
//Size
float playerSizeSmall = 40;
float playerSizeBig = 80;
//Colors
color playerColorSmall = #c9c9c9;
color playerColorBig = #ed4d0e;

//Imput Numbers
String line;
String poti_value = "110";
String shake_value = "10";

//Envoirenment
color backgroundColor = #002138;

//Game Sate
boolean keyboardEnable = false;
boolean controllerEnable = false;

//Placeholder Key Input Controll
float increaseStepsSmall = 0.5;
float increaseStepsBig = 0.5;
float maxBetaAngle = 2;
float minBetaAngle = -2;

float potiSteps = maxBetaAngle/(940/2);
float potiConvertetAngle = 0.0;
//Sate machine
public enum State {
  CONTROLLER_SELECT,
    PLAY_KEYBOARD,
    PLAY_CONTROLLER
}

//UI
float generallMargin = 30;
//Text
float lineHeight = 18;
float fontSize = 15;
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
  size(1600, 900);
  
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
  PlayerSmall = new PlayerSmall(playerColorSmall, playerSizeSmall);
  PlayerBig = new PlayerBig(playerColorBig, playerSizeBig);
  betaAnglePlayerSmall = 0.0;
  betaAnglePlayerBig = 0.0;
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

    //–––
    //Text Block Settings
    textBlock = new String[]{
      "START GAME",
      "",
      "O > Keyboard",
      "P > BLE_Controller",
    };
    drawType(textBlock, generallMargin, generallMargin);

    break;

    // wenn mit Keyboard gespielt wird
  case PLAY_KEYBOARD:
    PlayerSmall.move(playerSpeedSmall, betaAnglePlayerSmall);
    PlayerSmall.display(backgroundColor);
    PlayerBig.move(betaAnglePlayerBig);
    PlayerBig.display();

    //–––
    //Text Block Settings
    textBlock = new String[]{
      "SETTINGS",
      "",
      "R > Restart",
    };
    drawType(textBlock, generallMargin, generallMargin);
    //–––
    //Text Block Settings
    textBlock = new String[]{
      "DEBUG UI",
      "",
      "SMALL PLAYER",
      "Angle " + str(betaAnglePlayerSmall),
      "BIG PLAYER",
      "Angle "+ str(betaAnglePlayerBig),
    };
    drawType(textBlock, width/2, generallMargin);
    //–––


    break;

    //wen mit BLE Controller gespielt wird
  case PLAY_CONTROLLER:
    if (!poti_value.isEmpty()) {
      //Convert Input String to Int
      controllerInput = Integer.parseInt(poti_value);
      shake = Integer.parseInt(shake_value);
    }
    //konvertierung von potentiometer input zu angle output
    potiConvertetAngle = minBetaAngle + (controllerInput*potiSteps);
    PlayerSmall.move(playerSpeedSmall, potiConvertetAngle);
    PlayerSmall.display(backgroundColor);
    break;
  }
}

//–––
//Controller Input Function
//–––

void startBluetoothBridge() {
  try {
    System.out.println("Starte Python BLE-Brücke...");
    // Absoluten Pfad zur Datei im Sketch-Ordner bauen
    String scriptPath = sketchPath("ble_reader.py");
    ProcessBuilder pb = new ProcessBuilder("/Library/Frameworks/Python.framework/Versions/3.14/bin/python3", scriptPath);
    pb.redirectErrorStream(true);
    Process process = pb.start();

    // Wir lesen live den Output von Python
    BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));

    while ((line = reader.readLine()) != null) {
      if (line.startsWith("DATA:")) {
        // HIER KOMMEN DEINE SIGNALE AN!
        String xiaoSignal = line.substring(5);
        if (!(xiaoSignal.isEmpty())) {
          String regex = ","; // trennargument
          String[] myArray = xiaoSignal.split(regex);
          poti_value = myArray[0]; //erster Spalte in poti_value
          shake_value = myArray[1]; // zweite Spalte in shake_value
          System.out.println("Potentiometer: " + poti_value + " Schüttelwert "+ shake_value);
        }
      } else if (line.startsWith("STATUS:")) {
        // Statusmeldungen (Scannen, Verbinden)
        System.out.println("BLE-System: " + line.substring(7));
      } else {
        System.out.println("Log: " + line);
      }
    }
  }
  catch (Exception e) {
    e.printStackTrace();
  }
}

//Key Inputs
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
  //Gameplay Keyboard Inputs
  //nur, wenn mit Keyboard gespielt wird
  if (currentState == State.PLAY_KEYBOARD) {

    //player 2 // Up + Down

    if (keyCode == 38) {
      if (betaAnglePlayerSmall < maxBetaAngle) {
        betaAnglePlayerSmall += increaseStepsSmall;
      } else {
        betaAnglePlayerSmall = maxBetaAngle;
      }
    }

    if (keyCode == 40) {
      if (betaAnglePlayerSmall > minBetaAngle) {
        betaAnglePlayerSmall -= increaseStepsSmall;
      } else {
        betaAnglePlayerSmall = minBetaAngle;
      }
    }

    //player 2 // W + S

    if (keyCode == 83) {
      if (betaAnglePlayerBig < maxBetaAngle) {
        betaAnglePlayerBig += increaseStepsBig;
      } else {
        betaAnglePlayerBig = maxBetaAngle;
      }
    }

    if (keyCode == 87) {
      if (betaAnglePlayerBig > minBetaAngle) {
        betaAnglePlayerBig -= increaseStepsBig;
      } else {
        betaAnglePlayerBig = minBetaAngle;
      }
    }

    //Restart Button
    if (keyCode == 82) {
      setupStart();
    }
  }
}

void drawType(String[] text, float x, float y) {
  textAlign(LEFT);
  textSize(fontSize);
  fill(#FFFFFF);
  for (int i = 0; i < text.length; i++) {
    text(text[i], x, y + (i * lineHeight));
  }
}
