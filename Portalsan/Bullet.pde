class Bullet {
  PVector bulletPos, dir, speed; //starting outside the map, so it's not visible
  float angle;

  Bullet() {
    bulletPos = new PVector(100, 100);
    dir = new PVector(0, 0);
    speed = new PVector(7, 7);
  }


  void fire() {
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


  void bulletUpdate() {
    pushMatrix();
    bulletPos.add(dir);  //adds direction (which got a speed added) so bullet moves faster
    circle(bulletPos.x, bulletPos.y, 15);  //placeholder
    popMatrix();
  }
}
