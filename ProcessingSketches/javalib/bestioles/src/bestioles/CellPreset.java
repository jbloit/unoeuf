/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package bestioles;
import processing.core.PApplet;
/**
 *
 * @author bloit
 */


public class CellPreset{
  
  PApplet parent;  
    
  // ----- parameters to read from file
  int bodyShape; 
  int legShape;
  int paletteIndex;
  
  // ----- parameters to initparent.randomly
  float mutate; 
  int numLegs ;
  float damping ;
  int cellSize ; 
  float orientation ;
  boolean autoKick;
  int kickPeriod ;
  int timer ;
  boolean hasFocus;
  int bodyNodes ;
  float live ;
  float bodyLegProportion ;
  
  public CellPreset(PApplet _parent){
     parent = _parent; 
     mutate = parent.random(-2, 2);
      numLegs = parent.floor(parent.random(1, 4));
   damping = parent.random(0.3f, 0.8f);
   cellSize = (int) parent.random(15, 30);; 
   orientation = parent.random(0, 2*parent.PI);
   autoKick = true;
   kickPeriod = (int) parent.random(1,50);
   timer = kickPeriod;
   hasFocus = true;
   bodyNodes = (int) parent.random(3,20);
   live = parent.random(0.1f, 0.9f);
   bodyLegProportion = parent.random(1.7f, 5f);
     
  }
  
}