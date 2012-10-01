import bestioles.*;

import controlP5.*;
import oscP5.*;
import netP5.*;

ControlP5 gui;

Accordion accordionUI;

OscP5 osc_r;
int port_r = 12000; 

Globals globals;


Scene1 scene1;



void setup() {
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

void draw() {
  background(0);

  //  scene1.draw();
}


// parse incoming osc
void oscEvent(OscMessage theOscMessage) {
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




void keyPressed() {
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

