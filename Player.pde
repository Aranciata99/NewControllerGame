class Player {

  void move (float speed, float angle) {
  };
  void display (color bg, int abilityCount, int needed) {
  }
  void explosion (float expansion, float durationTime, float duration) {
  }

  //Positions
  float x = 0;
  float y = 0;
  int spikeCount = 50;
  float[] spikePos = new float[spikeCount*3];
  
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
    xPos = width/2;
    yPos = height/2;
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
    } else {
      if(hardmode){
        xPos += (Math.sin(betaAngle*Math.PI/180))/speed;
      }else{
        xPos += (Math.sin(angle*Math.PI/180))/speed;
      }
    }

    if (yPos > height - playerSize/2) {
      yPos -= 0.1;
    } else if (yPos < 0 + playerSize/2) {
      yPos += 0.1;
    } else {
      
      
      if(hardmode){
        //hardmode
         yPos += (Math.cos(betaAngle*Math.PI/180))/speed;
      }else{
        //easymode
         yPos += (Math.cos(angle*Math.PI/180))/speed;
      }
    }

    if (betaAngle >=360) {
      betaAngle -= 360;
    }
  }

  float rotation;

  void display (color backgroundColor, int abilityCount, int needed) {
    pushMatrix();
    noStroke();
    translate(xPos, yPos);
    //hardmode kopfausrichtung
    if(hardmode){
      //hardmode
      rotate(radians(-betaAngle));
    }else{
      //easymode
      rotate(radians(-globAngle));
    }
    
    fill(playerColor);
    circle(0, 0, playerSize);
    //Head
    fill(backgroundColor);
    circle(0, 7, playerSize / 3);
    popMatrix();

    rotation -= 0.03;

    for (int i = 1; i < abilityCount + 1; i++) {
      pushMatrix();
      stroke(0);
      if (abilityCount < needed){
        strokeWeight(0);
      } else {
        strokeWeight(5);
      }
      translate(xPos, yPos);
      fill(playerColor);
      rotate(((360 / 3) * i) - rotation);
      circle(0, 35, playerSize / 7);
      popMatrix();
    }
    
    x = xPos;
    y = yPos;
    
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
  //Spikes
  float[] randomSpikePos = new float[spikeCount];
  float[] randomSpikeLength = new float[spikeCount];


  int track;
  int direction;

  PlayerBig(color c, float size) {
    //Colors
    playerColor = c;
    //Position
    int[][] startPos = { {0, height/2}, {width/2, 0}, {width, height/2}, {width/2, height} };
    int random = (int) random(4);
    xPos = startPos[random][0];
    yPos = startPos[random][1];
    track = random;
    playerSize = size;

    for (int i = 1; i < spikeCount; i++) {
      randomSpikePos[i] = ((360 / spikeCount) * i + 1) + random(-2, 2);
      randomSpikeLength[i] = random(0, 400);
    }
  }

  void move (float speed, float angle) {

    localSpeed = angle;

    if (localSpeed >= 0) {
      direction = 1;
    } else {
      direction = -1;
    }

    if (track == 0) {
      xPos = 0;
      yPos += localSpeed * 5;
      if (yPos < 0) {
        track ++;
      } else if (yPos > height) {
        track = 3;
      }
    } else if (track == 1) {
      yPos = 0;
      xPos -= localSpeed * 5;
      if (xPos > width) {
        track ++;
      } else if (xPos < 0) {
        track --;
      }
    } else if (track == 2) {
      xPos = width;
      yPos -= localSpeed * 5;
      if (yPos > height) {
        track ++;
      } else if (yPos < 0) {
        track --;
      }
    } else if (track == 3) {
      yPos = height;
      xPos += localSpeed * 5;
      if (xPos < 0) {
        track = 0;
      } else if (xPos > width) {
        track --;
      }
    }
  }

  void display (color backgroundColor, int abilityCount, int needed) {
    pushMatrix();
    translate(xPos, yPos);
    noStroke();
    float rotation = (360 / 4) * (track + 1);
    rotate(radians(rotation + 180 + (localSpeed * 25)));
    fill(playerColor);
    circle(0, 0, playerSize);
    fill(backgroundColor);
    circle(0, 25, playerSize / 5);
    popMatrix();

    for (int i = 1; i < abilityCount + 1; i++) {
      pushMatrix();
      translate(xPos, yPos);
      fill(playerColor);
      stroke(playerColor);
      if (abilityCount < needed){
        strokeWeight(0);
      } else {
        strokeWeight(5);
      }
      rotate(radians(rotation + 90 + (20*i)));
      circle(0, 50, playerSize / 15);
      popMatrix();
    }

    x = xPos;
    y = yPos;
  }

  float spikesAnimation;

  void explosion (float expansion, float durationTime, float duration) {

    //strokeWeight(1);
    stroke(playerColor);
    noStroke();
    //fill(color(237, 77, 14, 0));
    //circle(xPos, yPos, expansion*1.4);
    //Spikes Settings
    strokeCap(SQUARE);
    stroke(playerColor);
    //Spikes Display
    for (int i = 1; i < spikeCount + 1; i++) {
      pushMatrix();
      strokeWeight(0);
      translate(xPos, yPos);
      rotate(radians(randomSpikePos[i-1]));
      spikesAnimation = expansion / 2 + randomSpikeLength[i- 1];
      fill(color(237, 77, 14, durationTime*2));
      circle(spikesAnimation/2, spikesAnimation/2, 15);
      circle(spikesAnimation/3, spikesAnimation/3, 12);
      circle(spikesAnimation/4, spikesAnimation/4, 8);
      popMatrix();
    }
    //println(durationTime);
  }
}
