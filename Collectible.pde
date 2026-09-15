class Collectible {

  void display() {
  };
  
}

class SpikeCollectible extends Collectible {

  void display() {
    noStroke();
    translate(200, 200);
    fill(#000000);
    circle(0, 0, 10);
  }
}
