ArrayList<Entity> topLevelEntities;
Entity terrainContainer;
Entity itemContainer;
Entity enemyContainer;
ArrayList<ArrayList<Collider>> collisionLayers;
ArrayList<Collider> colliders0;
ArrayList<Collider> colliders1;
ArrayList<Collider> colliders2;
Entity playerCharacter;
Camera cameraMain;
float gravity = 0.75;
float terminalVelocity = 20;
Control jump = new Control("jump");
Control left = new Control("left");
Control right = new Control("right");
Control[] controls = {jump, left, right};
PImage[] sprites = new PImage[100];
IntDict findSprite = new IntDict();
String[] spriteNames = {
  "terrain", "dirt", "dirtR", "dirtL", "dirtD", "dirtU", "hardTop", "player_standing0", 
  "bgTile", "player_running0", "player_running1", "player_running2", "player_running3", 
  "coin0", "coin1", "coin2", "coin3", "coin4", "coin5", "coin6", "coin7", "player_jumping0",
  "obstacle"
};
PGraphics pg;
PGraphics mapRender;
int lastKeyPressed;
Level level0, level1, level2;
Level[] levels;
int levelCurrent;
ScoreBoard score;

void setup(){
  size(720, 488);
  imageMode(CENTER);
  rectMode(CENTER);
  /*
  java.io.File folder = new java.io.File(dataPath(""));
  String[] spriteNames = folder.list();
  println(spriteNames.length + " jpg files in specified directory");
  for(int i = 0; i < spriteNames.length; i++) {
    addSprite(spriteNames[i], i);
  }
  */
  
  reload();
  score = new ScoreBoard(100, cameraMain, levels, playerCharacter, levelCurrent);
}

void reload(){
  for(int i = 0; i < spriteNames.length; i++){
    addSprite(spriteNames[i], i);
  }
  
  topLevelEntities = new ArrayList<Entity>();
  collisionLayers = new ArrayList<ArrayList<Collider>>();
  collisionLayers.add(colliders0 = new ArrayList<Collider>());
  collisionLayers.add(colliders1 = new ArrayList<Collider>());
  collisionLayers.add(colliders2 = new ArrayList<Collider>());
  terrainContainer = new Entity(new PVector(0, 0), 0, null, null, 0, true);
  itemContainer = new Entity(new PVector(0, 0), 0, null, null, 0, true);
  enemyContainer = new Entity(new PVector(0, 0), 0, null, null, 0, true);
  levels = new Level[3];
  levels[levelCurrent] = new Level(levelCurrent);
  Entity currentLevelEntity = new Entity(new PVector(0, 0), 0, null, null, 0, true);
  currentLevelEntity.addComponent(levels[levelCurrent]);
  
  //draw map
  for(int i = 0; i < levels[levelCurrent].map.width; i++){
    for(int j = 0; j < levels[levelCurrent].map.height; j++){
      Entity newEntity;
      switch(levels[levelCurrent].map.get(i, j)){
        case #81c042:
          newEntity = new Entity(new PVector(i * 32, j * 32), 0, terrainContainer, "terrain", 0, true);
          newEntity.addComponent(new Collider(new PVector(16, 16), false, 0));
          newEntity.addComponent(new Collider(new PVector(16, 16), false, 1));
          terrainContainer.children.add(newEntity);
          break;
        case #ffcdcd:
          newEntity = new Entity(new PVector(i * 32, j * 32), 0, terrainContainer, "bgTile", 0, true);
          terrainContainer.children.add(newEntity);
          break;
        case #d84e4e:
          newEntity = new Entity(new PVector(i * 32, j * 32), 0, terrainContainer, "hardTop", 0, true);
          newEntity.addComponent(new Collider(new PVector(16, 16), false, 0));
          newEntity.addComponent(new Collider(new PVector(16, 16), false, 1));
          terrainContainer.children.add(newEntity);
          break;
        case #ae3b3b:
          newEntity = new Entity(new PVector(i * 32, j * 32), 0, terrainContainer, chooseTile("dirt", i, j, "D", "L", "R", "U"), 0, true);
          newEntity.addComponent(new Collider(new PVector(16, 16), false, 0));
          newEntity.addComponent(new Collider(new PVector(16, 16), false, 1));
          terrainContainer.children.add(newEntity);
          break;
        case #f4c100:
          newEntity = new Entity(new PVector(i * 32, j * 32), 0, itemContainer, "coin0", 0, false);
          newEntity.addComponent(new Collider(new PVector(16, 16), true, 2));
          newEntity.addComponent(new Coin());
          itemContainer.children.add(newEntity);
          break;
        case #ff1ebe:
          newEntity = new Entity(new PVector(i * 32, j * 32), 0, enemyContainer, "obstacle", 0, false);
          newEntity.addComponent(new Collider(new PVector(16, 16), true, 0));
          newEntity.addComponent(new Collider(new PVector(16, 16), false, 1));
          newEntity.addComponent(new Spikeball());
          enemyContainer.children.add(newEntity);
          break;
        case #00ffc3:
          //add player to scene
          playerCharacter = new Entity(new PVector(i * 32, j * 32), 0, null, "player_standing0", 1, false);
          playerCharacter.addComponent(new Player(1.25f, 14f, 6f, 3, 40));
          playerCharacter.addComponent(new Collider(new PVector(14, 16), true, 2));
          playerCharacter.addComponent(new Collider(new PVector(14, 16), false, 0));
          break;
        case #FFFFFF:
          //print("empty");
          break;
      }
    }
  }
  
  //draw static map
  mapRender = createGraphics(levels[levelCurrent].map.width * 32, levels[levelCurrent].map.height * 32);
  mapRender.beginDraw();
    mapRender.background(60, 20, 40);
    for(int i = 0; i < terrainContainer.children.size(); i++){
      mapRender.image(terrainContainer.children.get(i).sprite, terrainContainer.children.get(i).position.x, terrainContainer.children.get(i).position.y);
    }
  mapRender.endDraw();
  
  for(int i = 0; i < topLevelEntities.size(); i++){
    topLevelEntities.get(i).created();
  }
   
  cameraMain = new Camera(new PVector(0, 0), playerCharacter, 0.25f, 1f, 1f);
}

