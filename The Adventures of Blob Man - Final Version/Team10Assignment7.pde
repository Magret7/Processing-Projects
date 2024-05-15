import processing.sound.*;
ArrayList<Entity> topLevelEntities;
Entity terrainContainer;
Entity itemContainer;
Entity enemyContainer;
Entity ui;
Transition transition;
ScoreBoard scoreBoard;
ArrayList<ArrayList<Collider>> collisionLayers;
ArrayList<Collider> colliders0;
ArrayList<Collider> colliders1;
ArrayList<Collider> colliders2;
Entity playerCharacter;
Camera cameraMain;
PFont pixelFont;
float gravity = 0.75;
float terminalVelocity = 20;
Control jump = new Control("jump");
Control left = new Control("left");
Control right = new Control("right");
Control select = new Control("select");
Control leftMouse = new Control("leftMouse");
/////////////////////////////////////////////////////////////////////////////////////////////
Control dash = new Control("dash");
Control[] controls = {jump, left, right, select, leftMouse, dash};
////////////////////////////////////////////////////////////////////////////////////////////////
PImage[] sprites = new PImage[100];
IntDict findSprite = new IntDict();
String[] spriteNames = {
  "terrain", "dirt", "dirtR", "dirtL", "dirtD", "dirtU", "hardTop", "player_standing0", 
  "bgTile", "player_running0", "player_running1", "player_running2", "player_running3", 
  "coin0", "coin1", "coin2", "coin3", "coin4", "coin5", "coin6", "coin7", "player_jumping0",
  "obstacle", "wing0", "bat0", "bat1", "bat2", "bat3", "bat4", "bat5", "bat6", "bat7", "bat8", "bat9",
   "bat10", "bat11", "bat12", "energy0"
};

SoundFile[] sounds = new SoundFile[100];
IntDict findSound = new IntDict();
String[] soundNames = {
  "LevelMusic", "Coin", "PowerUp", "Jump", "Hurt", "Footstep0", "Footstep1", "Footstep2"
};
PGraphics pg;
PGraphics mapRender;
int lastKeyPressed;
Level level0, level1, level2;
Level[] levels;
///Change this to skip to any level for editing;
int levelCurrent;
ScoreBoard score;
MainMenu mainMenu;

// Particle Effects
ParticleSystem particleSystem;

void setup(){
  size(720, 488);
  imageMode(CENTER);
  rectMode(CENTER);
  textAlign(CENTER);
  pixelFont = createFont("PublicPixel-z84yD.ttf", 12);
  textFont(pixelFont);
  
  for(int i = 0; i < spriteNames.length; i++){
    addSprite(spriteNames[i], i);
  }
  
  for(int i = 0; i < soundNames.length; i++){
    addSound(soundNames[i], i);
  }
  
  levels = new Level[4];
  levels[0] = new Level("", 0, "menu", 15, "LevelMusic", 0);
  levels[1] = new Level("The adventure begins!", 1, "map0", 15, "LevelMusic", 1);
  levels[2] = new Level("Jumping cliffs", 2, "map1", 25, "LevelMusic", 1);
  levels[3] = new Level("The great tower", 3, "map2", 50, "LevelMusic", 1);

  scoreBoard = new ScoreBoard(100);
  mainMenu = new MainMenu();
  transition = new Transition();
  transition.play(200, 100);
  /*
  java.io.File folder = new java.io.File(dataPath(""));
  String[] spriteNames = folder.list();
  println(spriteNames.length + " jpg files in specified directory");
  for(int i = 0; i < spriteNames.length; i++) {
    addSprite(spriteNames[i], i);
  }
  */
  
  reload();
}

