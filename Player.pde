class Player {
  
  //color
  int colR;
  int colG;
  int colB;
  float xPos;
  float yPos;
  float playerSize;
  float betaAngle;
  //int yDirection = 0;
  //int xDirection = 0;
  float globAngle;
  
 Player(color r, color g, color b, float size, float startPosX, float startPosY) {
    colR = r;
    colG = g;
    colB = b; 
    xPos = startPosX;
    yPos = startPosY;
    playerSize = size;
    if (startPosX > width / 2){
      betaAngle = -90;
      }
     else {
       betaAngle = 90;
     }
  }
  
  void move (float speed, float angle) {
    globAngle = angle;
    betaAngle += angle;
    //Movement
    if(xPos < width-playerSize){
      xPos += (Math.sin(betaAngle*Math.PI/180))/speed;
    } else {
      xPos -= 0.1;
    }
    yPos += (Math.cos(betaAngle*Math.PI/180))/speed;
    
    if (betaAngle >=360){
      betaAngle -= 360;
    }
     
    println("x " + xPos + " y " + yPos);
  }

  void display () {
    pushMatrix();
    noStroke();
    translate(xPos, yPos);
    rotate(radians(-betaAngle));
    circle(0, playerSize, playerSize);
    //fill(playerColor);
    for (int i = 0; i < 6; i = i+1) {
      color playerColor = color(colR, colG, colB, 255 - (10 * i));
      fill(playerColor);
      circle(i * random(3), playerSize / sqrt(i + 1), playerSize / sqrt(i + 1));
    }
    popMatrix();
  }
}
