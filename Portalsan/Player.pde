class Player {
  PVector pos, vel, initialGravity, gravity, jumpAcc, playerAim;
  //gravity on it's own is not enough for *actual* gravity-like behavoir
  //gravitational (and in this case also jumping) acceleration makes "gravity" seem like *actual* gravity with an acceleration
  
  boolean goLeft, goRight, jump = false;

  Player() {
    pos = new PVector(width/2, height*0.05);
    vel = new PVector(5, 5);
    initialGravity = new PVector(0, 0.2);  //to reset gravity, when player is on the ground
    gravity = initialGravity;  // should maybe be tweaked - set these to around gravity=x and gravAcc=2x (that seems to look more realistic)
    jumpAcc = new PVector(0, 0.4);  // and set them between 0.1 and 0.5 (less is too slow, and more is too fast)
    playerAim = new PVector(mouseX, mouseY);
  }


  void render() {
    if ((get(int(pos.x), int((pos.y + 25) + gravity.y)))  == -16777216) {  // "(pos.y + 25) + gravity.y" is (almost) player's pos in the next frame, when falling
      for (int i = 0; get(int(pos.x), int(pos.y + 25)) != -16777216; i++) {
        pos.y += i;
        
        if (get(int(pos.x), int(pos.y)) == -16777216) {
          break;
        }
      }
    }
    
    if (get(int(pos.x), int(pos.y + 25)) == -16777216  &&  jump) {  //if player is on the ground/platform (i.e. not falling)
      //gravity.sub(jumpAcc);
      jumpAcc.mult(-1);
      println("cyka blyat");
    }
    
    if (get(int(pos.x), int(pos.y + 25)) != -16777216) {  //if the color right at the bottom edge of the player is NOT black: add gravity
      gravity.add(jumpAcc);  //for the acceleration-like effect of gravity
      pos.add(gravity);
    }
    else {
      gravity = initialGravity;  //to reset gravity
    }
    
    fill(255);
    ellipse(pos.x, pos.y, 50, 50);  //temporary player model until actual player model is done.
  }


  void movePlayer() {  //checks color of pixel around player, to see if they are not black ("-16777216" = black). If so, allows player to continue movement in desired direction
    if (get(int(pos.x + 25), int(pos.y)) != -16777216  ||  get(int(pos.x - 25), int(pos.y)) != -16777216) {
      pos.x = constrain(pos.x + vel.x * (int(goRight) - int(goLeft)), 25, width  - 25);  // upper-limits of the constraint should be tweaked
    }                                                                                    // after actual player model is implementet

    //if (get(int(pos.x), int(pos.y + 25)) != -16777216  ||  get(int(pos.x), int(pos.y - 25)) != -16777216) {  //
    //  pos.y = constrain(pos.y + vel.x * (int(goDown)  - int(goUp)), 25, height - 25);                        // for going up/down, which the player can't
    //}                                                                                                        //
  }

  boolean playerSetMove(int k, boolean b) {
    switch (k) {              // "
    case + 'A':               // Player can only move sideways and jump (which isn't very usefull most of the time)
      return goLeft = b;      // "
                              // "
    case + 'D':               // "
      return goRight = b;     // "
                              // "
     case + ' ':              // "
      return jump = b;        // "
                              // "
    default:                  // "
      return b;               // "
    }
  }
}
