class PlayerBig {
  
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
  
  int track;
  int direction; 
  
 PlayerBig(color c, float size) {
    //Colors
    playerColor = c;
    //Position
    int[][] startPos = { {0,height/2}, {width/2, 0}, {width,height/2}, {width/2,height} };
    int random = (int) random(4);
    xPos = startPos[random][0];
    yPos = startPos[random][1];
    track = random;
    playerSize = size;
    
  }
  
  void move (float speed) {
    
    if (speed >= 0){
      direction = 1;
    } else {
      direction = -1;
    } 
    
    if (track == 0){
      xPos = 0;
      yPos += speed * 5;
      if (yPos < 0){
        track ++;
      } else if (yPos > height){
        track = 3;
      }
    } else if (track == 1) {
      yPos = 0;
      xPos -= speed * 5;
      if (xPos > width){
        track ++;
      } else if (xPos < 0){
        track --;
      }
    } else if (track == 2) {
      xPos = width;
      yPos -= speed * 5;
      if (yPos > height){
        track ++;
      } else if (yPos < 0){
        track --;
      }
    } else if (track == 3) {
      yPos = height;
      xPos += speed * 5;
      if (xPos < 0){
        track = 0;
      } else if (xPos > width){
        track --;
      }
    }
      //println(track);
  }

  void display () {
    noStroke();
    fill(playerColor);
    circle(xPos, yPos, playerSize);
  }
}
