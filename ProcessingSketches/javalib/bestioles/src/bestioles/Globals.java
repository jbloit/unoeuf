/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package bestioles;
import processing.core.PApplet;
import processing.core.PImage;
import java.util.ArrayList;
import java.io.File;
/**
 *
 * @author bloit
 */
public class Globals {
   public PApplet parent;
   public static int a=33;
   public static ArrayList palettes = new ArrayList();
   public static Cell newCell;  // pointer on the last created cell
   public static ArrayList cellPresets = new ArrayList(); 
   
   
   public Globals(PApplet _parent)  {
       parent = _parent;
       // make palette
   }
   
   
   // creates a set of color palettes by sampling from image files in the data/palettes folder.
public void makePalettes(String palettesFolder){
  File[] files = listFiles(palettesFolder);
 // File[] files = paletteDir.listFiles();
  if (files == null){
      parent.println("NO COLOR PALETTE FILES FOUND");
    } else {
      parent.println("Found " + files.length + " color palette files");
      for (int i = 0; i < files.length; i++) {
        File f = files[i];
        if (!f.isHidden()){  
          parent.println("Name: " + f.getName());
          parent.println("Is directory: " + f.isDirectory());
          parent.println("Size: " + f.length());
          PImage paletteImage = parent.loadImage(parent.sketchPath("data/palettes") + "/" + f.getName());
          //PImage paletteImage = loadImage(paletteDir + "/" + f.getName());

          int[] currentPalette = new int[4];
          currentPalette[0] = paletteImage.get(25, 50);
          currentPalette[1] = paletteImage.get(75, 50);
          currentPalette[2] = paletteImage.get(125, 50);
          currentPalette[3] = paletteImage.get(175, 50);
          
          palettes.add(currentPalette);
          
          parent.println("-----------------------");
        }
    }
  }
}


// pre-working code for reading presets from files. 
public void loadCellPresets(){
  // will parse a presets folder and fill presets array automatically.
  
  int numPresets = 3; // simulate for now
  
  parent.println("acces au parent");
  
  for (int i = 0; i < numPresets; i++){
      parent.println("boucle");
      CellPreset curPreset = new CellPreset(parent);
    
   //  will parse preset file and fill with corresponding value
    curPreset.bodyShape = i;
    curPreset.legShape = parent.floor(parent.random(1,5));
    curPreset.paletteIndex = parent.floor(parent.random(0, 4));   
    cellPresets.add(curPreset);   
  }
}

// This function returns all the files in a directory as an array of File objects
// This is useful if you want more info about the file
private File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}



}
