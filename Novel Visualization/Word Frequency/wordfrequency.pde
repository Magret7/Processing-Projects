String[] textLines;
String[] maxFrequency;
color startColor = color(214, 30, 55);
color endColor = color(36, 88, 209);


void setup() {
  size(1280, 720);
  textLines = loadStrings("wordfrequency.txt");
  int setHeight = 2 * textLines.length;
  windowResize(1280, setHeight);
  maxFrequency = textLines[textLines.length-1].split(":");
  noStroke();
  rectMode(CENTER);
}

void draw() {
  background(color(255));
  
  for(int i = 0; i < textLines.length; i++){
    String[] splitText = textLines[i].split(":");
    fill(lerpColor(startColor, endColor, float(i)/textLines.length));
    float rectWidth = map(float(splitText[0]), 0, float(maxFrequency[0]), 0, width - 10);
    rect(lerp(mouseX, width/2, float(i)/textLines.length), i * 2, rectWidth, 10);
  }
}
