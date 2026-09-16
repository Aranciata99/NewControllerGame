class Player {

  void move (float speed, float angle) {
  };
  void display (color bg, int abilityCount) {
  }
  void explosion (float expansion, float durationTime, float duration) {
  }

  //Positions
  float[] x = {0, 0};
  float[] y = {0, 0};
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
    } else {
      xPos += (Math.sin(betaAngle*Math.PI/180))/speed;
    }

    if (yPos > height - playerSize/2) {
      yPos -= 0.1;
    } else if (yPos < 0 + playerSize/2) {
      yPos += 0.1;
    } else {
      yPos += (Math.cos(betaAngle*Math.PI/180))/speed;
    }

    if (betaAngle >=360) {
      betaAngle -= 360;
    }
  }

  float rotation;

  void display (color backgroundColor, int abilityCount) {
    pushMatrix();
    noStroke();
    translate(xPos, yPos);
    rotate(radians(-betaAngle));
    fill(playerColor);
    circle(0, 0, playerSize);
    //Head
    fill(backgroundColor);
    circle(0, 7, playerSize / 3);
    popMatrix();

    rotation -= 0.03;

    for (int i = 1; i < abilityCount + 1; i++) {
      pushMatrix();
      translate(xPos, yPos);
      fill(playerColor);
      rotate(((360 / 3) * i) - rotation);
      circle(0, 35, playerSize / 4);
      popMatrix();
    }
    
    x[0] = xPos;
    y[0] = yPos;
    
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
  int spikeCount = 50;
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

  void display (color backgroundColor, int abilityCount) {
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
      rotate(radians(rotation + 90 + (20*i)));
      circle(0, 55, playerSize / 7.5);
      popMatrix();
    }

    x[1] = xPos;
    y[1] = yPos;
  }

  float spikesAnimation;

  void explosion (float expansion, float durationTime, float duration) {

    //strokeWeight(1);
    stroke(playerColor);
    noStroke();
    fill(color(237, 77, 14, 0));
    circle(xPos, yPos, expansion * 2);
    //Spikes Settings
    strokeCap(ROUND);
    stroke(playerColor);
    //Spikes Display
    for (int i = 1; i < spikeCount + 1; i++) {
      pushMatrix();
      strokeWeight(6);
      translate(xPos, yPos);
      rotate(radians(randomSpikePos[i-1]));
      spikesAnimation = expansion / 2 + randomSpikeLength[i- 1];
      line(0, 0, spikesAnimation, 0);
      popMatrix();
    }
    println(durationTime);
  }
}
