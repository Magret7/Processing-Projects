class MainMenu extends Component {
  int loadedLevel;
  boolean visi = false;
  void onReload() {
    if (levels[levelCurrent].levelMode == 0) {
      String[] saveFile = loadStrings("save.txt");
      loadedLevel = Integer.parseInt(loadStrings("save.txt")[0]);
    }
  }

  void onDraw() {
    if (levels[levelCurrent].levelMode == 0) {
      TextBox newGame = new TextBox("New Game", new PVector(200, 60), new PVector(0, 0), true);
      newGame.actions.add(new StartGame(1));
      newGame.render();

      TextBox loadGame = new TextBox("Load Game", new PVector(200, 60), new PVector(0, 100), true);
      loadGame.actions.add(new StartGame(loadedLevel));
      loadGame.render();

      TextBox controls = new TextBox("Controls", new PVector(200, 60), new PVector(260, 214), true);
      TextBox contMenu = new TextBox("Press \"a\" to move to the left\n\nPress \"d\" to move to the right\n\nPress \"SPACE\" to jump\n\n\nPress \"TAB\" to close this menu", new PVector(width, height), new PVector(0, 0), false);
      if (controls.button && controls.overRect() && leftMouse.down) {
        visi = true;
      }
      if(visi) {
        contMenu.render();
        if(keyPressed && key == TAB) {
          visi = false;
        }
      }
      controls.render();
    }
  }
}
