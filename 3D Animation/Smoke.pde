class Smoke extends modelObject{
  float timeElapsed, lifeTime, sizeMax;
  
  Smoke(PVector startPos, PVector speedNew, float speedChangeNew, float sizeNew, color modelColorNew, String modelName, float lifeTimeNew){
    super(startPos, speedNew, speedChangeNew, sizeNew, modelColorNew, modelName);
    
    sizeMax = sizeNew;
    lifeTime = lifeTimeNew;
  }
  
  void onDraw(){
    super.onDraw();
    
    timeElapsed += 0.1f;
    rotationZ += 0.5;
    size = lerp(sizeMax, 0, timeElapsed/lifeTime);
  }
  
  boolean living(){
    return timeElapsed < lifeTime;
  }
}
