import java.io.BufferedReader;
import java.io.InputStreamReader;


//Classes
Player Player1;
//Player Player2;

//controller
int controllerInput = 0;
int shake = 0;

//Player Values
float playerSpeed = 0.5;

//Imput Numbers
String line;
String poti_value = "110";
String shake_value = "10";

//Game Sate
boolean keyboardEnable = false;
boolean controllerEnable = false;

//Angle
float betaAngle = 0.0;

//Placeholder Key Input Controll
float increaseSteps = 1;
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

State currentState;
//–––
//Start Function – nur einmal am anfang
//–––

void setup() {
   rectMode(CENTER);
  //Classes
  Player1 = new Player(#FF704F);
  //Player2 = new Player(#FF70FF);
  
  //Window Setup
  size(1600, 900);
  
  currentState = State.CONTROLLER_SELECT;
  //screensetting
  surface.setResizable(true);
  //Start Input Script
  new Thread(() -> {
    startBluetoothBridge();
  }).start();
}

//–––
//Draw Function – 60 mal in der Sekunde
//–––

void draw() {
   //Draw Background
  background(#FFFFFF);
  
  switch(currentState) {
    //startfenster
    //menue frage controller o oder p
  case CONTROLLER_SELECT:
  textAlign(LEFT);
  drawType(width * 0.1);
    break;
    
    // wenn mit Keyboard gespielt wird
   case PLAY_KEYBOARD:
    Player1.move(playerSpeed, betaAngle);
    Player1.display();
    //Player2.move(playerSpeed, betaAngle);
    //Player2.display();
    break;
    
    //wen mit BLE Controller gespielt wird
  case PLAY_CONTROLLER:
  if (!poti_value.isEmpty()){
    //Convert Input String to Int
    controllerInput = Integer.parseInt(poti_value);
    shake = Integer.parseInt(shake_value);
  }
    //konvertierung von potentiometer input zu angle output
   potiConvertetAngle = minBetaAngle + (controllerInput*potiSteps);
   Player1.move(playerSpeed, potiConvertetAngle);
   Player1.display();
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
                    if(!(xiaoSignal.isEmpty())){
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
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    
    //Key Input for Testing
    void keyPressed() {
      //p = 80
      //o = 79
      //Choose BLECONTROLLER or KEYBOARD for game
      if(currentState == State.CONTROLLER_SELECT){
      if(keyCode == 80){
        currentState = State.PLAY_CONTROLLER;
      }
      if(keyCode == 79){
        currentState = State.PLAY_KEYBOARD;
      }
      }
      
      //nur, wenn mit Keyboard gespielt wird
      if(currentState == State.PLAY_KEYBOARD){
       if(keyCode == 38){
         if (betaAngle < maxBetaAngle){
           betaAngle += increaseSteps;
         } else {
           betaAngle = maxBetaAngle;
         }
        } 
        
        if(keyCode == 40){
          if (betaAngle > minBetaAngle){
            betaAngle -= increaseSteps;
          } else {
            betaAngle = minBetaAngle;
          }
      }
       //println("Angle " + betaAngle);
        }
    }
    
    void drawType(float x) {
      textSize(100);
      fill(0);
      text("p für BLE_Controller", x, 300);
      text("o für Keyboard", x, 400);
    }
