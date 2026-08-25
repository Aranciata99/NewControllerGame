import java.io.BufferedReader;
import java.io.InputStreamReader;

//Classes
Player Player1;

//Player Values
float playerSpeed = 0.15;

//Imput Numbers
String line;
String poti_value = "110";
String shake_value = "10";

//Angle
float betaAngle = 0.0;

//Placeholder Key Input Controll
float increaseSteps = 1;
float maxBetaAngle = 1.5;
float minBetaAngle = -1.5;

//–––
//Start Function – nur einmal am anfang
//–––

void setup() {
  
  //Classes
  Player1 = new Player();
  
  //Window Setup
  size(1600, 900);
   
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
  
  //Convert Input String to Int
  int controllerInput = 0;
  int shake = 0;
  if (!poti_value.isEmpty()){
    controllerInput = Integer.parseInt(poti_value);
    shake = Integer.parseInt(shake_value);
  }
  
  
  //Draw Test Circle
  fill(#000000);
  controllerInput *= 10;
  
  Player1.move(playerSpeed, betaAngle);
  Player1.display();
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
     println("Angle " + betaAngle);
    
    }
    
