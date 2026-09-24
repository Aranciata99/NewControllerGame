class Background {

  void display (float xPos, float yPos, int time, color col) {
    int gridSize = 25;
    noFill();
    stroke(col); //#ed4d0e
    strokeWeight(0.8);
    for (int x = 0; x <= width; x += gridSize) {
      line(x, 0, xPos, yPos);
      line(x, height, xPos, yPos);
    }
    for (int y = 0; y <= height; y += gridSize) {
      line(0, y, xPos, yPos);
      line(width, y, xPos, yPos);
    }
    
    //Timer
    textAlign(CENTER);
    textSize(20);
    fill(col);
    text(time, 50, 50);
    text(time, 50, height-50);
    text(time, width-50, height-50);
    text(time, width-50, 50);
  }
}