void reload(){
  levels[levelCurrent].music.stop();
  particleSystem = new ParticleSystem(500);
  topLevelEntities = new ArrayList<Entity>();
  collisionLayers = new ArrayList<ArrayList<Collider>>();
  collisionLayers.add(colliders0 = new ArrayList<Collider>());
  collisionLayers.add(colliders1 = new ArrayList<Collider>());
  collisionLayers.add(colliders2 = new ArrayList<Collider>());
  terrainContainer = new Entity("terrainContainer", new PVector(0, 0), 0, null, null, 0, true);
  itemContainer = new Entity("itemContainer", new PVector(0, 0), 0, null, null, 0, true);
  enemyContainer = new Entity("enemyContainer", new PVector(0, 0), 0, null, null, 0, true);

  Entity currentLevelEntity = new Entity("currentLevel", new PVector(0, 0), 0, null, null, 0, true);
  currentLevelEntity.addComponent(levels[levelCurrent]);
  
  ui = new Entity("ui", new PVector(0, 0), 0, null, null, 0, true);
  ui.parent = null;
  ui.addComponent(scoreBoard);
  ui.addComponent(mainMenu);
  ui.addComponent(transition);
  
  for(int i = 0; i < topLevelEntities.size(); i++){
    topLevelEntities.get(i).onReload();
  }
  
  //draw map
  for(int i = 0; i < levels[levelCurrent].map.width; i++){
    for(int j = 0; j < levels[levelCurrent].map.height; j++){
      Entity newEntity;
      switch(levels[levelCurrent].map.get(i, j)){
        case #81c042:
          newEntity = new Entity("", new PVector(i * 32, j * 32), 0, terrainContainer, "terrain", 0, true);
          newEntity.addComponent(new Collider(new PVector(16, 16), false, 0));
          newEntity.addComponent(new Collider(new PVector(16, 16), false, 1));
          terrainContainer.children.add(newEntity);
          break;
        case #ffcdcd:
          newEntity = new Entity("", new PVector(i * 32, j * 32), 0, terrainContainer, "bgTile", 0, true);
          terrainContainer.children.add(newEntity);
          break;
        case #d84e4e:
          newEntity = new Entity("", new PVector(i * 32, j * 32), 0, terrainContainer, "hardTop", 0, true);
          newEntity.addComponent(new Collider(new PVector(16, 16), false, 0));
          newEntity.addComponent(new Collider(new PVector(16, 16), false, 1));
          terrainContainer.children.add(newEntity);
          break;
        case #ae3b3b:
          String dirtType = chooseTile("dirt", i, j, "D", "L", "R", "U");
          newEntity = new Entity("", new PVector(i * 32, j * 32), 0, terrainContainer, dirtType, 0, true);
          terrainContainer.children.add(newEntity);
          if(dirtType != "dirt"){
            newEntity.addComponent(new Collider(new PVector(16, 16), false, 0));
            newEntity.addComponent(new Collider(new PVector(16, 16), false, 1));
           }
           break;
        case #f4c100:
          //add coins
          newEntity = new Entity("coin", new PVector(i * 32, j * 32), 0, itemContainer, "coin0", 0, false);
          newEntity.addComponent(new Collider(new PVector(16, 16), true, 2));
          newEntity.addComponent(new Collectible(1, 0, 0, 0, new Animation("coin", 4f), color(245, 235, 37, 100.0), "Coin"));
          itemContainer.children.add(newEntity);
          break;
        case #935bff:
          //add jump boost
          newEntity = new Entity("jump boost", new PVector(i * 32, j * 32), 0, itemContainer, "wing0", 0, false);
          newEntity.addComponent(new Collider(new PVector(16, 16), true, 2));
          newEntity.addComponent(new Collectible(0, 0, 1, 0, new Animation("wing", 4f), color(245, 245, 255, 100.0), "PowerUp"));
          itemContainer.children.add(newEntity);
          break;
        case #00ff00:
          //add speed boost
          newEntity = new Entity("speed boost", new PVector(i * 32, j * 32), 0, itemContainer, "energy0", 0, false);
          newEntity.addComponent(new Collider(new PVector(16, 16), true, 2));
          newEntity.addComponent(new Collectible(0, 0, 0, 1, new Animation("energy", 4f), color(245, 245, 255, 100.0), "PowerUp"));
          itemContainer.children.add(newEntity);
          break;       
        case #ff1ebe:
          //add spikeballs
          newEntity = new Entity("spikeball", new PVector(i * 32, j * 32), 0, enemyContainer, "obstacle", 0, false);
          newEntity.addComponent(new Collider(new PVector(16, 16), true, 0));
          newEntity.addComponent(new Collider(new PVector(16, 16), false, 1));
          newEntity.addComponent(new Spikeball(true));
          enemyContainer.children.add(newEntity);
          break;
        case #9e0974:
          //add spikeballs
          newEntity = new Entity("spikeball", new PVector(i * 32, j * 32), 0, enemyContainer, "obstacle", 0, false);
          newEntity.addComponent(new Collider(new PVector(16, 16), true, 0));
          newEntity.addComponent(new Collider(new PVector(16, 16), false, 1));
          newEntity.addComponent(new Spikeball(false));
          enemyContainer.children.add(newEntity);
          break;
        case #00ffc3:
          //add player
          playerCharacter = new Entity("player", new PVector(i * 32, j * 32), 0, null, "player_standing0", 1, false);
          playerCharacter.addComponent(new Player(1f, 13f, 6f, 3, 40, particleSystem.assignRunParticles(playerCharacter.position, false), false));
          playerCharacter.addComponent(new Collider(new PVector(13, 16), true, 2));
          playerCharacter.addComponent(new Collider(new PVector(13, 16), false, 0));
          break;
        case #14a66c:
          //add dummy player
          playerCharacter = new Entity("dummyPlayer", new PVector(i * 32, j * 32), 0, null, null, 0, true);
          playerCharacter.addComponent(new Player(0, 0, 6f, 3, 40, particleSystem.assignRunParticles(playerCharacter.position, false), true));
          break;
        case #673ab7:
          //add bat
          newEntity = new Entity("bat", new PVector(i * 32, j * 32), 0, enemyContainer, "bat0", 0, false);
          newEntity.addComponent(new Collider(new PVector(16, 16), true, 0));
          newEntity.addComponent(new Collider(new PVector(16, 16), false, 1));
          newEntity.addComponent(new Bat());
          enemyContainer.children.add(newEntity);
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
   
  cameraMain = new Camera(playerCharacter, 0.25f, 1f, 1f);

}

void draw(){
  background(0);
  
  cameraMain.onDraw();
  imageMode(CORNER);
    image(mapRender, -16, -16);
  imageMode(CENTER);
  
  particleSystem.display();
  
  for(int i = 0; i < topLevelEntities.size(); i++){
    topLevelEntities.get(i).onDraw();
  }
  
  for(int i = 0; i < topLevelEntities.size(); i++){
    ui.onDraw();
  }
  
  for(int i = 0; i < controls.length; i++){
    controls[i].OnDraw();
  }
  //score.display();
  //score.updateCam(cameraMain, levelCurrent, levels, playerCharacter);
}

//////////////INPUTS///////////////
void keyPressed(){
    lastKeyPressed = key;
    Control chosenControl = null;
    if (key == CODED) {
      switch(keyCode) {
        case LEFT: 
          chosenControl = left;
          right.held = false;
          break;
        case RIGHT: 
          chosenControl = right;
          left.held = false;
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
          reload();
          break;
        case ' ':
          chosenControl = jump;
          break;
        case 'e': 
          chosenControl = select;
          break;
        case 'v':
          chosenControl = dash;
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

void keyReleased(){
  Control chosenControl = null;
  if(key == lastKeyPressed){
    lastKeyPressed = 0;
  }
  
  if (key == CODED) {
    switch(keyCode) {
      case LEFT: 
        chosenControl = left;
        if(right.down){
          right.held = true;
        }
        break;
      case RIGHT: 
        chosenControl = right;
        if(left.down){
          left.held = true;
        }
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
      case 'e': 
        chosenControl = select;
        break;
      case 'v':
        chosenControl = dash;
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

void mousePressed(){
  Control chosenControl = null;
  switch(mouseButton) {
      case LEFT: 
        chosenControl = leftMouse;
        break;
    }
  if(chosenControl != null){
    chosenControl.Down();
  }
}

void mouseReleased(){
  Control chosenControl = null;
  switch(mouseButton) {
      case LEFT: 
        chosenControl = leftMouse;
        break;
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
  return checkedTile != #81c042 && checkedTile!= #d84e4e && checkedTile != #ae3b3b;
}

void addSprite(String name, int index){
  findSprite.set(name, index); 
  sprites[index] = loadImage(name + ".png");
}

void addSound(String name, int index){
  findSound.set(name, index); 
  sounds[index] = new SoundFile(this, name + ".wav");
}

void playSound(String name, PVector position){
  if(dist(position.x, position.y, cameraMain.position.x, cameraMain.position.y) < width){
    sounds[findSound.get(name)].play();
  }
}
