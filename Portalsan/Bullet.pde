class Bullet { //<>// //<>//
  PVector bulletPos, dir, speed; //starting outside the map, so it's not visible
  float angle;
  boolean firedBullet = false, firedLeft = false, firedRight = false;

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

      while (get(int(bulletPos.x), int(bulletPos.y)) != -16777216) {
        bulletPos.x += (dir.x/10);  //tilføjer en smule til bulletPos
        bulletPos.y += (dir.y/10);  //så at vi kun lige præcis vil ramme en væg

        if (get(int(bulletPos.x), int(bulletPos.y)) == -16777216) {  //når vi rammer en væg: //<>//
          dir.x = 0;  //
          dir.y = 0;  //

          firedBullet = false;

          //following if-else is for placing the right portal
          if (b.firedLeft) {
            b.placePortal(1);
          }//
          else if (b.firedRight) {
            b.placePortal(2);
          }

          break;
        }
      }
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
    bulletPos.add(dir);  //adds direction (which got a speed added) so bullet moves faster
    circle(bulletPos.x, bulletPos.y, 15);  //placeholder
  }
}
