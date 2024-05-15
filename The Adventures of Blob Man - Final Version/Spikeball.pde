class Spikeball extends Component{
  float speed = 1;
  int contactDamage = -1;
  boolean horizontal;
  
  Spikeball(boolean b){
    this.horizontal = b;
  }
  
  void onCreated(){
    if(horizontal){
      entity.velocity.x = speed;
    } else{
      entity.velocity.y = 1;
    }
    entity.friction = 0;
  }
  
  void onDraw(){
    if(horizontal){
      if(entity.rightCollision){
        entity.position.x -=1;
        entity.velocity.x = -speed;
        playSound("Footstep0", entity.position);
      } else if(entity.leftCollision){
        entity.position.x +=1;
        entity.velocity.x = speed;
        playSound("Footstep0", entity.position);
      }
    } else {
      if(entity.downCollision){
        entity.position.y -=1;
        entity.velocity.y = -speed;
        playSound("Footstep0", entity.position);
      } else if(entity.upCollision){
        entity.position.y +=1;
        entity.velocity.y = speed;
        playSound("Footstep0", entity.position);
        }
    }
  }

  
  void onTriggerEnter(Collider other){
    other.entity.damage(contactDamage);
  }
}
