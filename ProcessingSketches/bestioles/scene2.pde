class Scene2 {
  PApplet parent;
  ArrayList boids;
  ArrayList predators;
  ArrayList objs;
  ArrayList tentacles;
  int doDraw;
 
  Scene2(PApplet _parent) {
    parent = _parent;
      initAgents();
      initobjs();
  }

   // initialiser les predateurs avec le nb de creatures de la scene 1
  void initFromScene1(){
    predators = new ArrayList();
    for (int i = 0; i < scene1.cells.size(); i++){
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
    // Add objects
    for (int i = 0; i < oNum; i++) {
      Obj obj = new Obj(random(1, width), random(1, height), random(50, 100), round(random(1, 2)));
      objs.add(obj);
    }
  }

  void draw() {
    if (doDraw != 0) {
    update();
    render();
    }
  }

  void update() {
    // Update agents
    for (int i = 0; i < boids.size(); i++) {
      Agent boid = (Agent) boids.get(i);
      boid.run(boids, predators, objs);
      
      Tentacle t = (Tentacle) tentacles.get(i);
      t.x = boid.pos.x;
      t.y = boid.pos.y;
      PVector xDirection = new PVector(1, 0);
      PVector boidDirection = boid.vel.get();
      t.theta = degrees(PVector.angleBetween(boidDirection,xDirection));

      t.update();

      
    }
    for (int i = 0; i < predators.size(); i++) {
      Agent predator = (Agent) predators.get(i);
      predator.run(boids, predators, objs);
      // copy predator coords to cells coords
      
      Cell c = (Cell) scene1.cells.get(i);
      c.update();
      c.x = predator.pos.x;
      c.y = predator.pos.y;
    }
    
    // updated objects
    for (int i = 0; i < objs.size(); i++) {
      Obj o = (Obj) objs.get(i);
      o.pos.sub(travelling);
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
    // Render objects
    for (int i = 0; i < objs.size(); i++) {
      Obj obj = (Obj) objs.get(i);

      if (obj.type == 1) {
        fill(200, 180, 160);
        stroke(50, 30, 20);
        ellipse(obj.pos.x, obj.pos.y, obj.mass, obj.mass);
      }
      else if (obj.type == 2) {
        fill(120, 190, 150);
        stroke(80, 70, 40);
        ellipse(obj.pos.x, obj.pos.y, obj.mass, obj.mass);
      }
      // Debug mode
      if (debug) {
        // Neighborhood radius
        fill(100, 100, 100, 30);
        noStroke();
        ellipse(obj.pos.x, obj.pos.y, obj.mass + ORadius*2, obj.mass + ORadius*2);
      }
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
        if (val == 1){
          this.initFromScene1();
          this.doDraw = 1;
        } else {
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
        Obj obj = new Obj(width, random(1, height), random(50, 100), round(random(1, 2)));
        this.objs.add(obj);
      }
      
    }
  }

  
}
