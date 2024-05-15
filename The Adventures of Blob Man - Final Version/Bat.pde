class Bat extends Component{
  float speed = 1;
  int contactDamage = -1;
  PVector targetPos = new PVector(0, 0);
  Animation anim;
  PVector buffer = new PVector(0, 0);
  float wanderDist = 32;
  float FOV = 300;
  
  void onCreated(){
    targetPos.set(entity.position.x, entity.position.y);
    entity.currentAnimation = new Animation("bat", 2f);
    entity.friction = 0;
    entity.imageScale = .6;
  }
  
  void onDraw(){
    entity.velocity.x += .01 * (targetPos.x - entity.position.x);
    entity.velocity.y += .01 * (targetPos.y - entity.position.y);
    if(entity.velocity.mag() > 5){
      entity.velocity.mult(5/entity.velocity.mag());
    }
    if(frameCount % 25 == 0){
      float distance = sqrt(pow(entity.position.x - playerCharacter.position.x,2) + pow(entity.position.y - playerCharacter.position.y, 2));
      if(distance < FOV){
        targetPos.set(playerCharacter.position.x, playerCharacter.position.y);
      } else{
        targetPos.set(entity.position.x, entity.position.y);
        buffer.set(random(wanderDist) - wanderDist/2, random(wanderDist) - wanderDist/2);
        targetPos.add(buffer);
      }
    }
    if(entity.rightCollision){
      entity.position.x -=1;
      entity.velocity.x = -speed;
      //playSound("Footstep0", entity.position);
    }
    else if(entity.leftCollision){
      entity.position.x +=1;
      entity.velocity.x = speed;
      //playSound("Footstep0", entity.position);
    } else if(entity.downCollision){
      entity.position.x +=1;
      entity.velocity.x = speed;
      //playSound("Footstep0", entity.position);
    } else if(entity.upCollision){
      entity.position.x +=1;
      entity.velocity.x = speed;
      //playSound("Footstep0", entity.position);
    }
  }
  
  void onTriggerEnter(Collider other){
    other.entity.damage(contactDamage);
  }
}
