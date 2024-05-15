class Transition extends Component{
  float startPos = -width*2f, endPos = width*2f;
  float timeElapsed = 0, maxDuration;
  boolean on, transitioning;
  
  void onDraw(){
    if(transitioning){
      if(timeElapsed < maxDuration){
        noStroke();
        fill(0);
        //print(sin(timeElapsed/maxDuration * 2) + "\n");
        rect(0, 0, width * 3f, height * 3f);
        translate(lerp(cameraMain.position.x + startPos, cameraMain.position.x + endPos, timeElapsed/maxDuration), cameraMain.position.y);
        //print(lerp(cameraMain.position.x + startPos, cameraMain.position.x + lerp(startPos, endPos, 0.5f), timeElapsed/maxDuration) + "\n");
        //rotate(10);
        timeElapsed++;
      }
      else{
        transitioning = false;
      }
    }
  }
  
  void play(float maxDuration, float startTime){
    timeElapsed = startTime;
    this.maxDuration = maxDuration;
    transitioning = true;
    if(cameraMain != null){
      push();
      translate(cameraMain.position.x + startPos, cameraMain.position.y);
      pop();
    }
  }
}
