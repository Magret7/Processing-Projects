class Sun {
  PVector position;
  PVector direction;
  PVector rotaion;
  float radius;

  Sun(float x, float y, float radius) {
    position = new PVector(x, y);
    this.radius = radius;
    direction = new PVector(1, 0);
  }
 
  void display() {
    pushMatrix();
    lights();
    directionalLight(150, 50, 50, 0, -1, 0);
    directionalLight(100, 120, 255, 0, 1, 0);
    ambientLight(30, 30, 30);
    translate(position.x, position.y, 0);
    rotateY(frameCount*.02);
    noStroke();
    fill(253, 184, 19);
    sphere(radius);
    popMatrix();
  }
}
