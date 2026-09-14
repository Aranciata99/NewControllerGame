class Player {
  
  void move (float speed, float angle) {};
  void display (color bg, int dashes) {}
  void explosion (float expansion, float duration) {}
  
  
}

class PlayerSmall extends Player {
  
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
  
  float rotation;

  void display (color bg, int dashes) {
    pushMatrix();
    noStroke();
    translate(xPos, yPos);
    rotate(radians(-betaAngle));
    fill(playerColor);
    circle(0, 0, playerSize);
    //Head
    fill(bg);
    circle(0, 10, playerSize / 3);
    popMatrix();
    
    rotation -= 0.03;
    
    for (int i = 1; i < dashes + 1; i++) {
      pushMatrix();
      translate(xPos, yPos);
      fill(playerColor);
      rotate(((360 / 3) * i) - rotation);
      circle(0, 35, playerSize / 5);
      popMatrix();
    }
    
  }
}

class PlayerBig extends Player {
  
  //color
  color playerColor;
  //Positions
  float xPos;
  float yPos;
  float playerSize;
  float betaAngle;
  //int yDirection = 0;
  //int xDirection = 0;
  float localSpeed;
  
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
    
    println(random);
  }
  
  void move (float speed, float angle) {
    
    localSpeed = angle;
    
    if (localSpeed >= 0){
      direction = 1;
    } else {
      direction = -1;
    } 
    
    if (track == 0){
      xPos = 0;
      yPos += localSpeed * 5;
      if (yPos < 0){
        track ++;
      } else if (yPos > height){
        track = 3;
      }
    } else if (track == 1) {
      yPos = 0;
      xPos -= localSpeed * 5;
      if (xPos > width){
        track ++;
      } else if (xPos < 0){
        track --;
      }
    } else if (track == 2) {
      xPos = width;
      yPos -= localSpeed * 5;
      if (yPos > height){
        track ++;
      } else if (yPos < 0){
        track --;
      }
    } else if (track == 3) {
      yPos = height;
      xPos += localSpeed * 5;
      if (xPos < 0){
        track = 0;
      } else if (xPos > width){
        track --;
      }
    }
  }

  void display (color bg, int dashes) {
    pushMatrix();
    translate(xPos, yPos);
    noStroke();
    float rotation = (360 / 4) * (track + 1);
    rotate(radians(rotation + 180 + (localSpeed * 25)));
    fill(playerColor);
    circle(0, 0, playerSize);
    fill(bg);
    circle(0, 25, playerSize / 5);
    popMatrix();
  }
  
  void explosion (float expansion, float duration){
    fill(color(237, 77, 14, duration));
    circle(xPos, yPos, expansion);
  }
}
