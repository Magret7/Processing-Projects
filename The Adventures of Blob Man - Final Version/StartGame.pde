class StartGame extends TextBoxAction{
  int targetLevel;
  
  StartGame(int targetLevel){
    this.targetLevel = targetLevel;
  }
  
  void trigger(){
    levels[levelCurrent].complete = true;
    levels[levelCurrent].progressLevel(targetLevel);
  }
}
