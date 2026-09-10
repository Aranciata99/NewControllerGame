class PlayerSmall {
  
  //color
  color playerColor;
  //Positions
  float xPos;
  float yPos;
  float playerSize;
  float betaAngle;
  //int yDirection = 0;
  //int xDirection = 0;
  float globAngle;
  
 PlayerSmall(color c, float size) {
    //Colors
    playerColor = c;
    //Position
    xPos = random(playerSize * 2, width - playerSize * 2);
    yPos = random(playerSize * 2, height - playerSize * 2);
    //Immer in die mitte?
    playerSize = size;
    betaAngle = xPos / (width / 360);
  }
  
  void move (float speed, float angle) {
    globAngle = angle;
    betaAngle += angle;
    
    //Movement
    if (xPos > width - playerSize/2) {
    xPos -= 0.1;
    } else if (xPos < 0 + playerSize/2) {
      xPos += 0.1;
    }else {
    xPos += (Math.sin(betaAngle*Math.PI/180))/speed;
    }
    
    if (yPos > height - playerSize/2) {
    yPos -= 0.1;
    } else if (yPos < 0 + playerSize/2) {
      yPos += 0.1;
    }else {
    yPos += (Math.cos(betaAngle*Math.PI/180))/speed;
    }
    
    if (betaAngle >=360){
      betaAngle -= 360;
    }
  }

  void display (color bg) {
    pushMatrix();
    noStroke();
    translate(xPos, yPos);
    rotate(radians(-betaAngle));
    fill(playerColor);
    circle(0, 0, playerSize);
    //Head
    fill(bg);
    circle(0, 12, playerSize / 3);
    popMatrix();
  }
}
