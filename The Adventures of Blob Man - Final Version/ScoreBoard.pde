class ScoreBoard extends Component{
  float radius, xpos, ypos;
  Camera camera;
  int hp = 0;
  int score = 0;
  int[] points;
  Player player;
  float notificationOffsetCurrent, notificationOffsetMax = 100;
  String notificationMessage;
  int notificationDuration;
  
  ScoreBoard(float radius) {
    this.radius = radius;
  }
  
  void onCreated(){
    points = new int[levels.length];
    player = (Player)playerCharacter.GetComponent(Player.class);
  }
  
  void onDraw() {
    if(levels[levelCurrent].levelMode == 1){
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
      hp = player.healthCurrent;
      
      
      if(notificationDuration > -99){
        if(notificationDuration < 1){
          notificationMessage = "";
        }
        else{
          notificationDuration--;
        }
      }
      
      if(notificationMessage != ""){
        if(notificationOffsetCurrent < notificationOffsetMax){
          notificationOffsetCurrent = lerp(notificationOffsetCurrent, notificationOffsetMax, 0.075f);
        }
        new TextBox(notificationMessage, new PVector(500, 60), new PVector(0, - height/2 + notificationOffsetCurrent), false).render();
      }
      else if(notificationOffsetCurrent > -30){
        notificationOffsetCurrent = lerp(notificationOffsetCurrent, -31f, 0.075f);
        new TextBox(notificationMessage, new PVector(500, 60), new PVector(0, - height/2 + notificationOffsetCurrent), false).render();
      }
      xpos = width/2 - radius;
      ypos = height/2 - radius/4;
      new TextBox("HP:" + nf(hp, 1) + " Score:" + nf(score, 2), new PVector(radius*2, radius/2), new PVector(xpos, ypos), false).render();
      
      //println(score);
      //println(hp);
      //printArray(points);
    }
  }
  
  void notification(String message, int duration){
    notificationMessage = message;
    notificationDuration = duration;
  }
}
