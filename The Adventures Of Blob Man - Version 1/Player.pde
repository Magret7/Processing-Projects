class Player extends Component{
  float moveSpeed, jumpStrength, coyoteTime, coyoteTimeElapsed;
  int healthCurrent, healthMax, invincibilityElapsed, invincibilityMax;
  boolean grounded;
  Collider collider;
  Animation running;
  Animation standing;
  Animation jumping;
  
  Player(float moveSpeed, float jumpStrength, float coyoteTime, int healthMax, int invinciibilityMax){
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
  }
  
  void onCreated(){
  }
  
  void onDraw(){
    //if(entity.position.y > height * 1.1f){setup();}
    
    if(right.held){entity.flipped = false;}
    if(left.held){entity.flipped = true;}
    
    if(jump.down && coyoteTimeElapsed < coyoteTime){
      coyoteTimeElapsed = coyoteTime;
      entity.velocity.y -= (jumpStrength);
    }
    
    if(entity.velocity.x > 1.5f || entity.velocity.x < -1.5f){
      entity.currentAnimation = running;
    }
    else{
      entity.currentAnimation = standing;
    }
    
    if(entity.downCollision){
      coyoteTimeElapsed = 0;
    }
    else{
      if(coyoteTimeElapsed < coyoteTime){
        coyoteTimeElapsed++;
      }
      entity.currentAnimation = jumping;
    }
    
    if(invincibilityElapsed < invincibilityMax){
      entity.tint = millis() % 2 == 0 ? #ffb2b2 : #FFFFFF;
      invincibilityElapsed++;
    }
    else{
      entity.tint = #FFFFFF;
    }
    
    entity.velocity.x += ((left.held ? -1 : 0) + (right.held ? 1 : 0)) * moveSpeed;
    //currentEntity.velocity.x = max(min((currentEntity.position.x - mouseX) * 0.005, 4), -4);
    //max(min((currentEntity.position.x - mouseX) * 0.005, 4), -4);
  }
  
  void onTriggerEnter(){
    
  }
  
  void onDamaged(int damage){
    if(invincibilityElapsed >= invincibilityMax){
      invincibilityElapsed = 0;
      healthCurrent -= damage;
      if(healthCurrent < 1){
        reload();
      }
    }
  }
}
