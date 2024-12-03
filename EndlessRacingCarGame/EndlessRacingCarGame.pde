PImage player, road;
int posPlayerX,posPlayerY,posRoadY;

void setup() {
  size(600, 450);
  player = loadImage("Car.png");
  road = loadImage("road.png");
  posPlayerX = height/2;
  posPlayerY = 350;
  posRoadY=-450;

  //noLoop();
}

void draw() {
  background(255);

  println("x: " + posPlayerX +" y: " + posPlayerY);

  image(road, 0, posRoadY);
  image(player, posPlayerX, posPlayerY);
  if (posRoadY<0)
       posRoadY+=3;
  else
       posRoadY=-450; 

}

void keyPressed()
{
    switch(keyCode)
    {
      case RIGHT:
           posPlayerX+=5; 
           break;

      case LEFT:
           posPlayerX-=5;
           break;

      case UP:
           posPlayerY-=5;
           break;

      case DOWN:
           posPlayerY+=5;
           break;
    }

}
