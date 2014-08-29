    //boolean hasInverseRelationship = (other.relationships.indexOf(this) != -1);

color ICON_BACKGROUND = color(0);

class Icon implements Boundable {
  
  public float x;
  
  public float y;
  
  static final float WIDTH = 65.0;
  
  static final float HEIGHT = WIDTH+10.0;
  
  static final float RECT_WIDTH = 45.0;
  
  static final float RECT_HEIGHT = 45.0;
  
  static final float RECT_X = (WIDTH-RECT_WIDTH)/2.0;
  
  static final float RECT_Y = (RECT_X/2.0);
  
  static final int SHADOW_WIDTH = 5;
  
  public Boundry boundry;
  
  public boolean selected;
  
  public int id;
  
  public ArrayList<Icon> relationships;
  
  public HashMap<Integer, Boolean> inverses; // Icon index => assignment
  
  private boolean drawable;
  
  private PImage icon = loadImage("Object-Icon.png");
  
  private PFont font = loadFont("DamascusBold-12.vlw");
  
  public Icon(float w, float h, int id) {
     this.x = 0.0; //(w-Icon.WIDTH) / 2.0;
     this.y = 0.0; //(h-Icon.HEIGHT) / 2.0;
     this.boundry = new Boundry(this);
     this.selected = false;
     this.drawable = false;
     this.id = id;
     this.relationships = new ArrayList<Icon>();
     this.inverses = new HashMap<Integer, Boolean>();
  }
  
  public void setDrawable(int x, int y) {
     this.drawable = true; 
     this.x = (float)x;
     this.y = (float)y;
     this.boundry.update();
  }
  
  public void setUndrawable() {
     this.drawable = false;
     this.selected = false;
  }
  
  public int getBoxHeight() {
    return (int)Icon.HEIGHT;
  }
  
  public int getBoxWidth() {
    return (int)Icon.WIDTH;
  }
  
  public int getBoxYPosition() {
    return (int)this.y;
  }
  
  public int getBoxXPosition() {
    return (int)this.x;
  }
  
  public void draw() {
    if( !this.drawable ) return;
    noStroke();
    if( this.selected ) {
      fill(255);
      rect(this.x+Icon.RECT_X, this.y+Icon.RECT_Y, Icon.RECT_WIDTH, Icon.RECT_HEIGHT);
      fill(55, 83, 108);
      rect(this.x+Icon.RECT_X+2.0, this.y+Icon.RECT_Y+2.0, Icon.RECT_WIDTH-4.0, Icon.RECT_HEIGHT-4.0);
      
      gradient((int)this.x, (int)this.y-Icon.SHADOW_WIDTH, Icon.WIDTH, (float)Icon.SHADOW_WIDTH, color(ICON_BACKGROUND), color(255), Y_AXIS); // TOP
      gradient((int)this.x-Icon.SHADOW_WIDTH, (int)this.y, (float)Icon.SHADOW_WIDTH, Icon.HEIGHT+Icon.SHADOW_WIDTH, color(ICON_BACKGROUND), color(255), X_AXIS); // LEFT
      gradient((int)(this.x+Icon.WIDTH), (int)this.y, (float)SHADOW_WIDTH, Icon.HEIGHT+Icon.SHADOW_WIDTH, color(255), color(ICON_BACKGROUND), X_AXIS); // RIGHT
      gradient((int)this.x, (int)(this.y+Icon.HEIGHT)+Icon.SHADOW_WIDTH, Icon.WIDTH, (float)Icon.SHADOW_WIDTH, color(255), color(ICON_BACKGROUND), Y_AXIS); // BOTTOM
      
    } else {
      fill(30);
      rect(this.x+Icon.RECT_X, this.y+Icon.RECT_Y, Icon.RECT_WIDTH, Icon.RECT_HEIGHT);
    }
    image(icon, this.x+Icon.RECT_X, this.y+Icon.RECT_Y, Icon.RECT_WIDTH, Icon.RECT_HEIGHT);
    noFill();
    rect(this.x, this.y+(Icon.RECT_HEIGHT+Icon.RECT_Y*2.0), Icon.WIDTH, Icon.HEIGHT-Icon.RECT_HEIGHT-(Icon.RECT_Y*2.0));
    textAlign(CENTER);
    fill(255);
    textFont(this.font, 12);
    text("Object "+(id+1), this.x, this.y+(this.RECT_HEIGHT+Icon.RECT_Y*2.0)+2.0, Icon.WIDTH, Icon.HEIGHT-Icon.RECT_HEIGHT-(Icon.RECT_Y*2.0)-2.0);
    if(this.selected) this.boundry.draw();
    for( int idx = 0; idx < this.relationships.size(); idx++ ) {
       this.drawRelationshipWithIcon(this.relationships.get(idx));
    }
  }
  
