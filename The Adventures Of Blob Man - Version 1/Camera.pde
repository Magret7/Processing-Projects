class Camera{
  PVector position;
  Entity followTarget;
  float followRate;
  float followTargetX, followTargetY;
  
  Camera(PVector position, Entity followTarget, float followRate, float followTargetX, float followTargetY){
    this.position = position;
    this.followTarget = followTarget;
    this.followRate = followRate;
    this.followTargetX = followTargetX;
    this.followTargetY = followTargetY;
  }
  
  void onDraw(){
    translate(-(position.x - width/2) * followTargetX, -(position.y - height/2) * followTargetY);
    position = PVector.lerp(position, followTarget.position, followRate);
  }
}
