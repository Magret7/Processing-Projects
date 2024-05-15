class TextBox {
  PVector radius, pos;
  String text;
  boolean button;
  ArrayList<TextBoxAction> actions = new ArrayList<TextBoxAction>();
  
  TextBox(String text, PVector radius, PVector pos, boolean button){
    this.text = text;
    this.radius = radius;
    this.pos = pos;
    this.button = button;
  }
  
  void render(){
    stroke(color(183, 142, 92));
    strokeWeight(5);
    fill((button && overRect()) ? color(204, 174, 136) : color(224, 194, 156));
    rect(cameraMain.position.x + pos.x, cameraMain.position.y + pos.y, radius.x, radius.y, 20, 20, 0, 20);
    fill(0);
    text(text, cameraMain.position.x + pos.x, cameraMain.position.y + pos.y+5);
    
    if(button && overRect() && leftMouse.down){
      for(int i = 0; i < actions.size(); i++){
        actions.get(i).trigger();
      }
    }
  }
  
  boolean overRect(){
    //print(mouseX + ", " + mouseY  + ", " + new PVector(pos.x, pos.y) + new PVector(pos.x + radius.x, pos.y + radius.y) + "\n");
    if (mouseX-(width/2) >= pos.x - (radius.x/2) && mouseX-(width/2) <= pos.x + (radius.x/2) && 
        mouseY-(height/2) >= pos.y - (radius.y/2) && mouseY-(height/2) <= pos.y + (radius.y/2)) {
      return true;
    } else {
      return false;
    }
  }
}
