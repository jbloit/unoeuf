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
public class Leg {
    
  PApplet parent;
  public int legShape ;
  public int numberOfSegments ;                             // each segment is articulated in 2 lines
  public int segmentSize ;                                // size of first segment
  public float orientation ;                  // leg orientation on body
  public float startAngle ;              // angle in folded position
  public float angle ;                             // drives the leg folding
  public int kickIndex;
  public boolean kick ;
  public float kickSpeed;
  public int paletteIndex;
  public int[] palette ; 

Leg(PApplet _parent, int _legShape) {
    parent = _parent;
    legShape = _legShape;
    legShape = 0;
    numberOfSegments = 1;                             // each segment is articulated in 2 lines
    segmentSize = 40;                                // size of first segment
    orientation = parent.random(0, 2 * parent.PI);                  // leg orientation on body
    startAngle = parent.random(parent.PI / 4, parent.PI / 2);              // angle in folded position
    angle = startAngle;                             // drives the leg folding
    kickIndex = -50;
    kick = false;
    paletteIndex = 0;
    palette = (int[]) Globals.palettes.get(paletteIndex);



}
   
 public void setPalette(int _paletteIndex){
   if (paletteIndex != _paletteIndex){
     palette = (int[]) Globals.palettes.get(_paletteIndex);  
     paletteIndex = _paletteIndex;
   }
 }
 
  // set kicking state
  void kick(float _speed){
    kickSpeed = _speed;
    kick = true;
  }
  
  // drive the kick angle
  void kickDrive(){  
      kickIndex += 1.0 * kickSpeed;
      angle = parent.abs( startAngle * (kickIndex / 50) );
      // reinit kick when done
      if (kickIndex > 50){
        kick = false;
        angle = startAngle;
        kickIndex = -50;
      }
  }
  
  void stripes(float x1, float y1, float x2, float y2, int spacing, int stripeWidth){
    PVector v1 = new PVector(x1, y1);
    PVector v2 = new PVector(x2, y2);
    PVector v3 = PVector.sub(v1, v2);
    float beta = parent.atan(v3.y/v3.x);
    float len = v3.mag();  
    int N = parent.floor(len / (spacing * 2)) ;
    float trueSpacing = len / (N*2);
    parent.pushMatrix();
    parent.translate(v1.x, v1.y);
    if (x1<x2) parent.rotate(beta); else parent.rotate( beta - parent.PI);
    for (int i = 0; i < N; i++){
      parent.fill(0,0);
      parent.rect(i*2*trueSpacing, 0, trueSpacing, stripeWidth);
      parent.fill(palette[0],256);
      parent.rect(i*2*trueSpacing + trueSpacing, 0, trueSpacing,stripeWidth);      
    }
    parent.popMatrix();
  }
  
  // recursive tree by Daniel Shiffman :
  void branch(float h, int thresh, float theta) {
    // Each branch will be 2/3rds the size of the previous one
    h *= 0.66;
       
    // All recursive functions must have an exit condition!!!!
    // Here, ours is when the length of the branch is 2 pixels or less
    
    if (h > thresh) {
  
      parent.pushMatrix();    // Save the current state of transformation (i.e. where are we now)
      parent.rotate(theta);   // Rotate by theta
      parent.line(0, 0, 0, -h);  // Draw the branch
      parent.translate(0, -h); // Move to the end of the branch
      branch(h, thresh, theta);       // Ok, now call myself to draw two new branches!!
      parent.popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
      
      // Repeat the same thing, only branch off to the "left" this time!
      parent.pushMatrix();
      parent.rotate(-theta);
      parent.line(0, 0, 0, -h);
      parent.translate(0, -h);
      branch(h, thresh, theta);
      parent.popMatrix();
    } 
  }  
    // recursive tree by Daniel Shiffman :
  void rightAntenna(float h, int thresh, float theta) {
    // Each branch will be 2/3rds the size of the previous one
    h *= 0.66;
       
    // All recursive functions must have an exit condition!!!!
    // Here, ours is when the length of the branch is 2 pixels or less
    if (h > thresh) {
  
      parent.pushMatrix();    // Save the current state of transformation (i.e. where are we now)
      parent.rotate(theta);   // Rotate by theta
      parent.line(0, 0, 0, -h);  // Draw the branch
      parent.translate(0, -h); // Move to the end of the branch
      rightAntenna(h, thresh, theta);       // Ok, now call myself to draw two new branches!!
      parent.popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
    } 
  } 
      // recursive tree by Daniel Shiffman :
  void leftAntenna(float h, int thresh, float theta) {
    // Each branch will be 2/3rds the size of the previous one
    h *= 0.66;
       
    // All recursive functions must have an exit condition!!!!
    // Here, ours is when the length of the branch is 2 pixels or less
    if (h > thresh) {
      parent.pushMatrix();
      parent.rotate(-theta);
      parent.line(0, 0, 0, -h);
      parent.translate(0, -h);
      leftAntenna(h, thresh, theta);
      parent.popMatrix();
    } 
  } 
  
