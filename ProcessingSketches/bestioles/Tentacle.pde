// The Tentacle class
class Tentacle {

  int numNodes = (int) random(5,15);        // total number of nodes
  PVector[] nodes = new PVector[numNodes];
  float x, y;               // current location

  float head = 2 + random(4);        // the general size
  float girth = 8 + random(12);      // the general speed
  float speedCoefficient = .09 + random(10) / 500;  // locomotion efficiency (0 - 1)
  float friction = 0.9 + random(10) / 100;          // the viscosity of the water (0 - 1)
  float muscleRange = 20 + random(50);              // muscular range
  float muscleFreq = 0.1 + random(100) / 250;       // muscular frequency
  float tv, theta;
  int count;
  int ext = 50;                      // boundary bleeding

  // constructor
  Tentacle (float xLoc, float yLoc, float initTheta) {
    x = xLoc;
    y = yLoc;
    theta = initTheta;

    for (int n = 0; n < numNodes; n++) {
      nodes[n] = new PVector(0, 0);
    }
  }

  void update() {
    float thetaMuscle;
    float dx, dy, d;

    // directional node with orbiting handle
    // arbitrary direction
    tv += 0.5 * (random(10) - random(10)) / 10.0;
   // theta += tv;
    tv *= friction;


    nodes[0].x = head * cos(radians(theta));
    nodes[0].y = head * sin(radians(theta));

    // muscular node
    count += muscleFreq;
    thetaMuscle = muscleRange * sin(count);
    nodes[1].x = -head * cos(radians(theta + thetaMuscle));
    nodes[1].y = -head * sin(radians(theta + thetaMuscle));

    // apply kinetic forces down through body nodes
    for (int i = 2; i < nodes.length; i++) {
      dx = nodes[i].x - nodes[i - 2].x;
      dy = nodes[i].y - nodes[i - 2].y;

      d = sqrt(dx * dx + dy * dy);
      nodes[i].x = nodes[i - 1].x + (dx * girth) / d;
      nodes[i].y = nodes[i - 1].y + (dy * girth) / d;

      // check if muscle node is outside of viewable window
      if (i == 2) {
        x -= dx * speedCoefficient;
        y -= dy * speedCoefficient;

        if (x < -ext) { 
          x = width + ext; 
        }
        if (x > width + ext) { 
          x = -ext; 
        }
        if (y < -ext) { 
          y = height + ext; 
        }
        if (y > height + ext) { 
          y = -ext; 
        }
      }
    }
  }

  void render() {
    stroke(255);

    pushMatrix();
    translate(x, y);
    // draw nodes using lines	
    for (int i = 1; i < numNodes; i++) {
      // this.lineStyle((this.numNodes/(i-1))*1.5, 0xFFFFFF, 100);  // with head
      // this.lineStyle((this.numNodes-i), 0xFFFFFF, 100);  // with no head
      strokeWeight(sq(numNodes - i) / 20);
      line(nodes[i-1].x, nodes[i-1].y, nodes[i].x, nodes[i].y);
      strokeWeight(1);
    }
    popMatrix();
  }

}


