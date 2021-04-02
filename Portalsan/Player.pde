class Player {
  PVector initialGravity = new PVector(0, 0); //to reset velocity later on when player hits the ground
  PVector pos, vel;

  float gravAcc, angle, targetAngle, tpPosX, tpPosY;
  boolean flipPlayer = false;
  boolean goLeft, goRight, jump = false;
  int speed, jumpAcc, terminalVel;
  int pixel_LT, pixel_LM, pixel_LB, pixel_RT, pixel_RM, pixel_RB; //for colors of pixels at player's corners and middle
  int pixels_LS, pixels_RS;                                       //for colors along player's left right side
  int pixelHalfFrame, pixelFullFrame;                             //for color beneath player in the next frame

  Player() {
    pos = new PVector(m.spawnX, m.spawnY); //spawn values are determined the constructor for the Maps class
    vel = new PVector(0, 0);
    gravAcc = 0.4;
    speed = 5;
    jumpAcc = -5; //jumping goes upwards, so it's negative in a Processing coord-system
    terminalVel = 50;
  }


  void getPixelColors() { //all collision is color based - this gets the different colors that player needs for collision (to make if-statements shorter)
    pixel_LT = get(int(pos.x - 9), int(pos.y - 15)); //"
    pixel_LM = get(int(pos.x - 9), int(pos.y));      //"
    pixel_LB = get(int(pos.x - 9), int(pos.y + 15)); //colors of pixel on player's left and right side
    pixel_RT = get(int(pos.x + 9), int(pos.y - 15)); //"
    pixel_RM = get(int(pos.x + 9), int(pos.y));      //"
    pixel_RB = get(int(pos.x + 9), int(pos.y + 15)); //"
    
    //pixels_LS = (pixel_LT + pixel_LM + pixel_LB) / 3; //finds the average value - if all are the same color, these vairables will be too
    //pixels_RS = (pixel_RT + pixel_RM + pixel_RB) / 3; //(used for collision for sideways movement)

    pixelHalfFrame = get(int(pos.x), int(pos.y + 15 + vel.y/2)); //colors for player in next half frame and next full frame (for falling, not sideways movement)
    pixelFullFrame = get(int(pos.x), int(pos.y + 15 + vel.y));   //('+ vel' is essentially player's pos in the next frame when falling)
  }


  void render() {
    pushMatrix();
    translate(pos.x, pos.y); //translates to player's pos, so scaling to flip works as intended
    if (!flipPlayer) { //('flipPlayer' is determined by the portal gun's angle)
      scale(1, 1);
    }//
    else {
      scale(-1, 1);
    }
    image(player, 0, 0);
    popMatrix();
  }


  void verticleMovement() {
    if ((pixel_LB == m.black || pixel_RB == m.black || pixel_LB == m.yellow || pixel_RB == m.yellow) && jump) {  //if player is on the ground/platform (i.e. not falling) and jumps:
      vel.y = jumpAcc; //set vel to jump (i.e. set it to negative) so player goes upwards
      pos.add(vel); //add the velocity (which has become more of an acceleration now) to player
      jump = false; //stop the jumping, so player doesn't fly away
    }//
    else if (pixel_LB != m.black && pixel_RB != m.black && pixel_LB != m.yellow && pixel_RB != m.yellow ) {  //if the color right at the bottom edge of the player is NOT black or yellow: let player fall
      if (vel.y < terminalVel) { //if velocity is below the limit:
        vel.y += gravAcc;  //add the acceleration to gravity to give an acceleration-like effect
      }
      if (vel.y > terminalVel) { //if gravity is above the limit:
        vel.y = terminalVel; //set gravity right *at* the limit
      }
      pos.add(vel); //add gravity to player's position
    }//
    else { //if color *is* black
      vel = initialGravity.copy();  //reset the gravity
    }

    getPixelColors();

    if (pixelHalfFrame == m.black  || pixelFullFrame == m.black  || //checks player's pos in next frame of falling (uses 'gravity/2' in case player is going too fast for just 'gravity'):
        pixelHalfFrame == m.yellow || pixelFullFrame == m.yellow) {

      while (pixel_LB != m.black && pixel_RB != m.black && pixel_LB != m.yellow && pixel_RB != m.yellow) { //while the next frame *isn't* a platform:
        pos.y++; //decend player a little bit down
        getPixelColors();

        if ((pixel_LB == m.black || pixel_RB == m.black || pixel_LB == m.yellow || pixel_RB == m.yellow)) { //break out of loop once player reaches/hits the ground
          //vel = initialGravity.copy();
          break;
        }
      }
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

  void movePlayer() {  //checks color of pixels around player, to see if they are not black. If so, allows player to move in desired direction
    getPixelColors();
    
    if (pixel_RT != m.black && pixel_RM != m.black && pixel_RB != m.black) {
      pos.x = constrain(pos.x + speed * (int(goRight)), 11, width - 11); //if 'd' is pressed, 'goRight' becomes true, meaning: "speed * (int(goRight)) <=> speed * 1"
    }

    if (pixel_LT != m.black && pixel_LM != m.black && pixel_LB != m.black) {
      pos.x = constrain(pos.x + speed * (- int(goLeft)), 11, width - 11); //going right *increases* x-value, but going left *decreases* it - therefore "- int(goLeft)"
    }

    if (pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0) {  //checks if player is outside the screen (map switching happens before player gets all the way out)
      respawnPlayer(); //if so, respawns player
    }
  }


  void respawnPlayer() {
    pos.x = m.spawnX;  // resets players position (looks like player respawns)
    pos.y = m.spawnY;  // "
    vel = initialGravity.copy(); //reset velocity so player doesn't end up inside the ground upon respawn
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
