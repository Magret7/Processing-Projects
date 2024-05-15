class ShipSpawner{
  PVector sunCenter;
  float intervalMin, intervalMax, sunRadius;
  float intervalCurrent = 0;
  float timeElapsed = 0;
  ArrayList<Ship> ships = new ArrayList<Ship>();
  ArrayList<Smoke> smokes = new ArrayList<Smoke>();
  
  ShipSpawner(float intervalMinNew, float intervalMaxNew, PVector sunCenterNew, float sunRadiusNew){
    intervalMin = intervalMinNew;
    intervalMax = intervalMaxNew;
    sunCenter = sunCenterNew;
    sunRadius = sunRadiusNew;
  }
  
  void onDraw(){
    //Decide whether to spawn a new ship
    if(timeElapsed > intervalCurrent){
      timeElapsed = 0;
      intervalCurrent = random(intervalMin, intervalMax);
      
      color smokeColorNew = color(random(120, 250), random(120, 250), random(120, 250));
      color shipColorNew = color(70, 80, 100);
      PVector startPosition = new PVector(random(width * 0.25f, width * 0.75f), height + 200, 100);
      PVector startSpeed = new PVector(0, -12, 0);
      ships.add(new Ship(startPosition, startSpeed, 0.3f, 50f, shipColorNew, "SpaceShip.obj", 1, smokeColorNew));
    }
    else{
      timeElapsed += 0.1f;
    }
    
    //Draw Ships
    for(int i = 0; i < ships.size(); i++){
      Ship currentShip = ships.get(i);
      currentShip.onDraw();
      
      Smoke newSmoke = currentShip.exhaust();
      if(newSmoke != null){
        smokes.add(newSmoke);
      }
      
      if(dist(currentShip.pos.x, currentShip.pos.y, sunCenter.x, sunCenter.y) < sunRadius && currentShip.speed.y < 0){
        //print("hitting sun");
        currentShip.speed = new PVector(currentShip.speed.x, -currentShip.speed.y, currentShip.speed.z);
        currentShip.rotationZ = 0;
      }
      
      if(currentShip.pos.y < -200 && currentShip.pos.y > height + 200){
        ships.remove(currentShip);
      }
    }
    
    //Draw Smoke
    for(int i = 0; i < smokes.size(); i++){
      Smoke currentSmoke = smokes.get(i);
      currentSmoke.onDraw();
      
      if(!currentSmoke.living()){
        smokes.remove(currentSmoke);
      }
    }
  }
}
