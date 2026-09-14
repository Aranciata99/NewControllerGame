class TextBlock {

  float lineHeight = 18;
  float fontSize = 15;
  color textColor = 0;

  void display (String[] text, float x, float y) {
    textAlign(LEFT);
    textSize(fontSize);
    fill(textColor);
    for (int i = 0; i < text.length; i++) {
      text(text[i], x, y + (i * lineHeight));
    }
  }
}
