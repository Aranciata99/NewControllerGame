class Player {
  
  color playerColor;
  
 Player(color c) {
    playerColor = c;
   
  }
  
  float playerSize = 20;
  //color playerColor = #FF704F;
  float xPos = 0;
  float yPos = 0;
  
  float betaAngle = 0;
  
  int yDirection = 0;
  int xDirection = 0;
  float globAngle;
  void move (float speed, float angle) {
    globAngle = angle;
    betaAngle += angle;
    xPos += (Math.sin(betaAngle*Math.PI/180))/speed;
    yPos += (Math.cos(betaAngle*Math.PI/180))/speed;
    
    if (betaAngle >=360){
      betaAngle -= 360;
    }
     println("Angle " + angle);
    
  }

  void display () {
    //display Player
    noStroke();
    fill(playerColor); 
    translate(xPos, yPos);
    rotate(radians(-betaAngle));
    rect(0, 0, playerSize, playerSize);
     fill(0);
     rotate(radians(45));
    rect(playerSize/2,playerSize/2,playerSize/sqrt(2),playerSize/sqrt(2));
    translate(-xPos, -yPos);
    rotate(radians(-45));
    rotate(radians(betaAngle));
  }
}