    void weirdAntenna(float h, int thresh, float theta) {
    // Each branch will be 2/3rds the size of the previous one
    h *= 0.66;
       
    // All recursive functions must have an exit condition!!!!
    // Here, ours is when the length of the branch is 2 pixels or less
    if (h > thresh) {
      parent.pushMatrix();
      float coin = parent.random(0,1);
      if (coin < 0.5) parent.rotate(-theta); else  parent.rotate(theta);
      parent.line(0, 0, 0, -h);
      parent.translate(0, -h);
      weirdAntenna(h, thresh, theta);
      parent.popMatrix();
    } 
  } 
  
  
  
  // display leg  
  void draw(int legIndex){
    float articulationX, articulationY;
    float currentPos = 0;  // position of next segment to draw on leg axis
    
    // animate leg
    if (kick){
      kickDrive();
    }else{
      angle = startAngle;
    }
    
    
    switch(legShape){
    
     case 0: //standard
        for (int i = 0; i < numberOfSegments; i++){
          float segmentLen = segmentSize / (i + 1);
          articulationX = segmentLen * parent.cos (angle) ;
          articulationY = segmentLen * parent.sin (angle) ;
          //strokeWeight(1* (numberOfSegments - i));
  
          parent.stroke(palette[legIndex % 4]);
          parent.line(currentPos, 0, articulationX + currentPos, articulationY);
          parent.line(articulationX + currentPos, articulationY, (articulationX * 2) + currentPos, 0);
          currentPos += articulationX * 2;
        }
        // draw foot
        parent.fill (palette[3]);
        parent.noStroke();
        parent.ellipse(currentPos, 0, 3, 20); 
        break;
      
      case 1: // robot
        for (int i = 0; i < numberOfSegments; i++){
          float segmentLen = segmentSize / (i + 1);
          articulationX = segmentLen * parent.cos (angle) ;
          articulationY = segmentLen * parent.sin (angle) ;
          
          parent.stroke(palette[legIndex % 4]);
          parent.line(currentPos, 0, articulationX + currentPos, articulationY);
          parent.line(articulationX + currentPos, articulationY, (articulationX * 2) + currentPos, 0);
          parent.noFill();
          parent.ellipse(currentPos, 0, 2, 2);
          parent.ellipse(articulationX + currentPos, articulationY, 5, 5);
           currentPos += articulationX * 2;
          }
        // draw foot
        parent.fill (palette[3]);
        parent.noStroke();
        parent.ellipse(currentPos, 0, 3, 20); 
        break;       

       
        case 2: // stripes
          for (int i = 0; i < numberOfSegments; i++){
            float segmentLen = segmentSize / (i + 1);
            articulationX = segmentLen * parent.cos (angle) ;
            articulationY = segmentLen * parent.sin (angle) ;
          
            parent.stroke(palette[legIndex % 4]);
            stripes(currentPos, 0, articulationX + currentPos, articulationY, 10 - i, 5);
            stripes(articulationX + currentPos, articulationY, (articulationX * 2) + currentPos, 0, 10 - i, 5);
            parent.noFill();
            parent.ellipse(currentPos, 0, 2, 2);
            parent.ellipse(articulationX + currentPos, articulationY, 5, 5);
             currentPos += articulationX * 2;
          }
          // draw foot
          parent.fill (palette[3]);
          parent.noStroke();
          parent.ellipse(currentPos, 0, 3, 20); 
          break; 
          
        case 3: // fly wing
          parent.stroke(palette[legIndex % 4]);
          parent.line(0,0,0,-segmentSize);
          parent.translate(0,-segmentSize);
          branch(segmentSize, ((11-numberOfSegments)*3), angle*0.3f);
          break;           
          
        case 4: // half fly wing (antenna)
          parent.stroke(palette[legIndex % 4]);
          parent.line(0,0,0,-segmentSize);
          parent.translate(0,-segmentSize);
          rightAntenna(segmentSize, ((11-numberOfSegments)*3), angle);
          break;            
        case 5: // half fly wing (antenna)
          parent.stroke(palette[legIndex % 4]);
          parent.line(0,0,0,-segmentSize);
          parent.translate(0,-segmentSize);
          leftAntenna(segmentSize, ((11-numberOfSegments)*3), angle);
          break;  
        case 6: // flickering antenna 
          parent.stroke(palette[legIndex % 4]);
          parent.line(0,0,0,-segmentSize);
          parent.translate(0,-segmentSize);
          weirdAntenna(segmentSize, ((11-numberOfSegments)*3), angle);
          break;            
      }
      

  }




}