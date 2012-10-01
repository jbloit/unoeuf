// ------------------------------------ ROUTE OSC CONTROLS
void osc1(String[] adressParts, OscMessage message) {
  println("---- Message to OSC SCENE 1");
  if (adressParts[2] != null) {
    String subAdress = adressParts[2].replaceAll("\\W", "");

    if (subAdress.equals("cellSize")) {
      println(message.get(0).intValue());
    }
    if (subAdress.equals("cellSize")) {
      println(message.get(0).intValue());
    }
  }
}

// ------------------------------------ CONTROLS CALLBACKS
void newCell_size(int s) {
  if (scene1 != null && scene1.isON) {
    if (scene1.newCell != null) {
      println("size " + s );
      scene1.newCell.cellSize = s;
    }
  }
}





// ------------------------------------ SCENE

class Scene1 {

  PApplet parent;
  boolean isON;

  public Cell newCell; // 
  public ArrayList cells;

  public Scene1(PApplet _parent) {
    parent = _parent;
    isON = false;

    cells = new ArrayList();
    controlGUIinit();
  }
  void controlGUIinit() {
    // ------------------------------------ CONTROLS GUI
    Group gui1 = gui.addGroup("tableau 1")
      .setBackgroundColor(color(0, 64))
        .setBackgroundHeight(50)
          ;
    gui.addSlider("newCell_size")
      .setPosition(10, 20)
        .setSize(100, 20)
          .setRange(1, 100)
            .setValue(20)
              .moveTo(gui1)
                ;
    accordionUI = gui.addAccordion("accordionUI")
      .setPosition(0, 0)
        .setWidth(200)
          .addItem(gui1)
            ;
  }
  public void draw() {
    for (int i = cells.size() - 1; i >= 0; i-- ) {
      Cell cell = (Cell) cells.get(i);
      cell.draw();
      if (! cell.isOnScreen()) {
        cells.remove(i);
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
  }
}

