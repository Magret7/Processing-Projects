class Coin extends Component{
  Animation shine = new Animation("coin", 4f);
  
  void onCreated(){
    entity.currentAnimation = shine;
    levels[levelCurrent].coinsInLevel++;
  }
  
  void onTriggerEnter(Collider other){
    entity.parent.children.remove(entity);
    levels[levelCurrent].coinsCollected++;
  }
}
