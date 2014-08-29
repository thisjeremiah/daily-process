static final int WIDTH = 0;
static final int HEIGHT = 1;

static final int[] SIZE = {480, 480};
static final float _RADIUS = 25.0/100.0;

float percent = 0.0;

color blueColor = color(33,154,204);
color redColor = color(211,47,13);
color greenColor = color(142,195,0);
color yellowColor = color(246,164,0);

color trackColor = color(0);

void setup()
{
  size(SIZE[WIDTH], SIZE[HEIGHT], P3D);
  background(trackColor);
  noLoop();
}

color getGuageColor(float percentage)
{
  if( percentage <= 20.0 ) return blueColor;
  else if( percentage <= 50.0 ) return greenColor;
  else if( percentage <= 80.0 ) return yellowColor;
  else return redColor;
}

void keyPressed()
{
  if( keyCode == UP )
  {
    if( percent < 100.0 ) percent += 1.0;
    else percent = 0.0;
  }
  else if( keyCode == DOWN )
  {
    if( percent > 0.0 ) percent -= 1.0;
    else percent = 100.0;
  }
  else if( keyCode == LEFT )
  {
    modeClockwise = false;
  }
  else if( keyCode == RIGHT )
  {
    modeClockwise = true;
  }
  redraw();
}

boolean modeClockwise = true;

void draw()
{
  /*
  if( percent > 100.0 ) {
    percent = 0.0;
    modeClockwise = !modeClockwise;
    try {
      Thread.sleep(500);
    } catch(Exception e)
    {
    }
  }*/
  fill(trackColor);
    noStroke();
    rect(0, 0, SIZE[WIDTH], SIZE[HEIGHT]);
    float[][] size = generateCircleCordinatesWithRadiusPercentage();
  if(modeClockwise) drawCircleClockwise(size, percent);
  else drawCircleCounterclockwise(size, percent);
  rectMode(CENTER);
  textAlign(CENTER);
  textSize(80);
  fill(getGuageColor(percent));
  text(((int)percent), size[1][0], size[1][1]);
  fill(255);
  textSize(18);
  text("Test Guage", size[1][0], size[1][1]+35.0);
  textSize(13);
  fill(255);
  text("%", size[1][0]-30.0, size[1][1]+80.0);
  fill(100);
  text("x100", size[1][0]+30.0, size[1][1]+80.0);
  noFill();
  stroke(255);
  rectMode(CORNER);
  rect(size[1][0]-40.0, size[1][1]+65.0, 20, 20, 7);
  //percent = percent+1.0;
}

float[][] generateCircleCordinatesWithRadiusPercentage()
{
  float[] size = {SIZE[WIDTH]*_RADIUS, SIZE[HEIGHT]*_RADIUS};
  float[] cords = { (SIZE[WIDTH])/2.0, (SIZE[HEIGHT])/2.0 };
  float[] smaller = {size[WIDTH]-20.0, size[HEIGHT]-20.0};
  return new float[][] {size, cords, smaller};
}

void drawCircleCounterclockwise(float[][] size, float percentage)
{
  fill(getGuageColor(percentage)); // 100
  noStroke();
  ellipseMode(RADIUS);
  ellipse(size[1][0], size[1][1], size[0][0], size[0][1]);
  fill(trackColor);
  arc(size[1][0], size[1][1], size[0][0], size[0][1], radians(-90), radians(-90+(360-(360*(percentage/100.0)))), PIE);
  fill(g.backgroundColor);
  ellipse(size[1][0], size[1][1], size[2][0], size[2][1]);
}

void drawCircleClockwise(float[][] size, float percentage)
{
  fill(trackColor); // 100
  noStroke();
  ellipseMode(RADIUS);
  smooth(4);
  ellipse(size[1][0], size[1][1], size[0][0], size[0][1]);
  fill(getGuageColor(percentage));
  arc(size[1][0], size[1][1], size[0][0], size[0][1], radians(-90), radians(-90+(360*(percentage/100.0))), PIE);
  fill(trackColor);
  smooth(8);
  ellipse(size[1][0], size[1][1], size[2][0], size[2][1]);
}
