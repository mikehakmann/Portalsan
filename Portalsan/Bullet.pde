class Bullet { //<>//
  PVector bulletPos, dir, speed; //starting outside the map, so it's not visible
  float angle, rotation;
  boolean firedBullet = false, firedLeft = false, firedRight = false;
  int north, south, east, west; //for int-colors of each direction around the bullet
  int notNorth, notSouth, notEast, notWest; //for int-colors of all, except 1 specific direction around the bullet

  Bullet() {
    bulletPos = new PVector(100, 100);
    dir = new PVector(0, 0);
    speed = new PVector(7, 7);
  }


  void updateBulletDir() {
    bulletPos.x = p.pos.x;
    bulletPos.y = p.pos.y;

    dir.x = (mouseX-p.pos.x);  //makes the direction of the bullet a vector
    dir.y = (mouseY-p.pos.y);  //between player and the mouse

    dir.normalize();  //normalizes direction since it's just the direction and nothing more (or less)

    angle = dir.heading() - speed.heading();  //finds difference between speed's heading and the direction

    pushMatrix();
    speed.rotate(angle);  //rotates speed so it has same angle as the direction
    dir.add(speed);
    popMatrix();
  }


  void collision() { //both checks for and perfoms collision
    if (get(int(bulletPos.x + dir.x), int(bulletPos.y + dir.y)) == m.black) {  //if bullets pos in next frame is black

      while (get(int(bulletPos.x), int(bulletPos.y)) != m.black) { //if bullet hits a wall next frame:
        bulletPos.x += (dir.x/10);  //adds a little to bulletPos
        bulletPos.y += (dir.y/10);  //so it only barely hits the wall

        if (get(int(bulletPos.x), int(bulletPos.y)) == m.black) {  //when a wall is hit: //<>//
          dir.x = 0;  //makes the direction 0 to stop movement
          dir.y = 0;  //"

          firedBullet = false; //bullet has collided and should therefore stop
          rotation = determineRotation();
          
          //following if-else is for placing the correct portal - determined in mousePressed()
          if (firedLeft) {
            pg.portal1Angle = rotation;
            placePortal(1);
          }//
          else {
            pg.portal2Angle = rotation;
            placePortal(2);
          }

          break; //break out of while-loop since bullet has collided
        }
      }
    }
  }
  
  
  float determineRotation() {
    north = get(int(bulletPos.x), int(bulletPos.y - 5));
    south = get(int(bulletPos.x), int(bulletPos.y + 5));
    east = get(int(bulletPos.x + 5), int(bulletPos.y));
    west = get(int(bulletPos.x - 5), int(bulletPos.y));
    notNorth = (south + east+  west)/3; //they should all be either black, so finding sum and dividing by 3 gives the int for black
    notSouth = (north + east + west)/3;
    notEast = (north + south + west)/3;
    notWest = (north + south + east)/3;
    
    if (north == m.bgColor && notNorth == m.black) {
      return -(PI/2);
    }
    else if (south == m.bgColor && notSouth == m.black) {
      return PI/2;
    }
    else if (east == m.bgColor && notEast == m.black) {
      return PI;
    }
    else if (west == m.bgColor && notWest == m.black) {
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
    circle(bulletPos.x, bulletPos.y, 15);  //placeholder (or not - bullet might stay like this)
  }
}
