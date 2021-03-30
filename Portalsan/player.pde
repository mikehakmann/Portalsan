class Player {
  PVector initialGravity = new PVector(0.0, 0.2);  //to reset gravity later on
  PVector maxGravity = new PVector(0.0, 50.0);
  PVector pos, vel, gravity, gravAcc, jumpAcc;
  //gravity on it's own is not enough for *actual* gravity-like behavoir
  //gravitational (and in this case also jumping-) acceleration makes "gravity" seem like *actual* gravity with an acceleration-like effect

  float angle, targetAngle, tpPosX, tpPosY;
  boolean flipPlayer = false;
  boolean goLeft, goRight, jump = false;
  int pixel_LT, pixel_LM, pixel_LB, pixel_RT, pixel_RM, pixel_RB; //for colors of pixels at player's corners and middle-
  int pixelHalfFrame, pixelFullFrame; //-and in the next half and full frame

  Player() {
    pos = new PVector(m.spawnX, m.spawnY);
    vel = new PVector(5, 5);
    gravity = new PVector(0.0, 0.2); //should maybe be tweaked - set these to around gravity=x and gravAcc=2x (that seems to look more realistic)
    gravity.y = initialGravity.y;
    gravAcc = new PVector(0, 0.4);   //and set them between 0.1 and 0.5 (less is too slow, and more is too fast)
    jumpAcc = new PVector(0, -5); //jumping goes upwards, so it's negative in a Processing coord-system
  }

  
  void getPlayerColors() { //all collision is color based - this gets the different colors that player needs for collision (to make if-statements shorter)
    //pixel_LT = get(int(pos.x - 9), int(pos.y - 15)); //"
    //pixel_LM = get(int(pos.x - 9), int(pos.y));      //"
    //pixel_LB = get(int(pos.x - 9), int(pos.y + 15)); //colors of pixel on player's left and right side
    //pixel_RT = get(int(pos.x + 9), int(pos.y - 15)); //"
    //pixel_RM = get(int(pos.x + 9), int(pos.y));      //"
    //pixel_RB = get(int(pos.x + 9), int(pos.y + 15)); //"
    pixel_LT = m.colorAt((pos.x - 9), (pos.y - 15)); //"
    pixel_LM = m.colorAt((pos.x - 9), (pos.y));      //"
    pixel_LB = m.colorAt((pos.x - 9), (pos.y + 15)); //colors of pixel on player's left and right side
    pixel_RT = m.colorAt((pos.x + 9), (pos.y - 15)); //"
    pixel_RM = m.colorAt((pos.x + 9), (pos.y));      //"
    pixel_RB = m.colorAt((pos.x + 9), (pos.y + 15)); //"
    
    //pixelHalfFrame = get(int(pos.x), int(pos.y + 15 + gravity.y/2)); //colors for player in next half frame and next full frame
    //pixelFullFrame = get(int(pos.x), int(pos.y + 15 + gravity.y));   //('+ gravity' is essentially player's pos in the next frame)
    pixelHalfFrame = m.colorAt((pos.x), (pos.y + 15 + gravity.y/2)); //colors for player in next half frame and next full frame
    pixelFullFrame = m.colorAt((pos.x), (pos.y + 15 + gravity.y));   //('+ gravity' is essentially player's pos in the next frame)
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
    
    //circle(pos.x - 9, pos.y - 15, 5); //debug
    //circle(pos.x + 9, pos.y - 15, 5); //debug
    //circle(pos.x - 9, pos.y + 15, 5); //debug
    //circle(pos.x + 9, pos.y + 15, 5); //debug
  }
  

  void verticleMovement() {
    if (m.colorAt(pos.x, pos.y + 15) == m.black && jump || m.colorAt(pos.x, pos.y + 15) == m.yellow  &&  jump) {  //if player is on the ground/platform (i.e. not falling) and jumps:
      gravity.y = jumpAcc.y; //set gravity to jump (i.e. set it to negative)
      pos.add(gravity); //add the gravity
      jump = false; //stop the jumping, so player doesn't fly away
    }//
    else if (m.colorAt(pos.x, pos.y + 15) != m.black && m.colorAt(pos.x, pos.y + 15) != m.yellow) {  //if the color right at the bottom edge of the player is NOT black or yellow: add gravity
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
    
    println("HalfFrame is:          " + pixelHalfFrame);
    println("m.colorAt(blabla) is:  " + m.colorAt((pos.x), (pos.y + 15 + gravity.y/2)));
    println("get(int(), int()) is:  " + get(int(pos.x), int(pos.y + 15 + gravity.y/2)));
    println();
    println("pixel_LB:              " + pixel_LB);
    println("m.colorAt(downMiddle:) " + m.colorAt(pos.x, pos.y + 15));
    println();
    println();
    println();
    
    if (m.colorAt((pos.x), (pos.y + 15 + gravity.y/2)) == m.black   || //checks player's pos in next frame (uses 'gravity/2' in case player is going too fast for just 'gravity'):
        m.colorAt((pos.x), (pos.y + 15 + gravity.y))   == m.black   ||
        m.colorAt((pos.x), (pos.y + 15 + gravity.y/2)) == m.yellow  ||
        m.colorAt((pos.x), (pos.y + 15 + gravity.y))   == m.yellow) {
    //if (pixelHalfFrame == m.black   || //checks player's pos in next frame (uses 'gravity/2' in case player is going too fast for just 'gravity'):
    //    pixelFullFrame == m.black   ||
    //    pixelHalfFrame == m.yellow  ||
    //    pixelFullFrame == m.yellow) {

      for (float i = 0.0; m.colorAt(pos.x, pos.y + 15) != m.black || m.colorAt(pos.x, pos.y + 15) != m.yellow; i += 0.1) { //if next frame has a platform, then start increasing pos a little, until player barely stands on top
        pos.y += i;

        if (m.colorAt(pos.x, pos.y + 15) == m.black || m.colorAt(pos.x, pos.y + 15) == m.yellow) { //break out of loop once player reaches/hits the ground
          break;
        }
      }
      //for (float i = 0.0; pixel_LB != m.black || pixel_RB != m.black || pixel_LB != m.yellow || pixel_RB != m.yellow; i += 0.1) { //if next frame has a platform, then start increasing pos a little, until player barely stands on top
      //  pos.y += i;
      //  println("round: " + i);
        
      //  if (pixel_LB == m.black || pixel_RB == m.black || pixel_LB == m.yellow || pixel_RB == m.yellow) { //break out of loop once player reaches/hits the ground
      //  //if (m.colorAt(pos.x, pos.y + 15) == m.black || m.colorAt(pos.x, pos.y + 15) == m.yellow) {
      //    break;
      //  }
      //}
    }
  }

  boolean playerSetMove(int k, boolean b) {
    switch (k) {            // "
    case + 'A':             // Player can only move sideways
      return goLeft = b;    // therefore only 'A' and 'D' are checked
    
    case + 'D':             // "
      return goRight = b;   // "

    default:                // "
      return b;             // "
    }
  }

  void movePlayer() {  //checks color of pixels around player, to see if they are not black. If so, allows player to move
    if (m.colorAt(pos.x + 15, pos.y) != m.black && m.colorAt(pos.x + 15, pos.y) != m.yellow) {
      pos.x = constrain(pos.x + vel.x * (int(goRight)), 11, width  - 11);
    }

    if (m.colorAt(pos.x - 15, pos.y) != m.black && m.colorAt(pos.x - 15, pos.y) != m.yellow) {
      pos.x = constrain(pos.x + vel.x * (- int(goLeft)), 11, width  - 11);
    }

    if (pos.x > width ||pos.x < 0 || pos.y > height || pos.y < 0) {  //checks if player is outside the screen
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
