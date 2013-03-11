
// ------------------------------------  CALLBACKS FOR CONTROLS GUI AND KEYBOARD
void newCell_size(int s) {
  if (scene1 != null) {
    if (scene1.newCell != null) {
      scene1.newCell.cellSize = s;
    }
  }
}

// ===================================== SCENE

class Scene1 {

  PApplet parent;
  int doDraw;

  boolean isSceneEmpty = true;

  public Cell newCell; // the most recently created cell
  public ArrayList cells;

  public Scene1(PApplet _parent) {
    parent = _parent;
    doDraw = 0;

    cells = new ArrayList();
    //controlGUIinit();
  }
  public void draw() {
    if (doDraw != 0) {
      strokeWeight(1);
      for (int i = 0; i < cells.size(); i++ ) {

        Cell cell = (Cell) cells.get(i);
        cell.update();
        cell.render();
      }
      for (int i = cells.size() - 1; i >= 0; i-- ) {
        Cell cell = (Cell) cells.get(i);
        if (! cell.isOnScreen()) {
          cells.remove(i);
        }
      }
    }
  }

  // a green creature that'll stay on screen
  public void newCell() {
    newCell((int) random(0, width), (int) random(0, height));
  }

  public void newCell(int x, int y) {
    newCell = new Cell(parent, x, y, 1, (int) random(10, 50));
    newCell.autoKick = false;
    newCell.stayOnScreen = true;
    cells.add(newCell);
    globals.newCell = newCell;
  }
  void newCell_release() {
    if (newCell != null) {
      newCell.kick();
      newCell.autoKick = true;
      newCell.hasFocus = false;
    }
  }

  void newCell_size(int s) {
    if (newCell != null) {
      if (newCell.hasFocus)
        newCell.cellSize = s;
    }
  }

  void newRandomCell() {
    // make sure previous newCell is released
    if (newCell != null) {
      newCell_release();
    }
    // Make sure the first creature is a green one.
    if (isSceneEmpty) {
      newCell();
      isSceneEmpty = false;
    } 
    else {
      newCell = new Cell(parent, (int) random(0, width), (int) random(0, height), (int) random(1, 5), (int) random(1, 50));
      newCell.autoKick = false;
      newCell.cellSize = (int) random(10, 20);
      int legShape =  floor(random (0, 7));

      newCell.mutate = random(-2, 2);
      newCell.bodyNodes = (int) random(3, 20);
      newCell.damping = random(0.3, 0.8);
      newCell.bodyShape = (int) floor(random(0, 3));
      int paletteIndex = (int) random(0, (globals.palettes.size()-1));
      newCell.setPalette(paletteIndex);
      for (int i = 0; i < newCell.numLegs; i++) {
        Leg leg = (Leg) newCell.bodyLegs.get(i);
        leg.numberOfSegments = (int) random(3, 10);
        leg.legShape = legShape;
        leg.setPalette(paletteIndex);
      }
      newCell.bodyLegProportion = random(1.7, 5);
      cells.add(newCell);
    }
  }

  void newCell_damping(float d) {
    if (newCell != null) {
      newCell.damping = d;
    }
  }
  void clear() {
    int prevDrawVal = doDraw;
    doDraw = 0;
    for (int i = cells.size() - 1; i >= 0; i-- ) {
      cells.remove(i);
    }
    isSceneEmpty = true;
    doDraw = prevDrawVal;
  }
  void newCell_kickPeriod(int kp) {
    if (newCell != null) {
      newCell.kickPeriod = kp;
    }
  }
  void allCells_kick() {
    for (int i = 0; i < cells.size(); i++ ) {
      Cell curCell = (Cell) cells.get(i);
      curCell.oneKick();
    }
  }

  // leave the first creature behind while dispersing the others
  void leaveOneBehind() {
    int leftBehindCell = 0;
    for (int i = 0; i < cells.size(); i++ ) {
      Cell curCell = (Cell) cells.get(i);
      //      float damp = curCell.damping;
      if (i==leftBehindCell) {
        curCell.damping *= 0.9;
      }
      else {
        curCell.damping *= 0.3;
      }
    }
  }

  // ---------------------------------------------- OSC callbacks
  public void osc(String[] adressParts, OscMessage message) {
    //    println("---- Message to OSC SCENE 1");
    if (adressParts[2] != null) {
      String subAdress = adressParts[2].replaceAll("\\W", "");
      //      println("-- " + subAdress);
      // -----------------------
      if (subAdress.equals("draw")) {
        doDraw = message.get(0).intValue();
      }
      // -----------------------
      if (subAdress.equals("newCell")) {
        newCell();
      }
      // -----------------------
      if (subAdress.equals("newRandomCell")) {
        newRandomCell();
      }
      // -----------------------
      if (subAdress.equals("cellSize")) {
        newCell_size(message.get(0).intValue());
      }
      // -----------------------
      if (subAdress.equals("damping")) {
        newCell_damping(message.get(0).floatValue());
      }
      // -----------------------
      if (subAdress.equals("cellRelease")) {
        newCell_release();
      }
      // -----------------------
      if (subAdress.equals("clear")) {
        clear();
      }
      // -----------------------
      if (subAdress.equals("cellKickPeriod")) {
        newCell_kickPeriod(message.get(0).intValue());
      }
      // -----------------------
      if (subAdress.equals("allCellsKick")) {
        allCells_kick();
      }
      // -----------------------
      if (subAdress.equals("leaveOneBehind")) {
        leaveOneBehind();
      }
    }
  }

  //  // ------------------------------------ CONTROLS GUI
  //  void controlGUIinit() {
  //    Group gui1 = gui.addGroup("tableau 1")
  //      .setBackgroundColor(color(0, 64))
  //        .setBackgroundHeight(50)
  //          ;
  //    gui.addSlider("newCell_size")
  //      .setPosition(10, 20)
  //        .setSize(100, 20)
  //          .setRange(1, 100)
  //            .setValue(20)
  //              .moveTo(gui1)
  //                ;
  //    accordionUI = gui.addAccordion("accordionUI")
  //      .setPosition(0, 0)
  //        .setWidth(200)
  //          .addItem(gui1)
  //            ;
  //  }
}

