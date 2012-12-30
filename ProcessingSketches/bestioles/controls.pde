// World
public int bNum = 150;
public int pNum = 2;
public int oNum = 0;
PVector  travelling = new PVector(10,0);

// Canvas
public boolean info = false; // Display information
public boolean bounded = false; // Bounded within scene2
public boolean debug = false; // Display viewing fields and more

// Agent
public float Rn = 180.0; // R neighborhood
public float maxspeed = 5.0; // Maximum speed
public float maxforce = 5.0; // Maximum steering force
public float maxpursue = 20.0; // Maximum steering force
public float maxevade = 10.0; // Maximum steering force

// Steering
public float ARadius = 100.0; // Arrival: max distance at which the agent may begin to slow down
public float ERadius = 50.0; // Evade: radius of evade range
public float WRadius = 40.0; // Wander: radius of wandering circle
public float NRadius = 0.3; // Wander: radius of wander noise circle
public float BRadius = 20.0; // Avoid: radius of agent bounding sphere
public float ORadius = 20.0; // Avoid: radius of object bounding sphere
public float CStep = 1.0/100.0; // Cohesion: move it #% of the way towards the center
public float SDistance = 80.0f; // Separation: small separation distance
public float AVelocity = 1.0/8.0; // Alignment: add a small portion to the velocity

// Weights
public float KArrive = 1.0;
public float KDepart = 1.0;
public float KPursue = 1.0;
public float KEvade = 1.0;
public float KWander = 1.0;
public float KAvoid = 5.0;
public float KFlock = 1.0;
public float KCohesion = 1.0;
public float KSeparate = 2.0;
public float KAlignment = 1.0;

