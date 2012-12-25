/**
* Architecture : 
*
* Graphic animation components are defined in a separate java library "bestioles.jar".
* The show is arganized as a sequence of scene objects, that can be displayed at the same time.
* A scene object instantiates graphic components and exposes an OSC interface to put these objects in motion.
* Each scene object has a draw property to define if it is active at a certain time in the show.
* The OSC messages are tipically sent by a companion Max/MSP patch, that triggers motions depending on an audio analysis layer.
* 
* julien@jbloit.com, 2012.
**/


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

  osc_r = new OscP5(this, port_r);
  
  globals = new Globals(this);
  globals.makePalettes(sketchPath("data/palettes"));
  globals.loadCellPresets();
  // gui = new ControlP5(this);
  scene1 = new Scene1(this);
  //guiSetup();
}

void draw() {
  background(0);
  scene1.draw();
}

// parse incoming osc
void oscEvent(OscMessage theOscMessage) {
  String adress = new String(theOscMessage.getAddrPatternAsBytes());
  String[] adressParts = adress.split("[/]+");             // first token will be empty
  println("adr = " + adress);
  for (int i = 0; i<adressParts.length; i++) {
    println(adressParts[i]);
  }
  if (adressParts[1] != null) {
    if (adressParts[1].equals("scene1"))  scene1.osc(adressParts, theOscMessage);
  }
}

void keyPressed() {
  //  // release new cell
    if (key == ' '){
      scene1.allCells_kick();
      }
  //  // create new cell at center
  if (key == 'c') {
    scene1.newCell(width/2, height/2);
  }
  // create new cell at random position
  if (key == 'n') {
    scene1.newRandomCell();
  }
  //    // create new random cell at random position
    if (key == 'r'){
      scene1.newRandomCell();
    }
  //  // kill cells
    if (key == 'k'){
      scene1.clear();
    }
  //  
  //  // numeric keys to recall creature presets (only 3 at the moment)
  //  newPresetCell(key - 49);
}

