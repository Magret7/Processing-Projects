class Stars extends Sun {
  float xRoate, yRoate;
  float frequency = 2;
  float disatance;
  float angle;
  float Rradius = int(random(200, 250));
  
  //PVector center;
  //float angle;
  //float Oradius;
  
  Stars(float x, float y, float r) {
    super(x, y , r);
    
    //center = new PVector(width/2, height/2);
    //PVector point = new PVector(100, 100);
    //float deltaX = center.x - point.x;
    //float deltaY = center.y - point.y;
    //angle = atan2(deltaX, deltaY);
    //Oradius = dist(center.x, center.y, point.x, point.y)/3;
  }
  
 void display() {
    //pushMatrix();
    //fill(255,255,237);
    //translate(position.x, position.y, 0);
    ////translate(width/2, height/2);
    //rotateY(radians(frameCount)/2);
    //rotateZ(radians(frameCount)/2);
    //float pointX = center.x + cos(angle)*Oradius;
    //float pointY = center.y + sin(angle)*Oradius;
    //translate(pointX, 0, pointY);
    //sphere(radius);
    //angle += PI/300;
    //popMatrix();  

    pushMatrix();
    fill(255,255,237);
    translate(position.x, position.y, -500);
    rotateY(frameCount*.02);
    xRoate = sin(radians(angle))*Rradius;
    yRoate = cos(radians(angle))*Rradius;
    translate(xRoate, 0, yRoate);
    sphere(radius);
    angle += frequency;
    popMatrix();  
  }
 
}



  
