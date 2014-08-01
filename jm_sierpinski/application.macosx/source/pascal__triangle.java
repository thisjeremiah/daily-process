import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class pascal__triangle extends PApplet {

float x1, y1, x2, y2, x3, y3;

public void setup() {
  size(500, 500, P2D);
  x1 = 0;
  y1 = height;
  x2 = width / 2;
  y2 = height - 433.013f;
  x3 = width;
  y3 = height;
  frameRate(15);
  noStroke();
}

public void draw()
{
   background(0);
   fill(255);
   rect(0, 0, width, height);
   drawTriangle(x1, y1, x2, y2, x3, y3, 0);
}

public void drawTriangle(float x1, float y1, float x2, float y2, float x3, float y3, int count) {
  if (count < 7){
    fill(random(0, 255));
    triangle(x1, y1, x2, y2, x3, y3);
    float mid1x2 = (x1 + x2) / 2;
    float mid1y2 = (y1 + y2) / 2;
    float mid2x3 = (x2 + x3) / 2;
    float mid2y3 = (y2 + y3) / 2;
    float mid1x3 = (x1 + x3) / 2;
    float mid1y3 = (y1 + y3) / 2;
    drawTriangle(x1, y1, mid1x2, mid1y2, mid1x3, mid1y3, count + 1);
    drawTriangle(mid1x2, mid1y2, x2, y2, mid2x3, mid2y3, count + 1);
    drawTriangle(mid1x3, mid1y3, mid2x3, mid2y3, x3, y3, count + 1);
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#EA0909", "pascal__triangle" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
