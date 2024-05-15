class Animation{
  String name;
  ArrayList<PImage> frames = new ArrayList<PImage>();
  int currentFrame;
  float timeElapsed, frameDelay;
  
  Animation(String name, float frameDelay){
    this.name = name;
    this.frameDelay = frameDelay;
    int i = 0;
    while(true){
      if(findSprite.hasKey(name + i)){
        frames.add(sprites[findSprite.get(name + i)]);
        i++;
      }
      else{
        break;
      }
    }
  }
  
  PImage progress(){
    if(timeElapsed < frameDelay){
      timeElapsed++;
    }
    else{
      timeElapsed = 0;
      if(currentFrame < frames.size()-1){
        currentFrame++;
      }
      else{
        currentFrame = 0;
      }
    }
    return frames.get(currentFrame);
  }
}
