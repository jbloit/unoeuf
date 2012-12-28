/**
* Architecture : 
*
* Graphic animation components are defined in a separate java library "bestioles.jar".
* The show is arganized as a sequence of scene objects, that can be displayed at the same time.
* A scene object instantiates graphic components and exposes an OSC interface to set these objects in motion.
* Each scene object has a draw property to define if it is active at a certain time in the show.
* The OSC messages are typically sent by a companion Max/MSP patch, that triggers motions depending on an audio analysis layer.
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
Scene2 scene2;

void setup() {
  size(800, 600);
  background(0);
  frameRate(30); 
  smooth();

  osc_r = new OscP5(this, port_r);
  
  globals = new Globals(this);
  globals.makePalettes(sketchPath("data/palettes"));
  globals.loadCellPresets();
  // gui = new gui(this);
  scene1 = new Scene1(this);
  scene2 = new Scene2(this);
  //guiSetup();
}

void draw() {
  background(0);
  scene2.draw();
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
    
      // add an object
  if (key == 'o') {
    Obj obj = new Obj(width, random(1, height), random(50, 100), round(random(1, 2)));
     scene2.objs.add(obj);
    redraw();
  }
  
  if (key == '1') {
      scene1.doDraw = 1;
  }
  if (key == '2') {
    scene2.doDraw = 0;
    scene2.initFromScene1();
    scene2.doDraw = 1;
  }  
    
  //  
  //  // numeric keys to recall creature presets (only 3 at the moment)
  //  newPresetCell(key - 49);
}

