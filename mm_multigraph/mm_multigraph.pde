Icon selected = null;

ArrayList<Icon> icons;

IconLinker linker = null;

ShowMoreButton showMoreButton = new ShowMoreButton(20, 20);

Drawer drawer;

void setup() {
  size(800, 600);
  frameRate(20);
  icons = new ArrayList<Icon>();
  for( int i = 0; i < 10; i++ ) {
   icons.add(new Icon(width, height, i)); 
  }
  setSelectedIcon(null);
  drawer = new Drawer(icons, showMoreButton);
  frame.setResizable(true);
}

void setSelectedIcon(Icon i) {
  if( selected != null ) {
    selected.selected = false;
  }
  if( i != null ) i.selected = true;
  selected = i;
}

void draw() {
  background(ICON_BACKGROUND);
  
  
  for( int idx = 0; idx < icons.size(); idx++ ) {
    Icon i = icons.get(idx);
    i.draw();
  }
  
  if( linker != null ) {
    linker.draw(mouseX, mouseY);
  }
  
  drawer.draw();
}

void mouseClicked() {
   if( mouseButton == LEFT ) showMoreButton.mouseClicked(mouseX, mouseY); 
}

void mousePressed() {
   if( drawer.visible && drawer.boundry.inside(mouseX, mouseY) ) {
     setSelectedIcon(null);
     return;
   }
   boolean found = false;
   for( int idx = 0; idx < icons.size(); idx++ ) {
      Icon i = icons.get(idx);
      if( i.boundry.inside(mouseX, mouseY) ) {
         setSelectedIcon(i);
         found = true;
         break;
      } 
   }
   if(!found) setSelectedIcon(null);
}

void mouseMoved() {
   if( drawer.visible && drawer.boundry.inside(mouseX, mouseY) ) drawer.mouseMoved(mouseX, mouseY); 
}

void mouseDragged() {
  if( mouseButton == LEFT ) {
    if( drawer.visible ) drawer.mouseDragged(mouseX, mouseY);
    if( selected != null ) selected.mouseDragged(mouseX, mouseY); 
  }
  else if( mouseButton == RIGHT && selected != null ) {
    if( linker != null ) {
      if( drawer.visible && drawer.boundry.inside(mouseX, mouseY) ) {
          linker = null;
      }
    } else if( linker == null && selected.boundry.inside(mouseX, mouseY) ) {
       linker = new IconLinker(mouseX, mouseY);
       linker.origin = selected; 
    }
  }
  if( mouseButton == RIGHT ) drawer.removeHoverObject();
}

void mouseReleased() {
 this.drawer.mouseReleased(); 
 if( mouseButton == RIGHT && linker != null ) {
   linker.setDestination(mouseX, mouseY, icons);
   linker = null;
   redraw();
 } else if( mouseButton == LEFT && selected != null ) selected.mouseReleased();
}

void keyPressed() {
 if (keyCode == SHIFT) DEBUG = true;
}

void keyReleased() {
  if(DEBUG) DEBUG = false; 
}
