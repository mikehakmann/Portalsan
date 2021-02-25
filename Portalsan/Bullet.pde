class Bullet {
  PVector bulletPos, dir, speed; //starting outside the map, so it's not visible
  float angle;
  float flightTime = 50;
  //boolean bulletFired = false;

  Bullet() {
    bulletPos = new PVector(100, 100);
    dir = new PVector(0/flightTime, 0/flightTime);
    speed = new PVector(1, 1);
  }


  void fire() {
    //if (mousePressed && mouseButton == LEFT && !bulletFired) {
      bulletPos.x = p.pos.x;
      bulletPos.y = p.pos.y;

      //dir.x = (mouseX-p.pos.x)/flightTime;  //advances direction of bullet
      //dir.y = (mouseY-p.pos.y)/flightTime;  //"
      
      dir.x = (mouseX-p.pos.x);  //advances direction of bullet
      dir.y = (mouseY-p.pos.y);  //"
      
      dir.normalize();
      
      //dir.mag();
      
      //bulletFired = true;
    //}
  }


  void bulletUpdate() {
    bulletPos.add(dir);
    circle(bulletPos.x, bulletPos.y, 15);
  }
}
