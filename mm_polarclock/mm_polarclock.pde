import com.steadystate.css.parser.CSSOMParser;
import org.w3c.css.sac.InputSource;
import org.w3c.dom.css.CSSStyleSheet;
import org.w3c.dom.css.CSSRuleList;
import org.w3c.dom.css.CSSRule;
import org.w3c.dom.css.CSSStyleRule;
import org.w3c.dom.css.CSSStyleDeclaration;
import java.io.*;

int DOCUMENT_WIDTH = 600
,   DOCUMENT_HEIGHT = DOCUMENT_WIDTH
,   TRACK_WIDTH = 60
,   TRACK_SPACING = 40
,   INITIAL_PADDING = 20
;

HashMap<Integer, HashMap<String, Integer>> stylesheet;
color backgroundColor = color(63);

void setup()
{ 
  
  // P3D rendering mode uses OpenGL which offers better smoothing than P2D (default).
  size(DOCUMENT_WIDTH, DOCUMENT_HEIGHT, P3D);
  
  // Set the framerate to something reasonable. No it cannot simply be 1 (this was suggested
  // as the fastest thing updating in this drawing of a clock happens at the second) becuase
  // we want a smooth animation between one second to the next. Ideally we could change the
  // frame rate as the draw() function calls so that we load fast and slow down but I do not
  // know if this can be done or what side effects exist. Someone at sometime should do some
  // testing on this. @thisjeremiah
  frameRate(2);
  
  // The stylesheet needs to be parsed so we know how to style the polar clock.
  stylesheet = parseStylesheet();
  
  background(backgroundColor);
  
  // We do not use strokes (ugly) and we want all the smoothing we can get (4 with P3D).
  noStroke();
  smooth(4);
  
}

void draw()
{
  
  // It is easier to draw circles if origin is center of screen.
  // Putting this in drawArc() or setup() has different implications.
  // Again, someone at sometime should get to the bottom of why that is.
  translate(width / 2.0, height / 2.0);
  
  // First argument is the order of which the arc should appear. The higher
  // the id the smaller the arc which corresponds to the arc being "inside"
  // of the arc with a higher (+1) id. The second argument is the percent
  // complete between 0 and 100 inclusive. Both values are integers.
  drawArc(0, (int)( ( second() / 59.0 ) * 100 ) );
  drawArc(1, (int)( ( minute() / 59.0 ) * 100 ) );
  drawArc(2, (int)( ( hour() / 23.0 ) * 100 ) );
  drawArc(3, (int)( ( ( day() - 1 ) / 30.0 ) * 100 ) );
  drawArc(4, (int)( ( ( month() - 1 ) / 12.0 ) * 100 ) );
  
}

void drawArc(int id, int percent)
{
  
  HashMap<String, Integer> style = stylesheet.get(new Integer(id));
  
  int offset = ( id * ( TRACK_SPACING + TRACK_WIDTH ) );
  int w = width - ( 2 * INITIAL_PADDING ) - offset, h = height - ( 2 * INITIAL_PADDING ) - offset;
  
  // Bound percent between 0 and 100 inclusive.
  if ( percent < 0 ) percent = 0;
  percent %= 101;
  
  // Draw the track (the portion that is not filled in)
  color trackBackgroundColor = ( style == null ) ? 255 : style.get("background-color");
  fill(trackBackgroundColor);
  ellipse(0, 0, w, h);

  // Draw the filled in portion
  color trackForegroundColor = ( style == null ) ? 33 : style.get("foreground-color");
  fill(trackForegroundColor);
  
  // Why -90.0 degrees? Consider a unit circle (thats right y'all high school geometry)
  // where is 90 degrees on a unit circle? Now where do we want to start our polar clock?
  // We want to start at 270 degrees (3PI/2 radians) also known as -90 degrees. No problem.
  // The maximum scale is 360 degrees, so just calculate the % as a ratio of 360 then subtract
  // 90 degrees so we start at -90 for 0% complete and 270 for 100% complete.
  arc(0, 0, w, h, radians( -90.0 ), radians( ( 360 * ( percent / 100.0 ) ) - 90.0 ));
  
  // Draw the cover to make it look flush with background
  fill(backgroundColor);
  ellipse(0, 0, w - TRACK_WIDTH, h - TRACK_WIDTH);

}

HashMap<Integer, HashMap<String, Integer>> parseStylesheet()
{
  
  HashMap<Integer, HashMap<String, Integer>> styles = new HashMap<Integer, HashMap<String, Integer>>();
  
  try
  {
     
     // Open the file for reading.
     InputStream inputStream = (InputStream) new ByteArrayInputStream(loadBytes("Styles.css"));
     InputSource inputSource = new InputSource(new InputStreamReader(inputStream));
     
     // Create the parser instance.
     CSSOMParser parser = new CSSOMParser();
     CSSStyleSheet stylesheet = parser.parseStyleSheet(inputSource, null, null);
     
     // Get the rule list from the parsed css file.
     CSSRuleList ruleList = stylesheet.getCssRules();
     
     for( int i = 0; i < ruleList.getLength(); i++ )
     {
       
       // A note to the creators of CSSOMParser, its called API consistency.
       // Really?!?! .item(int) why not .getItem(int)
       CSSRule rule = ruleList.item(i);
       
       if ( rule instanceof CSSStyleRule )
       {
        
          CSSStyleRule styleRule = (CSSStyleRule)rule;
          String selector = styleRule.getSelectorText();
          CSSStyleDeclaration styleDeclaration = styleRule.getStyle();
         
          if ( selector.indexOf("track") != -1 )
          {
            
              // This is a track[id=""] selector that will be used for color information of the track.
              Integer trackId = new Integer(selector.substring(10, selector.indexOf("\"]")));
              
              HashMap<String, Integer> colors = new HashMap<String, Integer>();
              
              for (int j = 0; j < styleDeclaration.getLength(); j++)
              {
               
                 String property = styleDeclaration.item(j);
                 String value = styleDeclaration.getPropertyCSSValue(property).getCssText();
                 
                 if ( property.indexOf("background-color") != -1 )
                 {
                     colors.put("background-color", parseColorString(value));
                 }
                 else if ( property.indexOf("color") != -1 )
                 {
                     colors.put("foreground-color", parseColorString(value));
                 }
                 
              }
              
              if( colors.size() == 2 ) styles.put(trackId, colors);
              
          }
          else if ( selector.indexOf("body") != -1 )
          {
              // This is a body selector that is used to syle the background color of the whole clock.
              
              String property = styleDeclaration.item(0);
              String value = styleDeclaration.getPropertyCSSValue(property).getCssText();
              
              if ( property.indexOf("background-color") != -1 )
              {
                  backgroundColor = parseColorString(value);
              }
              
          }
         
       }
       
     }
     
  }
  catch( Exception exception )
  {
    System.err.println("Error: " + exception);
  }
  
  return styles;
  
}

color parseColorString(String colorString)
{
 
   if( colorString.indexOf("rgb") == 0 )
   {
       int[] components = new int[3];
       int i = 0;
       for( String component : colorString.substring(4, colorString.length() - 1).split(",") )
         components[i++] = Integer.parseInt(component.trim());
       return color(components[0], components[1], components[2]);
   }
   else return color(0, 0, 0);
  
}
