class Player {
  final PVector initialGravity = new PVector(0.0, 0.2);  //to reset gravity later on
  final PVector maxGravity = new PVector(0.0, 50.0);
  PVector pos, vel, gravity, gravAcc, jumpAcc;
  //gravity on it's own is not enough for *actual* gravity-like behavoir
  //gravitational (and in this case also jumping-) acceleration makes "gravity" seem like *actual* gravity with an acceleration-like effect

  float angle, targetAngle, tpPosX, tpPosY;
  boolean flipPlayer = false;
  boolean goLeft, goRight, jump = false;
  //boolean portalUp, portalDown = false;

  Player() {
    pos = new PVector(m.spawnX, m.spawnY);
    vel = new PVector(5, 5);
    gravity = new PVector(0.0, 0.2); //should maybe be tweaked - set these to around gravity=x and gravAcc=2x (that seems to look more realistic)
    gravity.y = initialGravity.y;
    gravAcc = new PVector(0, 0.4);   //and set them between 0.1 and 0.5 (less is too slow, and more is too fast)
    jumpAcc = new PVector(0, -5); //jumping goes upwards, so it's negative in a Processing coord-system
  }


  void render() {
    pushMatrix();
    translate(pos.x, pos.y); //translates to player's pos, so scaling to flip works better
    if (!flipPlayer) {
      scale(1, 1);
    }//
    else {
      scale(-1, 1);
    }
    image(player, 0, 0);
    popMatrix();
  }


  void verticleMovement() {
    if (get(int(pos.x), int(pos.y + 15)) == m.black  &&  jump) {  //if player is on the ground/platform (i.e. not falling) and jumps:
      gravity.y = jumpAcc.y;
      pos.add(gravity);
      jump = false;
    }//
    else if (get(int(pos.x), int(pos.y + 15)) != m.black) {  //if the color right at the bottom edge of the player is NOT black: add gravity
      if (gravity.y < maxGravity.y) { //if gravity is below the limit:
        gravity.add(gravAcc);  //add the acceleration to gravity to give an acceleration-like effect
      }
      if (gravity.y > maxGravity.y) { //if gravity is aboce the limit:
        gravity.y = maxGravity.y; //set gravity right *at* the limit
      }
      pos.add(gravity); //add gravity to player's position
    }//
    else { //if it *is* black
      gravity.y = initialGravity.y;  //reset the gravity
    }

    if ((get(int(pos.x), int((pos.y + 15) + gravity.y)))  == m.black) {  // "(pos.y + 25) + gravity.y" is (almost) player's pos in the next frame, when falling
      for (float i = 0.0f; get(int(pos.x), int(pos.y + 15)) != m.black; i += 0.1f) {
        pos.y += i;

        if (get(int(pos.x), int(pos.y + 15)) == m.black) {
          break;
        }
      }
    }
  }

  boolean playerSetMove(int k, boolean b) {
    switch (k) {              // "
    case + 'A':               // Player can only move sideways
      return goLeft = b;      // therefore only 'A' and 'D' are checked

    case + 'D':               // "
      return goRight = b;     // "

    default:                  // "
      return b;               // "
    }
  }

  void movePlayer() {  //checks color of pixel around player, to see if they are not black. If so, allows player to continue movement in desired direction
    //if (get(int(pos.x + 15), int(pos.y)) != m.black  ||  get(int(pos.x - 15), int(pos.y)) != m.black) {
    //  pos.x = constrain(pos.x + vel.x * (int(goRight) - int(goLeft)), 11, width  - 11);
    //}
    if (get(int(pos.x - 15), int(pos.y)) != m.black || get(int(pos.x + 15), int(pos.y)) != m.black) {
      if (get(int(pos.x + 15), int(pos.y)) != m.black) {
        pos.x = constrain(pos.x + vel.x * (int(goRight)), 11, width  - 11);
      }

      if (get(int(pos.x - 15), int(pos.y)) != m.black) {
        pos.x = constrain(pos.x + vel.x * (- int(goLeft)), 11, width  - 11);
      }
    }

    if (pos.x >= width ||pos.x <= 0 || pos.y >= height || pos.y <= 0) {  //checks if player is outside the screen
      respawnPlayer();
    }
  }

  void respawnPlayer() {
    pos.x = m.spawnX;  // resets players position - basically respawns player
    pos.y = m.spawnY;  // "
    gravity.y = initialGravity.y;  //reset gravity so player doesn't end up in the ground upon respawn
  }


  void rotateGun() {
    angle = atan2(mouseY - p.pos.y, mouseX - p.pos.x);  //find angle of mouse pos relative to player's pos

    float dir = (angle - targetAngle) / TWO_PI; //"
    dir -= round(dir);                          //to find the correct direction to face
    dir *= TWO_PI;                              //"

    targetAngle += dir;

    noFill();
    stroke(255);
    pushMatrix();
    translate(p.pos.x, p.pos.y);
    rotate(targetAngle); 

    if (angle>=-PI/2 && angle <= PI/2) {  //if-else statement for flipping Portal Gun if mouse is above/below player
      scale(-1, 1);
      flipPlayer = true;
    }//
    else {
      scale(-1, -1);
      flipPlayer = false;
    }

    image(portalGun, 0, 0);
    popMatrix();
  }
}
