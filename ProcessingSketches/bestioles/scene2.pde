class Scene2 {
  PApplet parent;
  ArrayList boids;
  ArrayList predators;
  ArrayList objs;
  ArrayList tentacles;
  ArrayList splashes;
  int doDraw;

  Scene2(PApplet _parent) {
    parent = _parent;
    initAgents();
    initobjs();
  }

  // initialiser les predateurs avec le nb de creatures de la scene 1
  void initFromScene1() {
    predators = new ArrayList();
    for (int i = 0; i < scene1.cells.size(); i++) {
      Cell c = (Cell) scene1.cells.get(i);
      Agent predator = new Agent(c.x, c.y, 2);
      predators.add(predator);
    }
  }
  void initAgents() {
    // add tentacles
    tentacles = new ArrayList();
    for (int i = 0; i < bNum; i++) {
      Tentacle t = new Tentacle(random(width), random(height), 1);
      tentacles.add(t);
    }
    // Add boids
    boids = new ArrayList();
    for (int i = 0; i < bNum; i++) {
      float xrandom = random(width);
      float yrandom = random(height);
      float thetatrandom = random(360);
      Agent boid = new Agent(xrandom, yrandom, 1);
      boids.add(boid);
      Tentacle t = new Tentacle(xrandom, yrandom, thetatrandom);
      tentacles.add(t);
    }
    // Add predator
    predators = new ArrayList();
    for (int i = 0; i < pNum; i++) {
      Agent predator = new Agent(random(width), random(height), 2);
      predators.add(predator);
    }
  }
  void initobjs() {
    objs = new ArrayList();
    splashes = new ArrayList();
    // Add objects
    for (int i = 0; i < oNum; i++) {
      Obj obj = new Obj(random(1, width), random(1, height), random(50, 100));
      objs.add(obj);
    }
  }

  void draw() {
    if (doDraw != 0) {
      update();
      render();
    }
  }

  void cleanSplashes() {
    // update obstacle objects
    for (int i = splashes.size() - 1; i >= 0; i-- ) {
      Splash s = (Splash) splashes.get(i);
      //println("splash n on screen : " + i + " " + s.isOnScreen());
      if (!s.isOnScreen()) {
        //splashes.remove(i);
        println("-----------------removing splash n: " + i);
      }
    }
  }

  void update() {
    // Update agents
    for (int i = 0; i < boids.size(); i++) {
      Agent boid = (Agent) boids.get(i);
      boid.run(boids, predators, objs);

      // attach Tentacle to Boid's body
      Tentacle t = (Tentacle) tentacles.get(i);
      t.x = boid.pos.x;
      t.y = boid.pos.y;
      PVector xDirection = new PVector(1, 0);
      PVector boidDirection = boid.vel.get();
      t.theta = degrees(PVector.angleBetween(boidDirection, xDirection));
      t.update();
    }
    for (int i = 0; i < predators.size(); i++) {
      Agent predator = (Agent) predators.get(i);
      predator.run(boids, predators, objs);
      // Attach Cell to Predator's body
      Cell c = (Cell) scene1.cells.get(i);
      c.update();
      c.x = predator.pos.x;
      c.y = predator.pos.y;
    }

    // update obstacle objects
    for (int i = 0; i < splashes.size(); i++) {
      Obj o = (Obj) objs.get(i);
      o.pos.sub(travelling);
      // attach splash 
      Splash s = (Splash) splashes.get(i);
      s.x = (int) o.pos.x;
      s.y = (int) o.pos.y;
      s.update();
    }
  }

  void render() {
    // render predators
    for (int i = 0; i < predators.size(); i++) {
      // copy predator coords to cells coords
      Cell c = (Cell) scene1.cells.get(i);
      c.render();
    }

    // render tentacles
    for (int i = 0; i < tentacles.size(); i++) {
      Tentacle t = (Tentacle) tentacles.get(i);
      t.render();
    }
    // Render splash objects
    for (int i = 0; i < splashes.size(); i++) {
      Splash s = (Splash) splashes.get(i);
      s.render();
    }
    // Render info
    if (info) {
      fill(0);
      text("FPS: " + frameRate, 15, 20);
      text("Boids: " + (scene2.boids.size()), 15, 35);
      text("Predators: " + (scene2.predators.size()), 15, 50);
      text("Objects: " + (scene2.objs.size()), 15, 65);
    }
    

    
  }

  // ---------------------------------------------- OSC callbacks
  public void osc(String[] adressParts, OscMessage message) {
    //    println("---- Message to OSC SCENE 2");
    if (adressParts[2] != null) {
      String subAdress = adressParts[2].replaceAll("\\W", "");
      //      println("-- " + subAdress);
      // -----------------------
      if (subAdress.equals("draw")) {

        int val = message.get(0).intValue();
        println("------- from draw " + val);
        if (val == 1) {
          this.initFromScene1();
          this.doDraw = 1;
        } 
        else {
          this.doDraw = 0;
        }
      }
      // -----------------------
      if (subAdress.equals("travelling")) {
        println("---- scene2/travelling : " + message.get(0).intValue());
        travelling.x = message.get(0).intValue();
      }
      // -----------------------
      if (subAdress.equals("object")) {
        
        cleanSplashes();
        
        int x = width;
        int y = (int) random(1, height);
        float mass = random(20, 50);
        if ((message.get(0).floatValue() != 0)) {
          y = (int) (message.get(0).floatValue() * height) ;
        }
        if (message.get(1).floatValue() != 0) {
          mass = message.get(1).floatValue() * 100;
        }

        // create obstacle body
        Obj obj = new Obj(x, y, mass);
        this.objs.add(obj);

        // create obstacle Splash shape to attach to the obstacle body coords
        Splash splash = new Splash(this.parent, x, y, mass);
        this.splashes.add(splash);
        println("++++++++++++++++ add new splash. N = " + splashes.size());
      }
    }
  }
}

