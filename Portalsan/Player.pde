class Player {
  PVector pos;
  PVector vel;
  PVector gravity;  //gravity on it's own is not enough for *actual* gravity-like behavoir
  PVector gravAcc;  //gravitational acceleration makes "gravity" seem like *actual* gravity with an acceleration
  PVector playerAim;
  boolean isUp, isDown, isLeft, isRight = false;

  Player() {
    pos = new PVector(width/2, height/2);
    vel = new PVector(5, 5);
    gravity = new PVector(0, 0.2);  // should maybe be tweaked - set these to around gravity=x and gravAcc=2x (that seems to look more realistic)
    gravAcc = new PVector(0, 0.4);  // and set them between 0.1 and 0.5 (less is too slow, and more is too fast)
    playerAim = new PVector(mouseX, mouseY);
    
  }
  
  
  void render() {
    gravity.add(gravAcc);  //for the acceleration-like effect of gravity
    pos.add(gravity);
    ellipse(pos.x, pos.y, 50, 50);  //temporary player model until actual player model is done.
  }
  

  void movePlayer() {
    pos.x = constrain(pos.x + vel.x * (int(isRight) - int(isLeft)), 25, width  - 25);  //should be tweaked after actual player model is implementet
    pos.y = constrain(pos.y + vel.x * (int(isDown)  - int(isUp)), 25, height - 25);    //"
  }

  boolean playerSetMove(int k, boolean b) {
    switch (k) {              // "
    case +'A':                // Player can only move sideways and jump (which isn't very usefull most of the time)
    case LEFT:                // "
      return isLeft = b;      // "
                              // "
    case +'D':                // "
    case RIGHT:               // "
      return isRight = b;     // "
                              // "
    default:                  // "
      return b;               // "
    }
  }
}
