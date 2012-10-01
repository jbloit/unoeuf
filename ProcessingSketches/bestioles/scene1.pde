
// ------------------------------------  CALLBACKS FOR CONTROLS GUI AND KEYBOARD
void newCell_size(int s) {
  if (scene1 != null) {
    if (scene1.newCell != null) {
      println("size " + s );
      scene1.newCell.cellSize = s;
    }
  }
}

// ===================================== SCENE

class Scene1 {

  PApplet parent;
  int doDraw;

  public Cell newCell; // 
  public ArrayList cells;

  public Scene1(PApplet _parent) {
    parent = _parent;
    doDraw = 1;

    cells = new ArrayList();
    //controlGUIinit();
  }
  public void draw() {
    if (doDraw != 0) {
      for (int i = 0; i < cells.size(); i++ ) {
        Cell cell = (Cell) cells.get(i);
        cell.draw();
      }
      for (int i = cells.size() - 1; i >= 0; i-- ) {
        Cell cell = (Cell) cells.get(i);
        if (! cell.isOnScreen()) {
          cells.remove(i);
        }
      }
    }
  }

  public void newCell() {
    newCell((int) random(0, width), (int) random(0, height));
  }

  public void newCell(int x, int y) {
    newCell = new Cell(parent, x, y, 1, (int) random(10, 50));
    newCell.autoKick = false;
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

  void leaveOneBehind() {
    int leftBehindCell = (int) random(cells.size()-1);
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

