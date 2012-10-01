import processing.core.*; 
import processing.xml.*; 

import bestioles.*; 
import controlP5.*; 
import oscP5.*; 
import netP5.*; 

import bestioles.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class bestioles extends PApplet {







ControlP5 gui;

Accordion accordionUI;

OscP5 osc_r;
int port_r = 12000; 

Globals globals;


Scene1 scene1;



public void setup() {
  size(600, 600);
  frameRate(30); 
  smooth();
  // initScene();

  // OSC listening
  osc_r = new OscP5(this, port_r);
  osc_r.plug(this, "newRandomCell", "/newCell");
  osc_r.plug(this, "newPresetCell", "/newPresetCell");  
  osc_r.plug(this, "newCell_release", "/cellRelease");   
  osc_r.plug(this, "newCell_size", "/cellSize");  
  osc_r.plug(this, "newCell_articulations", "/cellArticulations");  
  osc_r.plug(this, "newCell_shape", "/cellShape");  
  osc_r.plug(this, "newCell_rotation", "/cellRotation");   
  osc_r.plug(this, "newCell_kickPeriod", "/cellKickPeriod"); 
  osc_r.plug(this, "newCell_oneKick", "/cellKick"); 
  osc_r.plug(this, "allCells_kick", "/allCellsKick"); 

  globals = new Globals(this);
  globals.makePalettes(sketchPath("data/palettes"));
  globals.loadCellPresets();
  gui = new ControlP5(this);

  scene1 = new Scene1(this);


  //guiSetup();
}

public void draw() {
  background(0);

  //  scene1.draw();
}


// parse incoming osc
public void oscEvent(OscMessage theOscMessage) {
  String adress = new String(theOscMessage.getAddrPatternAsBytes());
  String[] adressParts = adress.split("[/]+");             // first token will be empty
  println("adr = " + adress);
  for (int i = 0; i<adressParts.length; i++) {
    println(adressParts[i]);
  }
  if (adressParts[1] != null){
    if(adressParts[1].equals("scene1"))  osc1(adressParts, theOscMessage);
    }
  }
  
//  OscArgument[] args = (OscArgument[]) theOscMessage.arguments();




public void keyPressed() {
  //  // release new cell
  //  if (key == ' '){
  //    allCells_kick();
  //    }
  //    println("nb of cells :" + cells.size());
  //
  //  // create new cell at center
  //  if (key == 'c'){
  //    newCell(width/2, height/2);
  //  }
  // create new cell at random position
  //  if (key == 'n'){
  //    scene1.newCell();
  //  }
  //    // create new random cell at random position
  //  if (key == 'r'){
  //    newRandomCell();
  //  }
  //  // kill cells
  //  if (key == 'k'){
  //    killAllCells();
  //  }
  //  
  //  // numeric keys to recall creature presets (only 3 at the moment)
  //  newPresetCell(key - 49);
}

// ------------------------------------ ROUTE OSC CONTROLS
public void osc1(String[] adressParts, OscMessage message) {
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
public void newCell_size(int s) {
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
  public void controlGUIinit() {
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

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "bestioles" });
  }
}
