class Planet {
  PVector pos, speed;
  float size;
  float theta = 0;
  color pcolor = color(random(50, 250), random(50, 150), random(100, 200)); //random planet color
  
  Planet() {
    pos = new PVector(0, 0, 0);
    speed = new PVector(0, 0, 0);
    size = 0;
  }
  
  Planet(PVector pos, PVector speed, float size) {
    this.pos = pos;
    this.speed = speed;
    this.size = size;
  }
  
  void display() {
    noStroke();
    
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateY(theta);
    fill(pcolor);
    shininess(2);
    sphere(size);
    popMatrix();
    
    theta += PI/100;
 
    if (pos.x > width + size*3) {
      pos.x = -size*3;
    }
    if (pos.y > height + size*3) {
      pos.y = -size*3;
    }
  }
  
  void move() {
    pos.x += speed.x;
    pos.y += speed.y;
    pos.z += speed.z;
  }
}
