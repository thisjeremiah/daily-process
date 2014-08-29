class Drawer implements Boundable {
 
 public int w, x, y; 
 
 public Boundry boundry;
 
 public boolean visible;
 
 public ArrayList<Icon> icons;
 
 public ShowMoreButton button;
 
 private ArrayList<ObjectBox> boxes;
 
 public static final int BACKGROUND_COLOR = 237;
 
 private PFont objectBoxFont = loadFont("ArialNarrow-Italic-13.vlw");
 
 private ObjectBox hover = null;
 
 public Boundry outside;
 
 static final int BOX_STARTING_POSITION = 40;
 
 public Drawer(ArrayList<Icon> icons, ShowMoreButton button) {
   this.x = 0;
   this.y = 0;
   this.w = 200;
   this.boundry = new Boundry(this);
   this.visible = false;
   this.icons = icons;
   this.button = button;
   this.button.drawer = this;
   this.font = loadFont("AdobeFanHeitiStd-Bold-14.vlw");
   this.boxes = new ArrayList<ObjectBox>();
   int pos = BOX_STARTING_POSITION;
   for( int idx = 0; idx < this.icons.size(); idx++ ) {
      this.boxes.add(new ObjectBox(pos, this, this.icons.get(idx), this.objectBoxFont));
      pos += ObjectBox.BOX_POSITION_TOTAL;
   }
   this.outside = new Boundry(new Boundable() {
     
      public int getBoxHeight() {
        return height;
      }
      
      public int getBoxWidth() {
        return width-200;
      }
      
      public int getBoxYPosition() {
        return 0;
      }
      
      public int getBoxXPosition() {
        return 200;
      }
     
   });
   
 }
 
 private void updateBoxPositions() {
   int pos = BOX_STARTING_POSITION;
   for( int idx = 0; idx < this.boxes.size(); idx++ ) {
      ObjectBox box = this.boxes.get(idx);
      if( !box.disabled ) {
        box.y = pos;
        box.boundry.update();
        pos += ObjectBox.BOX_POSITION_TOTAL;
      }
   }
 }
 
 private PFont font;

 public void draw() {
   this.button.draw();
   if( !this.visible ) return;
   noStroke();
   rectMode(CORNER);
   this.boundry.draw();
   fill(BACKGROUND_COLOR);
   rect(this.x, this.y, this.w, height);
   textAlign(LEFT);
   fill(155);
   textFont(this.font, 14);
   text("OBJECTS", 10, 30);
   for( int idx = 0; idx < this.boxes.size(); idx++ ) {
      this.boxes.get(idx).draw(); 
   }
 }
 
 public void toggleDrawer() {
    this.visible = !this.visible;
    this.button.update();
    redraw();
 }
 
 public int getBoxHeight() {
      return height;
    }
  
    public int getBoxWidth() {
      return this.w;
    }
  
    public int getBoxYPosition() {
      return this.y;
    }
  
    public int getBoxXPosition() {
      return this.x;
    }
    
    public void mouseMoved(int x, int y) {
      boolean found = false;
      for( int idx = 0; idx < this.boxes.size(); idx++ ) {
        ObjectBox box = this.boxes.get(idx);
       boolean active = box.mouseMoved(x, y); 
       if( active ) {
          this.hover = box;
          if( !found ) found = true;
       }
      }
      if (!found) this.hover = null;
    }
    
    public int mouseOffsetX = 0,
               mouseOffsetY = 0;
               
  public boolean mouseOffset = false;
  
  private Integer originalBoxX, originalBoxY;
    
    public void mouseDragged(int x, int y) {
      if( this.hover != null && !this.hover.disabled ) {
         if( !this.mouseOffset ) {
       this.mouseOffsetX = (this.hover.x-x);
       this.mouseOffsetY = (this.hover.y-y);
       this.mouseOffset = true;
       this.hover.selected = true; 
       this.originalBoxX = new Integer(this.hover.x);
       this.originalBoxY = new Integer(this.hover.y);
     }
           this.hover.x = mouseX + this.mouseOffsetX;
           this.hover.y = mouseY + this.mouseOffsetY;
           this.hover.boundry.update();
        }
      
    }
    
    public void mouseReleased() {
     if(this.mouseOffset) {
        this.mouseOffset = false;
        this.mouseOffsetX = 0;
        this.mouseOffsetY = 0;
        if( this.hover != null ) {
          this.outside.update();
          if( this.outside.inside(this.hover.x, this.hover.y) ) {
              this.hover.icon.setDrawable(this.hover.x, this.hover.y);
              this.hover.disabled = true;
          }
          this.removeHoverObject();
          this.updateBoxPositions();
        }
     }
     
    }
     
     public void removeHoverObject() {
      if( this.hover != null ) {
       this.hover.selected = false;
          this.hover.hover = false;
          if( this.originalBoxX != null ) {
          this.hover.x = this.originalBoxX.intValue();
          this.originalBoxX = null;
          }
          if( this.originalBoxY != null ) {
          this.hover.y = originalBoxY.intValue();
          this.originalBoxY = null;
          }
          this.hover.boundry.update();
          this.hover = null;
      } 
     }

    
    /*
    
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
  
  */
  
}

class ObjectBox implements Boundable {
 
  public Drawer drawer;
  public int y;
  public int x;
  public Boundry boundry;
  public Icon icon;
  
  public static final int BOX_HEIGHT = 25;
  
  public static final int BOX_SPACING = 5;
  
  public static final int BOX_POSITION_TOTAL = BOX_HEIGHT+BOX_SPACING;
  
  public boolean hover = false;
  
  private PFont font;
  
  public boolean selected = false;
  
  public boolean disabled = false;
  
  public ObjectBox(int y, Drawer d, Icon i, PFont font) {
     this.y = y;
     this.x = 10;
     this.drawer = d;
     this.boundry = new Boundry(this);
     this.icon = i;
     this.font = font;
  }
  
  public boolean mouseMoved(int x, int y) {
     if( this.disabled ) return false;
     if( this.boundry.inside(x, y) ) this.hover = true;
     else this.hover = false;
     return this.hover;
  }
  
   public void draw() {
     if( this.disabled ) return;
     if( this.hover || this.selected ) this.boundry.draw();
      strokeWeight((this.hover) ? 2 : 1);
      stroke(155);
      strokeCap(ROUND);
      fill(Drawer.BACKGROUND_COLOR);
      rect(this.x, this.y, (!this.selected) ? (this.drawer.w-(this.x*2)) : (this.drawer.w), BOX_HEIGHT);
      textFont(this.font, 12);
      textAlign(LEFT);
      fill(0);
      text("Object "+(this.icon.id+1), this.x+15, this.y+17);
   }
   
    public int getBoxHeight() {
      return 20;
    }
  
    public int getBoxWidth() {
      return this.drawer.w-20;
    }
  
    public int getBoxYPosition() {
      return this.y;
    }
  
    public int getBoxXPosition() {
      return 10;
    }
  
}
