int worldWidth = 100;
int worldHeight = 100;

int[][] world = new int[worldWidth][worldHeight];

void setup()
{

 noStroke();
 noFill();

 background(255);

 frameRate(5);

 size(worldWidth * 5, worldHeight * 5);
 
 generateWorld();

}

void generateWorld()
{

 for( int i = 0; i < worldWidth; i++ )
 {

    for( int j = 0; j < worldHeight; j++ )
    {

      world[i][j] = (int)random(0, 2);
    }

 }

}

boolean nodeAliveAtLocation(int i, int j)
{
 if ( i < 0 || i >= worldWidth ) return false;
 if ( j < 0 || j >= worldHeight ) return false;
 return ( world[i][j] == 1 );
}

void simulate()
{
 for( int i = 0; i < worldWidth; i++ )
 {
    for( int j = 0; j < worldHeight; j++ )
    {

      boolean topLeft = nodeAliveAtLocation( i-1, j+1 ),
              topCenter = nodeAliveAtLocation( i, j+1 ),
              topRight = nodeAliveAtLocation( i+1, j+1 ),
              left = nodeAliveAtLocation( i-1, j ),
              right = nodeAliveAtLocation( i+1, j ),
              bottomLeft = nodeAliveAtLocation( i-1, j-1 ),
              bottomCenter = nodeAliveAtLocation( i, j-1 ),
              bottomRight = nodeAliveAtLocation( i+1, j-1 );

       int aliveCount = 0;

       if( topLeft ) aliveCount++;
       if( topCenter ) aliveCount++;
       if( topRight ) aliveCount++;
       if( left ) aliveCount++;
       if( right ) aliveCount++;
       if( bottomLeft ) aliveCount++;
       if( bottomCenter ) aliveCount++;
       if( bottomRight ) aliveCount++;

       if ( world[i][j] == 1 )
         if ( aliveCount < 2 ) world[i][j] = 0;
         else if ( aliveCount >= 2 && aliveCount <= 3 ) world[i][j] = 1;
         else if ( aliveCount > 3 ) world[i][j] = 0;
       else if ( aliveCount == 3 ) world[i][j] = 1;

    }
 }
}

void draw()
{
   simulate();
   for( int i = 0; i < worldWidth; i++ ) {
     for( int j = 0; j < worldHeight; j++ ) {
        noStroke();
        fill( ( world[i][j] == 0 ) ? 0 : 255 );
        rect(5 * i, 5 * j, 5, 5);
      }
   }
}
