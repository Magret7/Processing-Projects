class modelObject{
  PShape model;
  PVector pos;
  PVector speed;
  float size, speedChange;
  color modelColor;
  float rotationY = 0;
  float rotationZ = PI;
  
  modelObject(PVector startPos, PVector speedNew, float speedChangeNew, float sizeNew, color modelColorNew, String modelName) {
    pos = startPos;
    speed = speedNew;
    speedChange = speedChangeNew;
    size = sizeNew;
    modelColor = modelColorNew;
    model = loadShape(modelName);
  }
  
  void onDraw(){
    pushMatrix();
    fill(modelColor);
    translate(pos.x, pos.y, pos.z);
    rotateY(rotationY);
    rotateZ(rotationZ);
    scale(size);
    shape(model);
    popMatrix();
    
    pos = new PVector(pos.x + speed.x, pos.y + speed.y, pos.z + speed.z);
  }
}
