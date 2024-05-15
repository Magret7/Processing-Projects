class Level extends Component{
  PImage map;
  int coinsInLevel;
  int coinsCollected;
  
  Level(int index){
    map = loadImage("map" + index + ".png");
  }
  
  void onDraw(){
    if(coinsCollected >= coinsInLevel){
      levelCurrent++;
      if(levelCurrent < levels.length){
        reload();
      }
    }
  }
}
