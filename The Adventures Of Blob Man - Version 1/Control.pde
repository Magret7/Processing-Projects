class Control{
  String name;
  boolean down, held, up;
  
  Control(String name){
    this.name = name;
  }
  
  void OnDraw(){
    //if(down){print(name + " down: " + down + "\n");}
    //if(up){print(name + " up: " + up + "\n");}
    //if(held){print(name + " held: " + held + "\n");}
    down = false;
    up = false;
  }
  
  void Down(){
    down = true;
    held = true;
  }

  void Up(){
    up = true;
    held = false;
  }
}