  public float mouseOffsetX = 0.0,
               mouseOffsetY = 0.0;
               
  public boolean mouseOffset = false;
  
  public void mouseDragged(float x, float y) {
     if( !this.mouseOffset ) {
       this.mouseOffsetX = (this.x-x);
       this.mouseOffsetY = (this.y-y);
       this.mouseOffset = true;
     }
     this.x = mouseX + this.mouseOffsetX;
     this.y = mouseY + this.mouseOffsetY;
     this.boundry.update();
  }
  
  public void mouseReleased() {
     println("Mouse Released");
     if(this.mouseOffset) {
        this.mouseOffset = false;
        this.mouseOffsetX = 0.0;
        this.mouseOffsetY = 0.0;
     }
  }
  
  public void drawRelationshipWithIcon(Icon other) {
    float topLeftX = this.x, topLeftY = this.y,
          topRightX = this.x+Icon.WIDTH, topRightY = this.y,
          bottomLeftX = this.x, bottomLeftY = this.y+Icon.HEIGHT,
          bottomRightX = this.x+Icon.WIDTH, bottomRightY = this.y+Icon.HEIGHT;
    
    stroke(249, 73, 160);
    strokeWeight(5);
    strokeCap(PROJECT);
    ellipseMode(RADIUS);
    fill(249, 73, 160);
    
    Boolean inverse = this.inverses.get(other.id);
    if( inverse != null ) {
       if( inverse.booleanValue() ) {
         //println("ICON("+this.id+") !IMPORTANT: WILL NOT DRAW FOR RELATIONSHIP AS INVERSE WILL TAKE CARE OF IT.");
         return;
       }
       //else println("ICON("+this.id+") !IMPORTANT: I AM THE INVERSE AND I WILL DRAW THE RELATIONSHIP.");
    }
    
    if( this.boundry.top >= other.boundry.bottom && this.boundry.left >= other.boundry.right ) {
          line(topLeftX, topLeftY, other.x+Icon.WIDTH, other.y+Icon.HEIGHT); // A
          ellipse(topLeftX, topLeftY, 4, 4);
          ellipse(other.x+Icon.WIDTH, other.y+Icon.HEIGHT, 4, 4);
    }
    else if( other.boundry.right <= this.boundry.right && this.boundry.left <= other.boundry.left && other.boundry.bottom <= this.boundry.top ) {
          line(this.x + (Icon.WIDTH/2.0), topLeftY, other.x + (Icon.WIDTH/2.0), other.boundry.bottom); // B
          ellipse(this.x + (Icon.WIDTH/2.0), topLeftY, 4, 4);
          ellipse(other.x + (Icon.WIDTH/2.0), other.boundry.bottom, 4, 4);
    }
    else if( this.boundry.top >= other.boundry.bottom && this.boundry.right <= other.boundry.left ) {
          line(topRightX, topRightY, other.x, other.y+Icon.HEIGHT); // C
          ellipse(topRightX, topRightY, 4, 4);
          ellipse(other.x, other.y+Icon.HEIGHT, 4, 4);
    }
    else if( this.boundry.right <= other.boundry.left && this.boundry.top >= other.boundry.top && this.boundry.bottom >= other.boundry.bottom ) {
          line(topRightX, this.y + (Icon.HEIGHT/2.0), other.x, other.y + (Icon.HEIGHT/2.0));  // E
          ellipse(topRightX, this.y + (Icon.HEIGHT/2.0), 4, 4);
          ellipse(other.x, other.y + (Icon.HEIGHT/2.0), 4, 4);
    }
    else if( this.boundry.right <= other.boundry.left && this.boundry.bottom <= other.boundry.top ) {
          line(bottomRightX, bottomRightY, other.x, other.y); // H
          ellipse(bottomRightX, bottomRightY, 4, 4);
          ellipse(other.x, other.y, 4, 4);
    }
    else if( this.boundry.left <= other.boundry.left && other.boundry.right <= this.boundry.right && this.boundry.bottom <= other.boundry.top ) {
          line(this.x + (Icon.WIDTH/2.0), this.y + Icon.HEIGHT, other.x + (Icon.WIDTH/2.0), other.y); // G
          ellipse(this.x + (Icon.WIDTH/2.0), this.y + Icon.HEIGHT, 4, 4);
          ellipse(other.x + (Icon.WIDTH/2.0), other.y, 4, 4);
    } 
    else if( this.boundry.bottom <= other.boundry.top && other.boundry.right <= this.boundry.left ) {
          line(bottomLeftX, bottomLeftY, other.x + Icon.WIDTH, other.y); // F
          ellipse(bottomLeftX, bottomLeftY, 4, 4);
          ellipse(other.x + Icon.WIDTH, other.y, 4, 4);
    }
    else if( this.boundry.top <= other.boundry.top && this.boundry.bottom >= other.boundry.bottom && other.boundry.right <= this.boundry.left ) {
          line(this.x, this.y + (Icon.HEIGHT/2.0),  other.x + Icon.WIDTH, other.y + (Icon.HEIGHT/2.0) ); // D
          ellipse(this.x, this.y + (Icon.HEIGHT/2.0), 4, 4);
          ellipse(other.x + Icon.WIDTH, other.y + (Icon.HEIGHT/2.0), 4, 4);
    }
    
    // The catch all since this algorithm has some problems with D, E, B, G
    else if( other.boundry.bottom <= this.boundry.top ) {
          line(this.x + (Icon.WIDTH/2.0), topLeftY, other.x + (Icon.WIDTH/2.0), other.boundry.bottom); // B
          ellipse(this.x + (Icon.WIDTH/2.0), topLeftY, 4, 4);
          ellipse(other.x + (Icon.WIDTH/2.0), other.boundry.bottom, 4, 4);
    }
    else if( this.boundry.bottom <= other.boundry.top ) {
          line(this.x + (Icon.WIDTH/2.0), this.y + Icon.HEIGHT, other.x + (Icon.WIDTH/2.0), other.y); // G
          ellipse(this.x + (Icon.WIDTH/2.0), this.y + Icon.HEIGHT, 4, 4);
          ellipse(other.x + (Icon.WIDTH/2.0), other.y, 4, 4);
    }
    else if( this.boundry.right <= other.boundry.left ) {
          line(topRightX, this.y + (Icon.HEIGHT/2.0), other.x, other.y + (Icon.HEIGHT/2.0));  // E
          ellipse(topRightX, this.y + (Icon.HEIGHT/2.0), 4, 4);
          ellipse(other.x, other.y + (Icon.HEIGHT/2.0), 4, 4);
    } else { // all thats left is that D
          line(this.x, this.y + (Icon.HEIGHT/2.0),  other.x + Icon.WIDTH, other.y + (Icon.HEIGHT/2.0) ); // D
          ellipse(this.x, this.y + (Icon.HEIGHT/2.0), 4, 4);
          ellipse(other.x + Icon.WIDTH, other.y + (Icon.HEIGHT/2.0), 4, 4);
    }
    
  }
  
}

int Y_AXIS = 1;
int X_AXIS = 2;

void gradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();
  strokeWeight(1);
  strokeCap(SQUARE);
  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
  noStroke();
}
