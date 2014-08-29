class ShowMoreButton implements Boundable {
 
   public int x;
   
   public int y;
   
   public static final int WIDTH = 20;
   
   public static final int HEIGHT = 20;
   
   public static final int LINE_HEIGHT = 4;
   
   public static final int LINE_COUNT = 3;
   
   public static final float SPACER_HEIGHT = (HEIGHT-(LINE_HEIGHT*LINE_COUNT))/(LINE_COUNT-1);
   
   public Boundry boundry;
   
   public Drawer drawer;
   
   public ShowMoreButton(int x, int y) {
      this.x = x;
      this.y = y;
      this.boundry = new Boundry(this);
   }
   
   public void update() {
     if( this.drawer.visible ) {
       this.x += this.drawer.w;
     } else {
       this.x -= this.drawer.w; 
     }
     this.boundry.update();
   }

   
    public int getBoxHeight() {
      return HEIGHT;
    }
  
    public int getBoxWidth() {
      return WIDTH;
    }
  
    public int getBoxYPosition() {
      return this.y;
    }
  
    public int getBoxXPosition() {
      return this.x;
    }
   
   public void draw() {
      this.boundry.draw();
     rectMode(CORNER);
     noStroke();
     boolean drawingLine = true;
     int pos = this.y;
     for( int row = 0; row < (LINE_COUNT+(LINE_COUNT-1)); row++ ) {
         if( drawingLine ) {
           fill(255);
           rect(this.x, pos, WIDTH, LINE_HEIGHT);
           pos += LINE_HEIGHT;
         } else {
           fill(0);
           rect(this.x, pos, WIDTH, SPACER_HEIGHT);
           pos += SPACER_HEIGHT;
         }
         drawingLine = !drawingLine;
     }
     noFill();
     
   }
   
   public void mouseClicked(int x, int y) {
    
    if( this.boundry.inside(x, y)) {
     this.drawer.toggleDrawer();
    }
     
   }
  
}
