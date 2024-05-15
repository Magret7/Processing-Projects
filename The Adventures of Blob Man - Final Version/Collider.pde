class Collider extends Component{
  int layer;
  PVector bounds;
  boolean isStatic;
  boolean isTrigger;
  PVector previousPosition;
  
  Collider(PVector bounds, boolean isTrigger, int layer){
    this.bounds = bounds;
    this.isTrigger = isTrigger;
    this.layer = layer;
  }
  
  void onCreated(){
    collisionLayers.get(layer).add(this);
    previousPosition = new PVector(entity.position.x, entity.position.y);
  }
  
  void physicsStep(){
    entity.upCollision = false;
    entity.downCollision = false;
    entity.leftCollision = false;
    entity.rightCollision = false;
    for(int i = 0; i < collisionLayers.get(layer).size(); i++){
      Collider check = collisionLayers.get(layer).get(i);
      if(check != this){ 
        if(
          entity.position.x - bounds.x < check.entity.position.x + check.bounds.x &&
          entity.position.x + bounds.x > check.entity.position.x - check.bounds.x &&
          entity.position.y - bounds.y < check.entity.position.y + check.bounds.y &&
          entity.position.y + bounds.y > check.entity.position.y - check.bounds.y
        ){
          if(isTrigger){
            for(int j = 0; j < entity.components.size(); j++){
              entity.components.get(j).onTriggerEnter(check);
            }
          }
          else{
            if(check.isTrigger){
              for(int j = 0; j < check.entity.components.size(); j++){
                check.entity.components.get(j).onTriggerEnter(check);
              }
            }
            else{
              int smallestOverlap = getSmallestOverlap(check.entity.position, check.bounds);
              
              if(smallestOverlap == 0){
                entity.position.y -= (entity.position.y + bounds.y - check.entity.position.y + check.bounds.y);
                entity.velocity.y = min(entity.velocity.y, 0);
                entity.downCollision = true;
              }
              else if(smallestOverlap == 1){
                entity.position.x -= (entity.position.x + bounds.x - check.entity.position.x + check.bounds.x);
                entity.velocity.x = min(entity.velocity.x, 0);
                entity.rightCollision = true;
                //print("entity position: " + entity.position.x + ", checked entity position: " + check.entity.position.x + "\n");
              }
              else if(smallestOverlap == 2){
                entity.position.x += (check.entity.position.x + check.bounds.x - entity.position.x + bounds.x);
                entity.velocity.x = max(entity.velocity.x, 0);
                entity.leftCollision = true;
              }
              else if(smallestOverlap == 3){
                entity.position.y += (check.entity.position.y + check.bounds.y - entity.position.y + bounds.y);
                entity.velocity.y = max(entity.velocity.y, 0);
                entity.upCollision = true;
              }
              
              /*
              if(smallestOverlap == 0){
                entity.position.y = previousPosition.y;
                entity.velocity.y = min(entity.velocity.y, 0);
                entity.downCollision = true;
                //previousPosition = new PVector(entity.position.x, previousPosition.y);
              }
              else if(smallestOverlap == 1){
                entity.position.x = previousPosition.x;
                entity.velocity.x = min(entity.velocity.x, 0);
                entity.rightCollision = true;
                //previousPosition = new PVector(previousPosition.x, entity.position.y);
                //print("entity position: " + entity.position.x + ", checked entity position: " + check.entity.position.x + "\n");
              }
              else if(smallestOverlap == 2){
                entity.position.y = previousPosition.y;
                entity.velocity.y = max(entity.velocity.y, 0);
                entity.upCollision = true;
                //previousPosition = new PVector(entity.position.x, previousPosition.y);
              }
              else if(smallestOverlap == 3){
                entity.position.x = previousPosition.x;
                entity.velocity.x = max(entity.velocity.x, 0);
                entity.leftCollision = true;
                //previousPosition = new PVector(previousPosition.x, entity.position.y);
              }
              */
            }
          }
          //print("colliding \n");
          //fill(255, 50, 50, 50);
        } else {
          //print("not colliding \n");
          //fill(50, 255, 50, 50);
        }
      }
    }
    previousPosition = entity.position;
    /*
    else{
      fill(50, 255, 50, 50);
    }
    */
    //rect(entity.position.x, entity.position.y, bounds.x * 2, bounds.y * 2);
  }
  
  int getSmallestOverlap(PVector checkedPosition, PVector checkedBounds){
    float smallest = 0;
    int output = 0;
    
    if(entity.position.y - (checkedPosition.y - checkedBounds.y) < smallest){
      smallest = entity.position.y - checkedPosition.y;
      output = 0;
    }
    if(entity.position.x - (checkedPosition.x - checkedBounds.x) < smallest){
      smallest = entity.position.x - checkedPosition.x;
      output = 1;
    }
    if(checkedPosition.x - (entity.position.x - checkedBounds.x) < smallest){
      smallest = checkedPosition.x - entity.position.x;
      output = 2;
    }
    if(checkedPosition.y - (entity.position.y - checkedBounds.y) < smallest && entity.velocity.y < 0){
      smallest = checkedPosition.y - entity.position.y;
      output = 3;
    }
    
    /*
    if(entity.velocity.y > 0 && abs(entity.velocity.y) > smallest){
      smallest = abs(entity.velocity.y);
      output = 0;
    }
    if(entity.velocity.x > 0 && abs(entity.velocity.x) > smallest){
      smallest = abs(entity.velocity.x);
      output = 1;
    }
    if(entity.velocity.x < 0 && abs(entity.velocity.x) > smallest){
      smallest = abs(entity.velocity.x);
      output = 3;
    }
    if(entity.velocity.y < 0 && abs(entity.velocity.y) > smallest){
      smallest = abs(entity.velocity.y);
      output = 2;
    }
    */
    
    return output;
  }
  
  void onDestroy(){
    collisionLayers.get(layer).remove(this);
  }
}
