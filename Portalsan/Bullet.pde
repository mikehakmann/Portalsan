class Bullet { //<>//
  PVector bulletPos, dir, speed; //starting outside the map, so it's not visible
  float angle, rotation;
  boolean firedBullet = false, firedLeft = false;
  int north, south, east, west; //for int-colors of each direction around the bullet
  int notNorth, notSouth, notEast, notWest; //for int-colors of all, except 1 specific direction around the bullet
  int nextFrame, currentFrame;
  color bulletColor;

  Bullet() {
    bulletPos = new PVector(100, 100);
    dir = new PVector(0, 0);
    speed = new PVector(7, 7);
  }


  void updateBulletDir() {
    bulletPos.x = p.pos.x;
    bulletPos.y = p.pos.y;

    dir.x = (mouseX-p.pos.x); //makes the direction of the bullet a vector
    dir.y = (mouseY-p.pos.y); //between player and the mouse

    dir.normalize(); //normalizes direction since it's just the direction and nothing more (or less)

    angle = dir.heading() - speed.heading(); //finds difference between speed's heading and the direction

    pushMatrix();
    speed.rotate(angle); //rotates speed so it has same angle as the direction
    dir.add(speed);
    popMatrix();
  }


  void collision() { //both checks for and perfoms collision - also only after detecting collision, that portals are actually rendered
    nextFrame = m.colorAt(bulletPos.x + dir.x, bulletPos.y+ dir.y);
    currentFrame = m.colorAt(bulletPos.x, bulletPos.y);
    
    if (nextFrame == m.black || nextFrame == m.yellow || nextFrame == -16185079) { //if bullets pos in next frame is black or yellow ("-16185079" is almost black)
      while (currentFrame != m.black || currentFrame != m.yellow || currentFrame != -16185079){ //if bullet hits a wall next frame:
        currentFrame = m.colorAt(bulletPos.x, bulletPos.y);
        bulletPos.x += (dir.x/10); //adds a little to bulletPos
        bulletPos.y += (dir.y/10); //so it only barely hits the wall

        if (currentFrame == m.black || currentFrame == -16185079) { //when a *black* wall is hit: //<>//
          dir.x = 0; //makes the direction 0 to stop movement
          dir.y = 0; //"

          firedBullet = false; //bullet has collided and should therefore stop
          findBulletColors(); //called from here, so it's only being run while bullet flies
          
          //following if-else is for placing the correct portal - determined in mousePressed()
          if (firedLeft) {
            pg.renderPortal1 = true; //to let the portal render later if bullet hits something
            placePortal(1);
            pg.portal1Angle = setRotation(1);
          }//
          else {
            pg.renderPortal2 = true; //to let portal 2 be rendered if bullet hits something
            placePortal(2);
            pg.portal2Angle = setRotation(2);
          }
          
          break; //break out of while-loop since bullet has collided
        }//
        
        else if (currentFrame == m.yellow) { //if bullet instead hits a *yellow* wall
          firedBullet = false;
          bulletPos.x = -100;
          bulletPos.y = 0;
          
          break;
        }
      }
    }
  }
  
  
  void findBulletColors() { //determines the colors around the bullet
    north = m.colorAt(bulletPos.x, bulletPos.y - 5);
    south = m.colorAt(bulletPos.x, bulletPos.y + 5);
    east = m.colorAt(bulletPos.x + 5, bulletPos.y);
    west = m.colorAt(bulletPos.x - 5, bulletPos.y);
    notNorth = (south + east + west)/3; //they should all be either black,
    notSouth = (north + east + west)/3; //so finding sum and dividing by 3 gives the int for black
    notEast = (north + south + west)/3;
    notWest = (north + south + east)/3;
  }
  
  float setRotation(int portal) { //sets the rotation (and TP-coords, since these depend on rotation) of the portals
    if (north == m.bgColor && notNorth == m.black) { //only check for black because portals can't be placed on yellow walls
      if (portal == 1) {
        pg.portal1_Dir = 1; //save the direction that portal 1 is facing for later
        pg.tpToPortal1_X = pg.portal1_X;      //coords that player appears at are also set since rotation is being checked anyway
        pg.tpToPortal1_Y = pg.portal1_Y - 15; //"
      }//
      else {
        pg.portal2_Dir = 1; //save the direction that portal2 is facing for later
        pg.tpToPortal2_X = pg.portal2_X;
        pg.tpToPortal2_Y = pg.portal2_Y - 15;
      }
      return -(PI/2);
    }
    else if (south == m.bgColor && notSouth == m.black) {
      if (portal == 1) {
        pg.portal1_Dir = 2;
        pg.tpToPortal1_X = pg.portal1_X;
        pg.tpToPortal1_Y = pg.portal1_Y + 15;
      }//
      else {
        pg.portal2_Dir = 2;
        pg.tpToPortal2_X = pg.portal2_X;
        pg.tpToPortal2_Y = pg.portal2_Y + 15;
      }
      return PI/2;
    }
    else if (east == m.bgColor && (notEast == m.black || notEast == -16185079)) { //checking for -16185079 too, so bullet can hit stage 2's barrier as well
      if (portal == 1) {
        pg.portal1_Dir = 3;
        pg.tpToPortal1_X = pg.portal1_X + 15;
        pg.tpToPortal1_Y = pg.portal1_Y;
      }//
      else {
        pg.portal2_Dir = 3;
        pg.tpToPortal2_X = pg.portal2_X + 15;
        pg.tpToPortal2_Y = pg.portal2_Y;
      }
      return PI;
    }
    else if (west == m.bgColor && (notWest == m.black || notWest == -16185079)) { //portal can only be on left or right side of this barrier,
      if (portal == 1) {                                                          //so no need to check north or south
        pg.portal1_Dir = 4;
        pg.tpToPortal1_X = pg.portal1_X - 15;
        pg.tpToPortal1_Y = pg.portal1_Y;
      }//
      else {
        pg.portal2_Dir = 4;
        pg.tpToPortal2_X = pg.portal2_X - 15;
        pg.tpToPortal2_Y = pg.portal2_Y;
      }
      return 0.0;
    }
    return 0.0;
  }


  void placePortal(int portal) { //when a portal should be placed:
    if (portal == 1) { //checks if the left (green) portal should be placed - based on the input
      pg.portal1_X = bulletPos.x; //if so, sets the left (green) portals coords to be the bullet's
      pg.portal1_Y = bulletPos.y; //"
    }//
    else {
      pg.portal2_X = bulletPos.x; //if not, then it must be the right (magenta) portal, 
      pg.portal2_Y = bulletPos.y; //that should be placed at the bullet's coords
    }
  }


  void bulletUpdate() {
    bulletPos.add(dir);  //adds direction (which got a speed added) so bullet moves in desired direction
    pushMatrix();
    fill(bulletColor);
    circle(bulletPos.x, bulletPos.y, 10);  //placeholder (or not - bullet might stay like this)
    popMatrix();
  }
}
