class Ship extends modelObject{
  
  float smokeTimer;
  float timeElapsed = 0;
  color smokeColor;
  
  Ship(PVector startPos, PVector speedNew, float speedChangeNew, float sizeNew, color modelColorNew, String modelName, float smokeTimerNew, color smokeColorNew){
    super(startPos, speedNew, speedChangeNew, sizeNew, modelColorNew, modelName);
    smokeTimer = smokeTimerNew;
    smokeColor = smokeColorNew;
  }
  
  void onDraw(){
    super.onDraw();
    
    rotationY += 0.05;
    speed = new PVector(speed.x + random(-speedChange, speedChange), speed.y, speed.z + random(-speedChange, speedChange));
  }
  
  Smoke exhaust(){
    if(timeElapsed > smokeTimer){
      timeElapsed = 0;
      
      PVector newSmokePos = new PVector(pos.x, pos.y + 75, pos.z);
      PVector newSmokeSpeed = new PVector(0, 2, 0);
      return new Smoke(newSmokePos, newSmokeSpeed, 0, 30f, smokeColor, "Smoke.obj", 2f);
    }
    timeElapsed += 0.1f;
    return null;
  }
}
