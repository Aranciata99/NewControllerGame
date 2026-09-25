class Background {

  void display (float xPos, float yPos, int time, float gameTime) {
    int gridSize = 25;
    float lineCount = (width/gridSize + height/gridSize)*2;
    noFill();
    strokeWeight(0.8);
    int x = 0;
    int y = height;
    for (int l = 0; l < lineCount; l++) {
      if (l*((time/lineCount)*1000) > gameTime) {
        stroke(0);
      } else {
        stroke(#ed4d0e);
      }

      if (l < lineCount/2) {
        if (x < width) {
          x += gridSize;
        } else if (y > 0) {
          y -= gridSize;
        }
      } else {
        if (x > 0) {
          x -= gridSize;
        } else {
          y += gridSize;
        }
      }

      line(x, y, xPos, yPos);
    }
  }
}
