class Collectible {
  
  int strokeWeight = 2;

  void display() {
  };
  
}

class SpeedCollectible extends Collectible {
  
  float xPos;
  float yPos;
  float finalSize = 13;
  float size = 600;
  float opacity = 2;
  color col;
  
  SpeedCollectible(float x, float y, color c){
    
    xPos = x;
    yPos = y;
    col = c;
  
  }

  void display() {
    strokeWeight(strokeWeight);
    stroke(col);
    if (size > finalSize){
      size -= 10;
      opacity *= 1.1;
    } else {
      noStroke();
      size = finalSize;
      opacity = 255;
    }
    fill(col, opacity);
    circle(xPos, yPos, size);
  }
  
  
}

class SpikeCollectible extends Collectible {
  
  float xPos;
  float yPos;
  float finalSize = 13;
  float size = 600;
  float opacity = 2;
  color col;
  
  SpikeCollectible(float x, float y, color c){
    
    xPos = x;
    yPos = y;
    col = c;
  
  }

  void display() {
    strokeWeight(strokeWeight);
    stroke(col);
    if (size > finalSize){
      size -= 10;
      opacity *= 1.1;
    } else {
      noStroke();
      size = finalSize;
      opacity = 255;
    }
    fill(col, opacity);
    circle(xPos, yPos, size);
  }
}
