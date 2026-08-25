class Player {
  
  float playerSize = 20;
  color playerColor = #FF704F;
  float xPos = width/2;
  float yPos = 0;
  
  float betaAngle = 0;
  
  int yDirection = 0;
  int xDirection = 0;
  
  
  void move (float speed, float angle) {
    
    betaAngle += angle;
    
    xPos += (Math.sin(betaAngle*Math.PI/180))/speed;
    yPos += (Math.cos(betaAngle*Math.PI/180))/speed;
    
    if (betaAngle >=360){
      betaAngle -= 360;
    }
     println("Angle " + betaAngle);
    
  }

  void display () {
    //display Player
    noStroke();
    fill(playerColor);
    rect(xPos, yPos, playerSize, playerSize);
  }
}
