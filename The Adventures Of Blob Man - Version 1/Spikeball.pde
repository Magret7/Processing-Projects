class Spikeball extends Component{
  float speed = 1;
  int contactDamage = 1;
  
  void onCreated(){
    entity.velocity.x = speed;
    entity.friction = 0;
  }
  
  void onDraw(){
    if(entity.rightCollision){
      entity.position.x -=1;
      entity.velocity.x = -speed;
    }
    else if(entity.leftCollision){
      entity.position.x +=1;
      entity.velocity.x = speed;
    }
  }
  
  void onTriggerEnter(Collider other){
    other.entity.damage(contactDamage);
  }
}
