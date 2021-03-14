class Bullet { //<>//
  PVector bulletPos, dir, speed; //starting outside the map, so it's not visible
  float angle;
  boolean firedBullet = false, firedLeft = false, firedRight = false;
  int north, south, east, west;
  int notNorth, notSout, notEast, notWest;

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
    if (get(int(bulletPos.x + dir.x), int(bulletPos.y + dir.y)) == -16777216) {  //if bullets pos in next frame is black

      while (get(int(bulletPos.x), int(bulletPos.y)) != -16777216) { //if bullet hits a wall next frame:
        bulletPos.x += (dir.x/10);  //adds a little to bulletPos
        bulletPos.y += (dir.y/10);  //so it only barely hits the wall

        if (get(int(bulletPos.x), int(bulletPos.y)) == -16777216) {  //when a wall is hit: //<>//
          dir.x = 0;  //makes the direction 0 to stop movement
          dir.y = 0;  //"

          firedBullet = false; //bullet has collided and should therefore stop
          determineRotation();
          
          //following if-else is for placing the correct portal - determined in mousePressed()
          if (b.firedLeft) {
            b.placePortal(1);
          }//
          else {
            b.placePortal(2);
          }

          break; //break out of while-loop since bullet has collided
        }
      }
    }
  }
  
  
  void determineRotation() {
    north = get(int(bulletPos.x), int(bulletPos.y - 5));
    south = get(int(bulletPos.x), int(bulletPos.y + 5));
    east = get(int(bulletPos.x + 5), int(bulletPos.y));
    west = get(int(bulletPos.x - 5), int(bulletPos.y));
    notWest = (north + south + east)/3;
    
    if (west == -6574665 && notWest == -16777216) {
      println("west is clear, but others are blocked");
    }
    else {
      println("west is NOT clear");
    }
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
