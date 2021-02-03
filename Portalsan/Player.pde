class Player {
  final PVector initialGravity = new PVector(0.0, 0.2);  //to reset gravity later on
  PVector pos, vel, gravity, gravAcc, jumpAcc, playerAim;
  //gravity on it's own is not enough for *actual* gravity-like behavoir
  //gravitational (and in this case also jumping) acceleration makes "gravity" seem like *actual* gravity with an acceleration

  boolean checkLeft, checkRight = true;
  boolean goLeft, goRight, jump = false;

  Player() {
    pos = new PVector(width*0.1, height*0.89);
    vel = new PVector(5, 5);
    gravity = new PVector(0.0, 0.2);
    gravity.y = initialGravity.y;  // should maybe be tweaked - set these to around gravity=x and gravAcc=2x (that seems to look more realistic)
    gravAcc = new PVector(0, 0.4);  // and set them between 0.1 and 0.5 (less is too slow, and more is too fast)
    jumpAcc = new PVector(0, -5);
    playerAim = new PVector(mouseX, mouseY);
  }


  void render() {
    
    if (!flipPlayer) {
      pushMatrix();
      //scale(-1, 1);
      image(player, pos.x, pos.y);
      popMatrix();
    }//
    else {
      pushMatrix();
      //scale(-1, -1);
      image(player, pos.x, pos.y);
      popMatrix();
    }
  }

  void verticleMovement() {

    if (get(int(pos.x), int(pos.y + 15)) == -16777216  &&  jump) {  //if player is on the ground/platform (i.e. not falling)
      gravity.y = jumpAcc.y;
      pos.add(gravity);
      jump = false;
    }//
    else if (get(int(pos.x), int(pos.y + 15)) != -16777216) {  //if the color right at the bottom edge of the player is NOT black: add gravity
      gravity.add(gravAcc);  //for the acceleration-like effect of gravity
      pos.add(gravity);
    }//
    else {
      gravity.y = initialGravity.y;  //to reset gravity
    }

    if ((get(int(pos.x), int((pos.y + 15) + gravity.y)))  == -16777216) {  // "(pos.y + 25) + gravity.y" is (almost) player's pos in the next frame, when falling
      for (float i = 0.0f; get(int(pos.x), int(pos.y + 15)) != -16777216; i += 0.1f) {
        pos.y += i;

        if (get(int(pos.x), int(pos.y + 15)) == -16777216) {
          break;
        }
      }
    }
  }


  void movePlayer() {  //checks color of pixel around player, to see if they are not black ("-16777216" = black). If so, allows player to continue movement in desired direction
    //if (get(int(pos.x + 15), int(pos.y)) != -16777216  ||  get(int(pos.x - 15), int(pos.y)) != -16777216) {
    //  pos.x = constrain(pos.x + vel.x * (int(goRight) - int(goLeft)), 11, width  - 11);
    //}
    if (get(int(pos.x + 15), int(pos.y - 15)) != -16777216 ||
      get(int(pos.x + 15), int(pos.y + 15)) != -16777216) {
      if (get(int(pos.x + 15), int(pos.y)) != -16777216) {
        pos.x = constrain(pos.x + vel.x * (int(goRight)), 11, width  - 11);
      }

      if (get(int(pos.x - 14), int(pos.y)) != -16777216) {
        pos.x = constrain(pos.x + vel.x * (- int(goLeft)), 11, width  - 11);
      }
    }

    //====== Vlad's kode
    //float temp=13;
    //for (int i = -15; i<15; i++) {
    //  if (get(int(pos.x + temp), int(pos.y + i)) == -16777216) {
    //    checkRight=false;
    //  }
    //  if (get(int(pos.x - temp), int(pos.y + i)) == -16777216) {
    //    checkLeft=false;
    //  }
    //}

    //if (get(int(pos.x + temp), int(pos.y)) != -16777216 && checkRight) {
    //  pos.x = constrain(pos.x + vel.x * (int(goRight)), 11, width  - 11);
    //}


    //if (get(int(pos.x - temp), int(pos.y)) != -16777216 && checkLeft) {
    //  pos.x = constrain(pos.x + vel.x * (- int(goLeft)), 11, width  - 11);
    //}
    //checkRight=true;
    //checkLeft=true;
    //======



    if (pos.y >= height) {  //checks if player is outside the screen
      pos.x = spawnX;  // resets players position - basically respawns player
      pos.y = spawnY;  // "
      gravity.y = initialGravity.y;  //reset gravity so player doesn't end up in the ground upon respawn
    }
  }

  boolean playerSetMove(int k, boolean b) {
    switch (k) {              // "
    case + 'A':               // Player can only move sideways
      return goLeft = b;      // "

    case + 'D':               // "
      return goRight = b;     // "

    default:                  // "
      return b;               // "
    }
  }
}
