class Player extends Component {
  float moveSpeed, jumpStrength, coyoteTime, coyoteTimeElapsed;
  int healthCurrent, healthMax, invincibilityElapsed, invincibilityMax;
  boolean grounded, dashClear;
  Collider collider;
  Animation running;
  Animation standing;
  Animation jumping;
  int jumpsMax = 1, jumps, dashes, dashesMax = 1;
  float stepTimeElapsed, stepTimeMax;
  String[] stepSounds = {"Footstep0", "Footstep1","Footstep2"};
  boolean dummy;
  float dashStrength = 15;

  // Particle Effects
  RunParticles runParticles;

  Player(float moveSpeed, float jumpStrength, float coyoteTime, int healthMax, int invinciibilityMax, RunParticles runEffect, boolean dummy) {
    this.moveSpeed = moveSpeed;
    this.jumpStrength = jumpStrength;
    this.coyoteTime = coyoteTime;
    coyoteTimeElapsed = 0;
    running = new Animation("player_running", 4f);
    standing = new Animation("player_standing", 0);
    jumping = new Animation("player_jumping", 0);
    this.healthMax = healthMax;
    healthCurrent = healthMax;
    this.invincibilityMax = invinciibilityMax;
    invincibilityElapsed = 0;
    this.runParticles = runEffect;
    stepTimeMax = 14;
    this.dummy = dummy; 
    //////////////////////////////////////////////////
    this.dashes = 1;
    //////////////////////////////////////////////////
  }

  void onCreated() {
  }

  void onDraw() {
    //if(entity.position.y > height * 1.1f){setup();}
    if(!dummy){
      if (right.held) {
        entity.flipped = false;
      }
      if (left.held) {
        entity.flipped = true;
      }
  
      if (jump.down && (coyoteTimeElapsed < coyoteTime || jumps > 1)) {
        entity.velocity.y = 0;
        playSound("Jump", entity.position);
        jumps--;
        coyoteTimeElapsed = coyoteTime;
        entity.velocity.y -= (jumpStrength);
        particleSystem.emitJumpParticles(entity.position, true, color(255, 255, 255, 30.0));
      }
      
      if (dash.down && dashes > 0){
        dashes -= 1;
        particleSystem.emitHurtParticles(entity.position, true, color(200, 225, 200, 200.0));
        entity.velocity.x += calculateDash();
      }
      
      if (entity.velocity.x > 1.5f || entity.velocity.x < -1.5f) {
        //footstep audio
        if(entity.downCollision){
          if(stepTimeElapsed >= stepTimeMax){
            stepTimeElapsed = 0;
            playSound(stepSounds[(int)random(0, stepSounds.length)], entity.position);
          }
          else{
            stepTimeElapsed++;
          }
        }
        
        entity.currentAnimation = running;
        this.runParticles.active = true;
        this.runParticles.sourcePos = entity.position;
      } else {
        stepTimeElapsed = stepTimeMax;
        entity.currentAnimation = standing;
        this.runParticles.active = false;
      }
  
      if (entity.downCollision) {
        coyoteTimeElapsed = 0;
        jumps = jumpsMax;
        dashes = dashesMax;
      } else {
        if (coyoteTimeElapsed < coyoteTime) {
          coyoteTimeElapsed++;
        }
        entity.currentAnimation = jumping;
      }
  
      if (invincibilityElapsed < invincibilityMax) {
        entity.tint = millis() % 2 == 0 ? #ffb2b2 : #FFFFFF;
        invincibilityElapsed++;
      } else {
        entity.tint = #FFFFFF;
      }
  
      entity.velocity.x += ((left.held ? -1 : 0) + (right.held ? 1 : 0)) * moveSpeed;
      //currentEntity.velocity.x = max(min((currentEntity.position.x - mouseX) * 0.005, 4), -4);
      //max(min((currentEntity.position.x - mouseX) * 0.005, 4), -4);
    }
  }

  void onTriggerEnter() {
  }

  void onDamaged(int damage) {
    if (invincibilityElapsed >= invincibilityMax) {
      healthCurrent += damage;
      if(damage < 0){
        playSound("Hurt", entity.position);
        invincibilityElapsed = 0;
        particleSystem.emitHurtParticles(entity.position, true, color(255, 0, 0, 100.0));
        if (healthCurrent < 1) {
          reload();
        }
      }
    }
  }
  
  void incrementJumps(int doubleJumpBoost){
    jumpsMax += doubleJumpBoost;
  }
  
 void incrementSpeed(int speedBoost){
    moveSpeed = speedBoost * 2;
  }
  
  private float calculateDash(){
    Collider hold = null;
    if(entity.flipped == false){
      for(int i = 0; i < collisionLayers.get(0).size(); i++){
         Collider check = collisionLayers.get(0).get(i);
         if(check.entity.name == "player"){
           continue;
         }
         if(entity.position.x < check.entity.position.x + check.bounds.x &&
           entity.position.x + dashStrength + 80 + entity.velocity.x > check.entity.position.x - check.bounds.x &&
           entity.position.y < check.entity.position.y + check.bounds.y &&
           entity.position.y > check.entity.position.y - check.bounds.y){
             if(hold == null || check.entity.position.x < hold.entity.position.x){
               hold = check;
             }
         }
      }
      if(hold != null){
        //particleSystem.emitHurtParticles(hold.entity.position, true, color(0, 0, 200, 200.0));
        return (hold.entity.position.x - hold.bounds.x - entity.position.x + entity.velocity.x)/8;
      }
      return dashStrength;
    } else{
      for(int i = 0; i < collisionLayers.get(0).size(); i++){
         Collider check = collisionLayers.get(0).get(i);
         if(check.entity.name == "player"){
           continue;
         }
         if(entity.position.x - dashStrength - 80 + entity.velocity.x < check.entity.position.x + check.bounds.x &&
           entity.position.x > check.entity.position.x - check.bounds.x &&
           entity.position.y < check.entity.position.y + check.bounds.y &&
           entity.position.y > check.entity.position.y - check.bounds.y){
             if(hold == null || check.entity.position.x > hold.entity.position.x){
               hold = check;
             }
         }
      }
      if(hold != null){
        //particleSystem.emitHurtParticles(hold.entity.position, true, color(0, 0, 200, 200.0));
        return (hold.entity.position.x - hold.bounds.x - entity.position.x + entity.velocity.x)/8;
      }
      return -dashStrength;
    }
  }
}