void draw(){
  background(0);
  
  cameraMain.onDraw();
  imageMode(CORNER);
    image(mapRender, -16, -16);
  imageMode(CENTER);
  
  for(int i = 0; i < topLevelEntities.size(); i++){
    topLevelEntities.get(i).onDraw();
  }
  
  for(int i = 0; i < controls.length; i++){
    controls[i].OnDraw();
  }
  score.display();
  score.updateCam(cameraMain, levelCurrent, levels, playerCharacter);
}

//////////////INPUTS///////////////
void keyPressed(){
  if(key != lastKeyPressed){
    lastKeyPressed = key;
    Control chosenControl = null;
    if (key == CODED) {
      switch(keyCode) {
        case LEFT: 
          chosenControl = left;
          break;
        case RIGHT: 
          chosenControl = right;
          break;
        default:
          //println("None");
          break;
      }
    }
    else{
      switch(key) {
        case 'a':
          chosenControl = left;
          break;
        case 'd':
          chosenControl = right;
          break;
        case 'r':
          setup();
          break;
        case ' ':
          chosenControl = jump;
          break;
        default:
          //println("None");
          break;
      }
    }
    
    if(chosenControl != null){
      chosenControl.Down();
    }
  }
}

void keyReleased(){
  Control chosenControl = null;
  if(key == lastKeyPressed){
    lastKeyPressed = 0;
  }
  
  if (key == CODED) {
    switch(keyCode) {
      case LEFT: 
        chosenControl = left;
        break;
      case RIGHT: 
        chosenControl = right;
        break;
      default:
        //println("None");
        break;
    }
  }
  else{
    switch(key) {
      case 'a':
        chosenControl = left;
        break;
      case 'd':
        chosenControl = right;
        break;
      case ' ':
        chosenControl = jump;
        break;
      default:
        //println("None");
        break;
    }
  }
  
  if(chosenControl != null){
    chosenControl.Up();
  }
}

String chooseTile(String tileName, int tilePositionX, int tilePositionY, String down, String left, String right, String up){
  String chosenTile;
  
  if(tilePositionY - 1 > 0 && checkEmpty(levels[levelCurrent].map.get(tilePositionX, tilePositionY - 1))){chosenTile = tileName + "U"; return chosenTile;}
  if(tilePositionY + 1 < levels[levelCurrent].map.height && checkEmpty(levels[levelCurrent].map.get(tilePositionX, tilePositionY + 1))){chosenTile = tileName + "D"; return chosenTile;}
  if(tilePositionX - 1 > 0 && checkEmpty(levels[levelCurrent].map.get(tilePositionX - 1, tilePositionY))){chosenTile = tileName + "L"; return chosenTile;}
  if(tilePositionX + 1 < levels[levelCurrent].map.width && checkEmpty(levels[levelCurrent].map.get(tilePositionX + 1, tilePositionY))){chosenTile = tileName + "R"; return chosenTile;}
  else{chosenTile = tileName;}
  return chosenTile;
}

boolean checkEmpty(color checkedTile){
  return checkedTile == #FFFFFF || checkedTile == #ffcdcd;
}

void addSprite(String name, int index){
  findSprite.set(name, index); 
  sprites[index] = loadImage(name + ".png");
}
