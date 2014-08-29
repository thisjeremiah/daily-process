public static boolean DEBUG = false;

class Boundry {
  public float top, bottom, left, right;
  
  //private Icon i;
  private Boundable box;
  
  public Boundry(Boundable box) {
    this.box = box;
    this.update();
  }
  
  public void update() {
     this.top = box.getBoxYPosition();
     this.bottom = box.getBoxYPosition() + box.getBoxHeight();
     this.left = box.getBoxXPosition();
     this.right = box.getBoxXPosition() + box.getBoxWidth();
  }
  
  public void draw() {
      if(!DEBUG) return;
      stroke(249, 73, 160);
      strokeWeight(1);
      strokeCap(SQUARE);
      line(0, this.top, width, this.top);
      line(0, this.bottom, width, this.bottom);
      line(this.left, 0, this.left, height);
      line(this.right, 0, this.right, height); 
  }
  
  /*
  public void update() {
    this.top = this.i.y;
    this.bottom = this.i.y+Icon.HEIGHT;
    this.left = this.i.x;
    this.right = this.i.x+Icon.WIDTH;
  }*/
  
  public boolean inside(float x, float y) {
     return ( x >= this.left &&
              x <= this.right &&
              y >= this.top &&
              y <= this.bottom );
  }
  
}

public interface Boundable {
 
 public int getBoxHeight();
 public int getBoxWidth();
 public int getBoxYPosition();
 public int getBoxXPosition();
  
}
