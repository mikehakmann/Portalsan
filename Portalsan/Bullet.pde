class Bullet {
  PVector bulletPos; //starting outside the map, so it's not visible
  PVector dir;
  float angle;
  float flightTime=50;
  boolean bulletFired = false;

  Bullet() {
    bulletPos = new PVector(100, 100);
    dir = new PVector(0/flightTime, 0/flightTime);
  }


  void fire() {
    if (mousePressed && mouseButton == LEFT && !bulletFired) {
      bulletPos.x = p.pos.x;
      bulletPos.y = p.pos.y;

      dir.x = (mouseX-p.pos.x)/flightTime;
      dir.y = (mouseY-p.pos.y)/flightTime;

      bulletFired = true;
    }
  }


  void bulletUpdate() {
    bulletPos.add(dir);
    circle(bulletPos.x, bulletPos.y, 15);
  }
}
