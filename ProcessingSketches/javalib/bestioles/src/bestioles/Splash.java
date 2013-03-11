/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package bestioles;

/**
 *
 * @author bloit
 */
import processing.core.PApplet;
import toxi.color.*;
import toxi.geom.*;
import toxi.processing.*;

public class Splash extends Polygon2D {

    PApplet parent;
    // number of vertices in each polygon
    int numVertices;
    TColor col;
    // center coords
    public int x;
    public int y;
    public float radius;

    public Splash(PApplet _parent, int _x, int _y, float _radius) {
        parent = _parent;
        numVertices = 30;
        x = _x;
        y = _y;
        radius = _radius;
        col = ColorRange.BRIGHT.getColor().setAlpha(parent.random(0.5f, 0.8f));

        for (int i = 0; i < numVertices; i++) {
            this.add(Vec2D.fromTheta((float) i / numVertices * parent.TWO_PI).scaleSelf(parent.random(0.2f, 1f) * radius).addSelf(0, 0));
        }
    }

    public void update() {
        // apply vertex smoothing
        this.smooth(0.08f, 0.03f);
    }

    public void render() {
        parent.pushMatrix();
        parent.translate(x, y);
        parent.fill(this.col.toARGB());
        Globals.gfx.polygon2D(this);
        parent.popMatrix();
    }

    public boolean isOnScreen() {
        // if out of screen bounds
        if ((x > (1.2 * parent.width)) || (x < (-0.2 * parent.width)) || (y > parent.height) || (y < -100)) {
            return false;
        } else {
            return true;
        }
    }
}
