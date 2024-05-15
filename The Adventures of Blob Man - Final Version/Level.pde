class Level extends Component{
  String name;
  PImage map;
  int coinsNeeded;
  private int coinsCollected;
  boolean complete;
  SoundFile music;
  //modes: 0 = menu, 1 = normal level
  int levelMode;
  int transitionTimeElapsed = 0, transitionTimeMax = 600;
  boolean beginLevelTransition = false;
  int targetLevel, index;
  
  Level(String name, int index, String mapName, int coinsNeeded, String musicName, int levelMode){
    map = loadImage(mapName + ".png");
    this.coinsNeeded = coinsNeeded;
    if(musicName != null){
      this.music = sounds[findSound.get(musicName)];
    }
    this.levelMode = levelMode;
    this.name = name;
    this.index = index;
    targetLevel = this.index+1;
  }
  
  void onReload(){
    music.stop();
    coinsCollected = 0;
    complete = false;
    music.loop();
    scoreBoard.notification(name, 600);
    if(index > 0){
      PrintWriter autoSave = createWriter("save.txt"); 
      autoSave.println(index);
      autoSave.flush();
      autoSave.close();
      //print(index + ", " + targetLevel);
    }
  }
  
  void onDraw(){
    if(select.down){
      progressLevel(targetLevel);
    }
    if(beginLevelTransition){
      if(transitionTimeElapsed > 40){
        levelCurrent = targetLevel;
        reload();
      }
      else{
        transitionTimeElapsed++;
      }
    }
  }
  
  void progressLevel(int targetLevel){
    this.targetLevel = targetLevel;
    if(complete){
      if(targetLevel < levels.length){
        transition.play(transitionTimeMax, 0);
        beginLevelTransition = true;
      }
    }
  }
  
  void incrementCoins(int coinIncrease){
    coinsCollected += coinIncrease;
    if(coinsCollected >= coinsNeeded && !complete){
      complete = true;
      sounds[findSound.get("PowerUp")].play();
      scoreBoard.notification("Press e to go to the next level! \nOr collect more coins!", -99);
    }
  }
}
