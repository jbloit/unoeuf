/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package bestioles;
import processing.core.PApplet;
import processing.core.PVector;
import java.util.ArrayList;

/**
 *
 * @author bloit
 */
public class Cell {
 
    
 PApplet parent;
 
 public int bodyShape; 
 public float mutate ; 
 
 public int numLegs ;
 public float x, y;
 public float vx, vy;
 public float ax, ay;
 public float damping ;
 public float vr ;
 public int cellSize ;
 public float bodyLegProportion ;
 
 public ArrayList bodyLegs ; 
// float orientation = random(0, 2*PI);
 public float orientation ;
 public boolean autoKick;
 public int kickPeriod ;
 public int timer;
 public boolean hasFocus ;
 // for body shape
 public int bodyNodes ;
 public float live ; 
 public int paletteIndex ;
 public int[] bodyPalette; 
 
public Cell(PApplet _parent, int _x, int _y, int _numLegs, int _kickPeriod) {
    parent = _parent;
    x = (float) _x;
    y = (float) _y;
    numLegs = _numLegs;
    kickPeriod = _kickPeriod;
    bodyLegs = new ArrayList();
    for (int i = 0; i < numLegs; i++) {
        bodyLegs.add(new Leg(parent, 0));
    }

    bodyShape = 0;
    mutate = -0.8f;
    damping = 0.2f;
    vr = 0;
    cellSize = 20;
    bodyLegProportion = 3;



// float orientation = random(0, 2*PI);
    orientation = 0;
    autoKick = true;
    timer = kickPeriod;
    hasFocus = true;
    // for body shape
    bodyNodes = 5;
    live = 0.4f;
    paletteIndex = 0;
    bodyPalette = (int[]) Globals.palettes.get(paletteIndex);
}

 public void setPalette(int _paletteIndex){
   if (paletteIndex != _paletteIndex){
     bodyPalette = (int[]) Globals.palettes.get(_paletteIndex);  
     paletteIndex = _paletteIndex;
   }
 }
 
 // 
 public void set_numLegs(int _numLegs){
   if ((_numLegs > 0) && (_numLegs != numLegs)) {
    Leg oneleg = (Leg) Globals.newCell.bodyLegs.get(0);
    int curLegShape =  oneleg.legShape;
    int curLegPalette =  oneleg.paletteIndex;
     
    if (_numLegs > numLegs){
      int toAdd = _numLegs - numLegs;
       numLegs = _numLegs;
      //println("adding " + toAdd + " legs");
      for (int i = 0; i < toAdd; i++){
        Leg addedLeg = new Leg(parent, curLegShape);
        addedLeg.setPalette(curLegPalette);
        
        bodyLegs.add(addedLeg);
        
        
        parent.println("adding leg with palette nb " + curLegPalette);
      }
    } else {
      int toRemove = numLegs - _numLegs;
      // println("amputating " + toRemove + " legs");
      numLegs = _numLegs;
      for (int i = 0; i < toRemove; i++){
        bodyLegs.remove(bodyLegs.size() - 1);
      }
    }
   }
 }
 
 public void kick(){
    for (int i = 0; i < numLegs; i++){
      
      float doKick = parent.random(0,1);
      
      if (doKick > 0.5){
        float speed = parent.random(5, 30);
        vr += parent.random(-0.05f, 0.05f);
        Leg leg = (Leg) bodyLegs.get(i);
        leg.kick(speed);
        this.legPropel(leg, speed);
      }
  }
 }
 
 // forces kick on one of the legs
  public void oneKick(){
    int i = parent.floor(parent.random(0, numLegs));
    float speed = parent.random(5, 30);
    vr += parent.random(-0.05f, 0.05f);
    Leg leg = (Leg) bodyLegs.get(i);
    leg.kick(speed);
    this.legPropel(leg, speed);
 }

 
 
 // leg action upon body motion
 public void legPropel(Leg leg, float speed){
   speed *= 0.1;
   ax += speed * parent.cos ( leg.orientation );
   ay += speed * parent.sin ( leg.orientation );
 }
 
 public void update(){
   orientation += vr;
   // physics
   this.vx -= this.ax;
   this.vy -= this.ay;
   
   this.x += this.vx;
   this.y += this.vy;
   
   this.ax *= 0.8;
   this.ay *= 0.8;
   
   this.vx *= (1-damping);
   this.vy *= (1-damping);
   
   this.vr *= 0.98;
   
   // autokick   
   timer --;
   if ( (timer < 0) && (autoKick)){
     this.kick();
     timer = kickPeriod;
   }
 } 
 
  public boolean isOnScreen(){
   if ((x > parent.width) || ( x < 0 ) || (y > parent.height) || (y < 0) ) {
     return false;
   }
   else { return true;}
 }
 
