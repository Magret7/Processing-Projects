PVector planetPos;
PVector planetSpeed;
Moon m;

Stars[] star = new Stars[1000];
Sun sun;

ShipSpawner shipSpawner;
ArrayList<Ship> ships = new ArrayList<Ship>();

void setup() {
  size(1920, 1080, P3D);
  
  //Add Planets
  planetPos = new PVector(width * 0.25f, height * 0.25f, -100);
  planetSpeed = new PVector(0.5, 0.5, 0);
  m = new Moon(planetPos, planetSpeed, 50, 30, 20);
  
  sun = new Sun(width * 0.5f, height * 0.5f, width * 0.08f);
  
  //Add Stars
  for(int i=0; i< star.length; i++)
  {
    // Setting up random starting x and y positions
    float x = random(-width * 0.5f, width * 1.5f);
    float y = random(-height * 0.5f, height * 1.5f);
    // Setting up random radius
    int radius = int(random(3));
    
    star[i] = new Stars(x, y, radius);
  }
  
  //Add ShipSpawner
  shipSpawner = new ShipSpawner(15, 30, new PVector(width * 0.5f, height * 0.4f, 0), width * 0.125f);
}

void draw() {
  background(0); 
  
  //Display Sun and Stars
  for(int i=0; i< star.length; i++)
  {
    star[i].display();
  }
  
  sun.display();
  
  //Display Planets
  lightSpecular(250, 250, 250);
  spotLight(250, 250, 250, width/2, height/2, 200, 0, 0, -1, PI, 1);

  m.display();
  m.move();
  
  //Display Ship
  shipSpawner.onDraw();
}
