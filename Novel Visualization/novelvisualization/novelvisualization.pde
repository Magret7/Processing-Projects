color[] colors = {color(20, 8, 160), color(224, 7, 14), color(211, 211, 203)};
/*blue, red, beige (roughly based on the colors of the French flag
  since we used The Three Musketeers as our novel*/
String[] words;
PFont cfont;
String print = ""; //keeps track of our list of words to be drawn to the canvas
int lines = 0; //tracks which line is being drawn currently

void setup() {
  background(75);
  words = loadStrings("uniquewords.txt");
  cfont = loadFont("Constantia-20.vlw");
  textFont(cfont);
  textMode(LEFT);
  size(700, 600);
}

void draw() {
  createWords();
}

void createWords() {
  while (lines < 27) { //continues to add words to the canvas as long as it isnt full
    int r_index = int(random(words.length)); //randomizes index and color
    color r_color = colors[r_index % 3];
    String[] split = split(print, "\n"); //splits the text based on line
    if (textWidth(split[lines] + "   " + words[r_index]) < 700) {
      fill(r_color);
      print += words[r_index];
      print += " ";
      text(words[r_index], textWidth(split[lines] + "   "), 20 + lines*22); 
      //prints the random word with the random color in the current line if it fits
    }
    else {
      fill(r_color);
      lines += 1;
      print += "\n ";
      split = split(print, "\n");
      print += words[r_index];
      if (lines < 27) {
        text(words[r_index], textWidth("   "), 20 + lines*22);
      }
      //prints the random word on the next line if it doesnt fit on the current line
    }
  }  
  
  if (mousePressed == true) {
    background(75);
    print = "";
    lines = 0;
  }
  // resets/redraws the canvas when you click the mouse
}
