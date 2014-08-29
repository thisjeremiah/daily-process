class IconLinker {
 
  public Icon origin;
  
  public float x_o, y_o;
  
  public IconLinker(float x, float y) {
   this.x_o = x;
  this.y_o = y; 
  }
  
  public void draw(float x, float y) {
    stroke(249, 73, 160);
    strokeWeight(4);
    strokeCap(ROUND);
    //line(origin.boundry.left + 10.0, origin.boundry.top + 10.0, x, y);
    line(this.x_o, this.y_o, x, y);
  }
  
  public void setDestination(float x, float y, ArrayList<Icon> icons) {
    Icon destination = null;
    for( int idx = 0; idx < icons.size(); idx++ ) {
       Icon i = icons.get(idx);
       if( i.boundry.inside(x, y) ) {
         destination = i;
         break;
       }
    }
    if( destination != null ) {
     if( origin.relationships.indexOf(destination) == -1 && destination != origin ) {
       
       //boolean hasInverseRelationship = (destination.relationships.indexOf(origin) != -1);
       if( destination.relationships.indexOf(origin) != -1 ) {
          // on origin we need to set the drawing mode for the index to arrow only
          origin.inverses.put(new Integer(destination.id), new Boolean(true));
          destination.inverses.put(new Integer(origin.id), new Boolean(false));
       }
       
       origin.relationships.add(destination);
     }
    }
  }
  
}

/*

  public void makeRelationship(Icon i = destination) {
     if( origin.relationships.indexOf(destination) == -1 && destination != origin ) {
         //boolean hasInverseRelationship = (destination.relationships.indexOf(origin) != -1);
         origin.relationships.add(destination);
     }
  }
  
  */
