class Player {
  
  color playerColor;
  float xPos;
  float yPos;
  float playerSize;
  float betaAngle;
  //int yDirection = 0;
  //int xDirection = 0;
  float globAngle;
  
 Player(color c, float startPosX, float startPosY) {
    playerColor = c;
    xPos = startPosX;
    yPos = startPosY;
    playerSize = 40;
    betaAngle = 0;
  }
  
  
  void move (float speed, float angle) {
    globAngle = angle;
    betaAngle += angle;
    xPos += (Math.sin(betaAngle*Math.PI/180))/speed;
    yPos += (Math.cos(betaAngle*Math.PI/180))/speed;
    
    if (betaAngle >=360){
      betaAngle -= 360;
    }
     //println("Angle " + angle);
  }

  void display () {
    pushMatrix();
    noStroke();
    fill(playerColor);
    translate(xPos, yPos);
    rotate(radians(-betaAngle));
    rect(0, 0, playerSize, playerSize);
    fill(0);
    rotate(radians(45));
    rect(
      playerSize / 2,
      playerSize / 2,
      playerSize / sqrt(2),
      playerSize / sqrt(2)
    );
    popMatrix();
  }
}
