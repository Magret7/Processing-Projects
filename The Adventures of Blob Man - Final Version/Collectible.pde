class Collectible extends Component{
  Animation shine;
  color particleColor;
  int coinBoost;
  int healthBoost;
  int doubleJumpBoost;
  int speedBoost;
  float floatOffset;
  SoundFile collectNoise;
  
  Collectible(int coinBoost, int healthBoost, int doubleJumpBoost, int speedBoost, Animation shine, color particleColor, String collectNoiseName){
    this.coinBoost = coinBoost;
    this.healthBoost = healthBoost;
    this.doubleJumpBoost = doubleJumpBoost;
    this.speedBoost = speedBoost;
    this.shine = shine;
    this.particleColor = particleColor;
    floatOffset = random(0, 1000);
    if(collectNoiseName != null){
      collectNoise = sounds[findSound.get(collectNoiseName)];
    }
  }
  
  void onCreated(){
    entity.currentAnimation = shine;
  }
  
  void onDraw(){
      entity.position.y = entity.position.y + (sin((millis() + floatOffset) * 0.0025) * 0.25f);
  }
  
  void onTriggerEnter(Collider other){
    Player playerRef = (Player)other.entity.GetComponent(Player.class);
    if(playerRef != null){
      //print(entity.name + entity.position + ", " + other.entity.name + " " + other.entity.position + "\n");
      collectNoise.play();
      entity.parent.children.remove(entity);
      levels[levelCurrent].incrementCoins(coinBoost);
      other.entity.damage(healthBoost);
      if(doubleJumpBoost > 0){
        scoreBoard.notification("+" + doubleJumpBoost + " Double Jumps", 600);
        playerRef.incrementJumps(doubleJumpBoost);
      }
      if(speedBoost > 0 ){
        scoreBoard.notification("+" + speedBoost + " Double Speed", 600);
        playerRef.incrementSpeed(speedBoost);
      }
      particleSystem.emitCoinParticles(entity.position, true, particleColor);
    }
  }
}
