// obstacles in boids world
class Obj {
  PVector pos;
  float mass;
  int type;

  Obj(float px, float py, float m) {
    pos = new PVector(px, py);
    mass = m;
    type = 1;
  }
}