  public void render(){
    parent.pushMatrix();
    parent.translate(this.x, this.y);
    parent.rotate(this.orientation);
    
    //draw legs
    for (int i = 0; i < numLegs; i++){
      Leg leg = (Leg) bodyLegs.get(i);    
      parent.pushMatrix();
      parent.rotate(leg.orientation);
      leg.segmentSize = (int) bodyLegProportion * cellSize;
      leg.draw(i);
      parent.popMatrix();
    }
    
    switch(bodyShape){
      case 0:
        drawPotatoid();
        break;
      case 1:
        drawTriangleRing();
        break;   
      case 2:
        drawClam();
        break;      
    }
        
    // render center
    parent.ellipse(0,0,10,10);

    parent.popMatrix();
 }
 
 // ------------------------------- potatoe shape
 void drawPotatoid(){
    // render body
    float curAngle = 0;
    float rotAngle = 2*parent.PI/bodyNodes;
    PVector[] nodes = new PVector[bodyNodes];

    for (int i = 0; i < bodyNodes; i++){
      nodes[i] = new PVector (parent.cos(curAngle) * cellSize + parent.random(-1, 1), parent.sin(curAngle) * cellSize + parent.random(-1, 1));
      curAngle += rotAngle;
    }
    parent.curveTightness(mutate);
    
    if (hasFocus){
      parent.stroke (255); 
      parent.fill(bodyPalette[0]);}
    else {
      parent.stroke(bodyPalette[3]);
      parent.fill(bodyPalette[0], 200);}
    
    // render membrane
    parent.beginShape();
    int curveIndex = 0;
    for (int i=0; i < bodyNodes + 3 ; i++){
      curveIndex = i % bodyNodes;
      parent.curveVertex(nodes[curveIndex].x, nodes[curveIndex].y);
    }
    parent.endShape(parent.CLOSE);
    
    // render nucleus
    parent.fill(bodyPalette[2], 140);
    parent.beginShape();
    for (int i=0; i < bodyNodes + 3 ; i++){
       curveIndex = i % bodyNodes;
      PVector temp = new PVector(nodes[curveIndex].x, nodes[curveIndex].y);
      temp.mult(live);
      parent.curveVertex(temp.x, temp.y);
    }
    parent.endShape(parent.CLOSE);
 }
 // ------------------------------- diaphragm
 void drawTriangleRing(){
    // render body
    float curAngle = 0;
    float rotAngle = 2*parent.PI/bodyNodes;
    PVector[] nodes = new PVector[bodyNodes];

    for (int i = 0; i < bodyNodes; i++){
      nodes[i] = new PVector (parent.cos(curAngle) * cellSize + parent.random(-1, 1), parent.sin(curAngle) * cellSize + parent.random(-1, 1));
      curAngle += rotAngle;
    }
    parent.curveTightness(mutate);
    
    if (hasFocus){
      parent.stroke (255); 
      parent.fill(255,0, 0);}
    else {
      parent.stroke(255,0,0);
      parent.fill(255, 200);}
    
    // render membrane
    parent.beginShape(parent.TRIANGLE_STRIP);
    int curveIndex = 0;
    for (int i=0; i < bodyNodes + 3 ; i++){
      curveIndex = i % bodyNodes;
      parent.vertex(nodes[curveIndex].x, nodes[curveIndex].y);
    }
    parent.endShape(parent.CLOSE);
    
        parent.fill(0,100,0, 140);
    parent.beginShape(parent.TRIANGLE_STRIP);
    for (int i=0; i < bodyNodes + 3 ; i++){
       curveIndex = i % bodyNodes;
      PVector temp = new PVector(nodes[curveIndex].x, nodes[curveIndex].y);
      temp.mult(live);
      parent.vertex(temp.x, temp.y);
    }
    parent.endShape(parent.CLOSE);
 } 
 
 
 
// ------------------------------- clam 
  void drawClam(){
    // render body
    float curAngle = 0;
    
    PVector[] nodes = new PVector[4];

    nodes[0] = new PVector (0, -cellSize*2);
    nodes[1] = new PVector (-cellSize/2 + parent.random(-1, 1), parent.random(-1, 1));
    nodes[2] = new PVector (0, cellSize + parent.random(-1, 1));
    nodes[3] = new PVector (cellSize/2 + parent.random(-1, 1), parent.random(-1, 1));

    
    parent.curveTightness(mutate);
    
    if (hasFocus){
      parent.stroke (255); 
      parent.fill(255,0, 0);}
    else {
     // noStroke();
     parent.stroke(255,0,0);
     parent.fill(255, 200);}
    
    // render membrane
    parent.fill(bodyPalette[0],200);
    parent.beginShape();
    int curveIndex = 0;
    for (int i=0; i < 7 ; i++){
      curveIndex = i % 4;
      parent.curveVertex(nodes[curveIndex].x, nodes[curveIndex].y);
    }
    parent.endShape(parent.CLOSE);
    
    for (int k = 0; k < 4; k++){
      nodes[0].mult(live);
      parent.fill(bodyPalette[k],200);
      parent.beginShape();
       curveIndex = 0;
      for (int i=0; i < 7 ; i++){
        curveIndex = i % 4;
        parent.curveVertex(nodes[curveIndex].x, nodes[curveIndex].y);
      }
      parent.endShape(parent.CLOSE);
    }
 } 
}