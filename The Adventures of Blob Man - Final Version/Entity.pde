class Entity{
  //scene hierarchy
  String name;
  Entity parent;
  ArrayList<Entity> children = new ArrayList<Entity>();
  ArrayList<Component> components = new ArrayList<Component>();
  //physics
  PVector position;
  float rotation, imageScale;
  PVector velocity;
  float friction = 0.18f;
  float gravityInfluence = 1;
  boolean downCollision, upCollision, leftCollision, rightCollision;
  //visuals
  PImage sprite;
  color tint = color(255, 255, 255);
  boolean flipped;
  boolean isStatic;
  Animation currentAnimation;
  
  Entity(String name, PVector position, float rotation, Entity parent, String spriteName, int gravityInfluence, boolean isStatic){
    this.name = name;
    this.position = position;
    this.rotation = rotation;
    this.imageScale = 0;
    this.velocity = new PVector(0, 0);
    if(parent != null){
      this.parent = parent;
    }
    else{
      topLevelEntities.add(this);
    }
    if(spriteName != null){
      this.sprite = sprites[findSprite.get(spriteName)];
    }
    this.gravityInfluence = gravityInfluence;
    this.isStatic = isStatic;
  }
  
  void created(){
    for(int i = 0; i < components.size(); i++){
      components.get(i).onCreated();
    }
    
    for(int i = 0; i < children.size(); i++){
      children.get(i).created();
    }
  }
  
  void onReload(){
    for(int i = 0; i < components.size(); i++){
      components.get(i).onReload();
    }
    
    for(int i = 0; i < children.size(); i++){
      children.get(i).onReload();
    }
  }
  
  void onDraw(){
    position = new PVector(position.x + velocity.x, position.y + velocity.y);
    if(!isStatic){
      for(int i = 0; i < components.size(); i++){
        components.get(i).physicsStep();
      }
    }
    if(dist(position.x, position.y, cameraMain.position.x, cameraMain.position.y) < width * 2){
      velocity.y += gravity * gravityInfluence;
      velocity.y = min(velocity.y, terminalVelocity);
      velocity.x = lerp(velocity.x, 0, friction);
      /*
      if(rightCollision){print("- hitting right - ");}
      if(leftCollision){print("- hitting left - ");}
      if(upCollision){print("- hitting up - ");}
      if(downCollision){print("- hitting down - \n");}
      */
      
      pushMatrix();
        translate(position.x, position.y);
        if(flipped){scale(-1,1);}
        tint(tint);
        if(!isStatic){
          if(currentAnimation == null){
            if(sprite != null){
              image(sprite, 0, 0);
            }
          }
          else{
            if(imageScale != 0){
              scale(imageScale);
            }
            image(currentAnimation.progress(), 0, 0);
          }
        }
        tint(#FFFFFF);
        rotate(rotation);
        if(parent != null){
          translate(parent.position.x, parent.position.y);
          rotate(parent.rotation);
        }
      popMatrix();
    }
    
    for(int i = 0; i < components.size(); i++){
      components.get(i).onDraw();
    }
    
    for(int i = 0; i < children.size(); i++){
      children.get(i).onDraw();
    }
  }
  
  void Destroy(){
    for(int i = 0; i < components.size(); i++){
      components.get(i).onDestroy();
    }
    
    if(parent != null){
      parent.children.remove(this);
    }
    else{
      topLevelEntities.remove(this);
    }
  }
  
  Component addComponent(Component addedComponent){
    components.add(addedComponent);
    addedComponent.entity = this;
    return addedComponent;
  }
  
  void damage(int damage){
    for(int i = 0; i < components.size(); i++){
      components.get(i).onDamaged(damage);
    }
  }
  
  Component GetComponent(Class<?> targetClass){
    for(int i = 0; i < components.size(); i++){
      Component newRef = components.get(i);
      if(newRef.getClass() == targetClass){
        return newRef;
      }
    }
    
    return null;
  }
}
