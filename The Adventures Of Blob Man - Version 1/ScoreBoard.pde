class ScoreBoard{
  float radius, xpos, ypos;
  Camera camera;
  int hp = 0;
  int score = 0;
  Level[] levels;
  int[] points;
  Entity player;
  int levelCurrent;
  PFont pixelFont = createFont("PublicPixel-z84yD.ttf", 12);
  
  ScoreBoard(float radius, Camera camera, Level[] levels, Entity player, int levelCurrent) {
    this.radius = radius;
    this.camera = camera;
    this.levels = levels;
    this.player = player;
    this.levelCurrent = levelCurrent;
    points = new int[levels.length];
  }
  
  void display() {
    //coins = 10 pts
    //others soon
    for(int i = 0; i < levels.length; i++) {
      if(i == levelCurrent){
        points[i] = levels[i].coinsCollected * 10;
      }
    }
    //if(levelCurrent < levels.length){
    //  points[levelCurrent] = levels[levelCurrent].coinsCollected * 10;
    //}
    score = 0;
    for(int p: points){
      score += p;
    }
    
    int tempHealth = 0;
    for(int i = 0; i < player.components.size(); i++) {
      Component newP = player.components.get(i);
      if(newP.getClass() == Player.class) {
        Player p = (Player)newP;
        tempHealth += p.healthCurrent;
      }
    }
    hp = tempHealth;
    
    fill(color(224, 194, 156));
    stroke(color(183, 142, 92));
    strokeWeight(5);
    
    xpos = camera.position.x + width/2 - radius;
    ypos = camera.position.y + height/2 - radius/4;
    rect(xpos, ypos, radius*2, radius/2, radius/8, radius/8, 0, radius/8);
    
    fill(0);
    textFont(pixelFont);
    text("HP:" + nf(hp, 1), xpos-27*radius/32, ypos+radius/16);
    text("Score:" + nf(score, 2), xpos-5*radius/16, ypos+radius/16);
    
    println(score);
    println(hp);
    printArray(points);
  }
  
  void updateCam(Camera cameraNew, int levelCurrentNew, Level[] levelsNew, Entity playerNew){
    camera = cameraNew;
    levelCurrent = levelCurrentNew;
    levels = levelsNew;
    player = playerNew;
  }
}