//void controlUI() {
//  // Position offsets
//  int xoffset = 10;
//  int yoffset = 15;
//  int canvasoffset = 10;
//  int scene2offset = 60;
//  int agentoffset = 130;
//  int steeroffset = 230;
//  int flockoffset = 345;
//  int weightoffset = 415;
//  
//  gui = new ControlP5(this);
//  // Group menu items
//  ControlGroup ui = gui.addGroup("Settings", 585, 10, 215);
//  ui.setBackgroundColor(color(0, 200));
//  ui.setBackgroundHeight(590);
//  ui.mousePressed(); // Menu is hidden by default
//  // Increment/decrement stuff in the scene2  
//  Textlabel textWorld = gui.addTextlabel("World", "World", xoffset, scene2offset);
//  textWorld.setColorValue(color(200));
//  Slider sliderBoid = gui.addSlider("Boid Num", 0, 500, bNum, xoffset, scene2offset + yoffset*1, 100, 10);
//  Slider sliderPredator = gui.addSlider("Predator Num", 0, 100, pNum, xoffset, scene2offset + yoffset*2, 100, 10);
//  Slider sliderObject = gui.addSlider("Object Num", 0, 50, oNum, xoffset, scene2offset + yoffset*3, 100, 10);
//  // Canvas settings and more
//  Textlabel textCanvas = gui.addTextlabel("Canvas", "Canvas Options", xoffset, canvasoffset);
//  textCanvas.setColorValue(color(200));
//  Toggle toggleInfo = gui.addToggle("Info", info, xoffset + 0, canvasoffset + yoffset*1, 10, 10);
//  Toggle toggleBound = gui.addToggle("Bound", bounded, xoffset + 45, canvasoffset + yoffset*1, 10, 10);
//  Toggle toggleDebug = gui.addToggle("Debug", debug, xoffset + 90, canvasoffset + yoffset*1, 10, 10);
//  Button buttonDefault = gui.addButton("Default", 0, xoffset + 135, canvasoffset + yoffset*1, 45, 10);
//  Button buttonReset = gui.addButton("Reset", 0, xoffset + 135, canvasoffset + yoffset*2, 45, 10);
//  // Speed variables
//  Textlabel textAgent = gui.addTextlabel("Agent", "Agent", xoffset, agentoffset);
//  textAgent.setColorValue(color(200));
//  Slider sliderRn = gui.addSlider("Neighborhood", 1, 200, Rn, xoffset, agentoffset + yoffset*1, 100, 10);
//  Slider sliderMaxSpeed = gui.addSlider("Max Speed", 1, 10, maxspeed, xoffset, agentoffset + yoffset*2, 100, 10);
//  Slider sliderMaxForce = gui.addSlider("Max Force", 1, 10, maxforce, xoffset, agentoffset + yoffset*3, 100, 10);
//  Slider sliderMaxPursue = gui.addSlider("Pursue Speed", 1, 20, maxpursue, xoffset, agentoffset + yoffset*4, 100, 10);
//  Slider sliderMaxEvade = gui.addSlider("Evade Speed", 1, 20, maxevade, xoffset, agentoffset + yoffset*5, 100, 10);
//  // Steering variables
//  Textlabel textSteer = gui.addTextlabel("Steering", "Steering", xoffset, steeroffset);
//  textSteer.setColorValue(color(200));
//  Slider sliderARadius = gui.addSlider("Arrival Departure", 1, 200, ARadius, xoffset, steeroffset + yoffset*1, 100, 10);
//  Slider sliderERadius = gui.addSlider("Evasion", 1, 200, ERadius, xoffset, steeroffset + yoffset*2, 100, 10);
//  Slider sliderWRadius = gui.addSlider("Wandering", 1, 200, WRadius, xoffset, steeroffset + yoffset*3, 100, 10);
//  Slider sliderNRadius = gui.addSlider("Wandering Noise", 0.1, 1, NRadius, xoffset, steeroffset + yoffset*4, 100, 10);
//  Slider sliderBRadius = gui.addSlider("Agent Avoidance", 1, 200, BRadius, xoffset, steeroffset + yoffset*5, 100, 10);
//  Slider sliderORadius = gui.addSlider("Object Avoidance", 1, 200, ORadius, xoffset, steeroffset + yoffset*6, 100, 10);
//  // Flocking variables
//  Textlabel textFlock = gui.addTextlabel("Flocking", "Flocking", xoffset, flockoffset);
//  textFlock.setColorValue(color(200));
//  Slider sliderCStep = gui.addSlider("Cohesion Step", 0.01, 0.1, CStep, xoffset, flockoffset + yoffset*1, 100, 10);
//  Slider sliderSDistance = gui.addSlider("Separation Distance", 1, 200, SDistance, xoffset, flockoffset + yoffset*2, 100, 10);
//  Slider sliderAVelocity = gui.addSlider("Alignment Velocity", 0.01, 0.5, AVelocity, xoffset, flockoffset + yoffset*3, 100, 10);
//  // Weight constants
//  Textlabel textWeight = gui.addTextlabel("Weights", "Weights", xoffset, weightoffset);
//  textWeight.setColorValue(color(200));
//  Slider sliderKArrive = gui.addSlider("Arrive", 1, 10, KArrive, xoffset, weightoffset + yoffset*1, 100, 10);
//  Slider sliderKDepart = gui.addSlider("Depart", 1, 10, KDepart, xoffset, weightoffset + yoffset*2, 100, 10);
//  Slider sliderKPursue = gui.addSlider("Pursue", 1, 10, KPursue, xoffset, weightoffset + yoffset*3, 100, 10);
//  Slider sliderKEvade = gui.addSlider("Evade", 1, 10, KEvade, xoffset, weightoffset + yoffset*4, 100, 10);
//  Slider sliderKWander = gui.addSlider("Wander", 1, 10, KWander, xoffset, weightoffset + yoffset*5, 100, 10);
//  Slider sliderKAvoid = gui.addSlider("Avoid", 1, 10, KAvoid, xoffset, weightoffset + yoffset*6, 100, 10);
//  Slider sliderKFlock = gui.addSlider("Flock", 1, 10, KFlock, xoffset, weightoffset + yoffset*7, 100, 10);
//  Slider sliderKCohesion = gui.addSlider("Cohesion", 1, 10, KCohesion, xoffset, weightoffset + yoffset*8, 100, 10);
//  Slider sliderKSeparate = gui.addSlider("Separate", 1, 10, KSeparate, xoffset, weightoffset + yoffset*9, 100, 10);
//  Slider sliderKAlignment = gui.addSlider("Alignment", 1, 10, KAlignment, xoffset, weightoffset + yoffset*10, 100, 10);
//  // Assign ID to all menu items
//  sliderBoid.setId(1);
//  sliderPredator.setId(2);
//  sliderObject.setId(3);
//  toggleInfo.setId(4);
//  toggleBound.setId(5);
//  toggleDebug.setId(6);
//  buttonDefault.setId(7);
//  buttonReset.setId(8);
//  sliderRn.setId(9);
//  sliderMaxSpeed.setId(10);
//  sliderMaxForce.setId(11);
//  sliderMaxPursue.setId(12);
//  sliderMaxEvade.setId(13);
//  sliderARadius.setId(14);
//  sliderERadius.setId(15);
//  sliderWRadius.setId(16);
//  sliderNRadius.setId(17);
//  sliderBRadius.setId(18);
//  sliderORadius.setId(19);
//  sliderCStep.setId(20);
//  sliderSDistance.setId(21);
//  sliderAVelocity.setId(22);
//  sliderKArrive.setId(23);
//  sliderKDepart.setId(24);
//  sliderKPursue.setId(25);
//  sliderKEvade.setId(26);
//  sliderKWander.setId(27);
//  sliderKAvoid.setId(28);
//  sliderKFlock.setId(29);
//  sliderKCohesion.setId(30);
//  sliderKSeparate.setId(31);
//  sliderKAlignment.setId(32);  
//  // Add all menu items to the UI group
//  textWorld.setGroup(ui);
//  sliderBoid.setGroup(ui);
//  sliderPredator.setGroup(ui);
//  sliderObject.setGroup(ui);  
//  textCanvas.setGroup(ui);
//  toggleInfo.setGroup(ui);
//  toggleBound.setGroup(ui);
//  toggleDebug.setGroup(ui);
//  buttonDefault.setGroup(ui);
//  buttonReset.setGroup(ui);  
//  textAgent.setGroup(ui);
//  sliderRn.setGroup(ui);
//  sliderMaxSpeed.setGroup(ui);
//  sliderMaxForce.setGroup(ui);
//  sliderMaxPursue.setGroup(ui);
//  sliderMaxEvade.setGroup(ui);  
//  textSteer.setGroup(ui);
//  sliderARadius.setGroup(ui);
//  sliderERadius.setGroup(ui);
//  sliderWRadius.setGroup(ui);
//  sliderNRadius.setGroup(ui);
//  sliderBRadius.setGroup(ui);
//  sliderORadius.setGroup(ui);  
//  textFlock.setGroup(ui);
//  sliderCStep.setGroup(ui);
//  sliderSDistance.setGroup(ui);
//  sliderAVelocity.setGroup(ui);  
//  textWeight.setGroup(ui);
//  sliderKArrive.setGroup(ui);
//  sliderKDepart.setGroup(ui);
//  sliderKPursue.setGroup(ui);
//  sliderKEvade.setGroup(ui);
//  sliderKWander.setGroup(ui);
//  sliderKAvoid.setGroup(ui);
//  sliderKFlock.setGroup(ui);
//  sliderKCohesion.setGroup(ui);
//  sliderKSeparate.setGroup(ui);
//  sliderKAlignment.setGroup(ui);
//}
//
//// Restore all variables to their default values
//void restoreDefault() {
//  updateWorld(40, 2, 5);
//  gui.controller("Boid Num").setValue(bNum);
//  gui.controller("Predator Num").setValue(pNum);
//  gui.controller("Object Num").setValue(oNum);
//  info = false;
//  bounded = true;
//  debug = false;
//  gui.controller("Info").setValue((info) ? 1 : 0);
//  gui.controller("Bound").setValue((bounded) ? 1 : 0);
//  gui.controller("Debug").setValue((debug) ? 1 : 0);
//  Rn = 80.0;
//  maxspeed = 5.0;
//  maxforce = 3.0;
//  maxpursue = 20.0;
//  maxevade = 10.0;
//  gui.controller("Neighborhood").setValue(Rn);
//  gui.controller("Max Speed").setValue(maxspeed);
//  gui.controller("Max Force").setValue(maxforce);
//  gui.controller("Pursue Speed").setValue(maxpursue);
//  gui.controller("Evade Speed").setValue(maxevade);
//  ARadius = 100.0;
//  ERadius = 50.0;
//  WRadius = 40.0;
//  NRadius = 0.3;
//  BRadius = 20.0;
//  ORadius = 20.0;
//  CStep = 1.0/100.0;
//  SDistance = 80.0f;
//  AVelocity = 1.0/8.0;
//  gui.controller("Arrival Departure").setValue(ARadius);
//  gui.controller("Evasion").setValue(ERadius);
//  gui.controller("Wandering").setValue(WRadius);
//  gui.controller("Wandering Noise").setValue(NRadius);
//  gui.controller("Agent Avoidance").setValue(BRadius);
//  gui.controller("Object Avoidance").setValue(ORadius);
//  gui.controller("Cohesion Step").setValue(CStep);
//  gui.controller("Separation Distance").setValue(SDistance);
//  gui.controller("Alignment Velocity").setValue(AVelocity);
//  KArrive = 1.0;
//  KDepart = 1.0;
//  KPursue = 1.0;
//  KEvade = 1.0;
//  KWander = 1.0;
//  KAvoid = 5.0;
//  KFlock = 1.0;
//  KCohesion = 1.0;
//  KSeparate = 2.0;
//  KAlignment = 1.0;
//  gui.controller("Arrive").setValue(KArrive);
//  gui.controller("Depart").setValue(KDepart);
//  gui.controller("Pursue").setValue(KPursue);
//  gui.controller("Evade").setValue(KEvade);
//  gui.controller("Wander").setValue(KWander);
//  gui.controller("Avoid").setValue(KAvoid);
//  gui.controller("Flock").setValue(KFlock);
//  gui.controller("Cohesion").setValue(KCohesion);
//  gui.controller("Separate").setValue(KSeparate);
//  gui.controller("Alignment").setValue(KAlignment);
//}
//
//// Update the number of agents and objects in the scene2
//void updateWorld(int bn, int pn, int on) {
//  if (bn > bNum) {
//    bNum = bn;
//    while (scene2.boids.size() < bNum) {
//      Agent boid = new Agent(random(width), random(height), 1);
//      scene2.boids.add(boid);
//    }
//  }
//  else if (bn < bNum) {
//    bNum = bn;
//    while (scene2.boids.size() >  bNum) {
//      scene2.boids.remove(0);
//    }    
//  }
//  if (pn > pNum) {
//    pNum = pn;
//    while (scene2.predators.size() < pNum) {
//      Agent predator = new Agent(random(width), random(height), 2);
//      scene2.predators.add(predator);
//    }
//  }
//  else if (pn < pNum) {
//    pNum = pn;
//    while (scene2.predators.size() >  pNum) {
//      scene2.predators.remove(0);
//    }    
//  }
//  if (on > oNum) {
//    oNum = on;
//    while (scene2.objs.size() < oNum) {
//      Obj obj = new Obj(random(1, width), random(1, height), random(50, 100), round(random(1, 2)));
//      scene2.objs.add(obj);
//    }
//  }
//  else if (on < oNum) {
//    oNum = on;
//    while (scene2.objs.size() >  oNum) {
//      scene2.objs.remove(0);
//    }    
//  }
//}
//
//// Event handler
//void controlEvent(ControlEvent theEvent) {
//  switch(theEvent.controller().id()) {
//    case 1: { updateWorld((int)theEvent.controller().value(), pNum, oNum); break; }
//    case 2: { updateWorld(bNum, (int)theEvent.controller().value(), oNum); break; }
//    case 3: { updateWorld(bNum, pNum, (int)theEvent.controller().value()); break; }
//    case 4: { info = (theEvent.controller().value() == 1.0) ? true : false; break; }
//    case 5: { bounded = (theEvent.controller().value() == 1.0) ? true : false; break; }
//    case 6: { debug = (theEvent.controller().value() == 1.0) ? true : false; break; }
//    case 7: { restoreDefault(); break; }
//    case 8: { scene2 = new Scene2(this); redraw(); break; }
//    case 9: { Rn = theEvent.controller().value(); break; }
//    case 10: { maxspeed = theEvent.controller().value(); break; }
//    case 11: { maxforce = theEvent.controller().value(); break; }
//    case 12: { maxpursue = theEvent.controller().value(); break; }
//    case 13: { maxevade = theEvent.controller().value(); break; }
//    case 14: { ARadius = theEvent.controller().value(); break; }
//    case 15: { ERadius = theEvent.controller().value(); break; }
//    case 16: { WRadius = theEvent.controller().value(); break; }
//    case 17: { NRadius = theEvent.controller().value(); break; }
//    case 18: { BRadius = theEvent.controller().value(); break; }
//    case 19: { ORadius = theEvent.controller().value(); break; }
//    case 20: { CStep = theEvent.controller().value(); break; }
//    case 21: { SDistance = theEvent.controller().value(); break; }
//    case 22: { AVelocity = theEvent.controller().value(); break; }
//    case 23: { KArrive = theEvent.controller().value(); break; }
//    case 24: { KDepart = theEvent.controller().value(); break; }
//    case 25: { KPursue = theEvent.controller().value(); break; }
//    case 26: { KEvade = theEvent.controller().value(); break; }
//    case 27: { KWander = theEvent.controller().value(); break; }
//    case 28: { KAvoid = theEvent.controller().value(); break; }
//    case 29: { KFlock = theEvent.controller().value(); break; }
//    case 30: { KCohesion = theEvent.controller().value(); break; }
//    case 31: { KSeparate = theEvent.controller().value(); break; }
//    case 32: { KAlignment = theEvent.controller().value(); break; }
//  }
//}
