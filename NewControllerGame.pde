import java.io.BufferedReader;
import java.io.InputStreamReader;

//Imput Numbers
String line;
String controllerInputString = "10";

//–––
//Start Function – nur einmal am anfang
//–––

void setup() {
  
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
  if (!controllerInputString.isEmpty()){
    controllerInput = Integer.parseInt(controllerInputString);
  }
  
  //Draw Test Circle
  fill(#000000);
  controllerInput *= 10;
  circle(width/2, height/2, controllerInput);
}

//–––
//Controller Input Function
//–––

void startBluetoothBridge() {
        try {
            System.out.println("Starte Python BLE-Brücke...");
            // Absoluten Pfad zur Datei im Sketch-Ordner bauen
            String scriptPath = sketchPath("ble_reader.py");

            ProcessBuilder pb = new ProcessBuilder("python3", scriptPath);
            pb.redirectErrorStream(true);
            Process process = pb.start();

            // Wir lesen live den Output von Python
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            
            while ((line = reader.readLine()) != null) {
                if (line.startsWith("DATA:")) {
                    // HIER KOMMEN DEINE SIGNALE AN!
                    String xiaoSignal = line.substring(5);
                    controllerInputString = xiaoSignal; 
                    System.out.println("JAVA EMPFÄNGT SIGNAL: " + xiaoSignal);
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
