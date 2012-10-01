/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package bestioles;

import java.util.ArrayList;
import processing.core.PApplet;

/**
 *
 * @author bloit
 */
public class Scene {
    
    
    public Cell newCell; // 
    public ArrayList cells;
    private PApplet parent;
    
    
    public Scene(PApplet _parent){
        parent = _parent;
        
        cells = new ArrayList();
         
    }
    
    public void draw(){
        for (int i = cells.size() - 1; i >= 0; i-- ){
            Cell cell = (Cell) cells.get(i);
            cell.draw();
            if (! cell.isOnScreen()){
                cells.remove(i);
            }
        }
    }
    
    public void newCell(){
        this.newCell((int) parent.random(0,parent.width), (int) parent.random(0,parent.height));
    }
    
    public void newCell(int x, int y){
        newCell = new Cell(parent, x, y, 1, (int) parent.random(10, 50));
        newCell.autoKick = false;
        cells.add(newCell);
        
    }
    
    
    
}
