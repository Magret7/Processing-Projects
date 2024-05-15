class Moon extends Planet {
  float moonSize, radius;
  float theta = 0;
  color pcolor = color(random(50, 200), random(50, 200), random(50, 200)); //random planet color
  color mcolor = color(random(75, 150)); //random moon color
  
  Moon() {
    moonSize = 0;
    radius = 0;
  }
  
  Moon(PVector pos, PVector speed, float size, float moonSize, float radius) {
    super(pos, speed, size);
    this.moonSize = moonSize;
    this.radius = radius;
  }
  
  void display() {
    noStroke();
    float offset = radius + size + moonSize;
    
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateY(theta/-2);
    fill(pcolor);
    shininess(2);
    sphere(size);//planet
    popMatrix();
    
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateY(theta);
    translate(offset, 0, 0);
    fill(mcolor);
    shininess(25);
    sphere(moonSize);//moon
    popMatrix();
    
    theta += PI/150;
    
    //resets planet position after it goes off-screen
    if (pos.x > width + offset) {
      pos.x = -offset;
    }
    if (pos.y > height + offset) {
      pos.y = -offset;
    }
  }
}
