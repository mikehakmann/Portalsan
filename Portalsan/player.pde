class Player {
  PVector initialGravity = new PVector(0, 0); //to reset velocity later on when player hits the ground
  PVector pos, vel;

  float gravAcc, angle, targetAngle, tpPosX, tpPosY;
  boolean flipPlayer = false, jump = false;
  boolean goLeft, goRight, canGoLeft, canGoRight; //only important for sidewaysMovement()
  int speed, jumpAcc, terminalVel;
  int pixel_LT, pixel_LM, pixel_LF, pixel_LB, pixel_RT, pixel_RM, pixel_RF, pixel_RB; //for colors of pixels at player's corners, middle and feet ("LF" and "RF" are the feet)
  int pixelHalfFrame, pixelFullFrame; //for color beneath player in the next frame

  Player() {
    pos = new PVector(m.spawnX, m.spawnY); //spawn values are determined the constructor for the Maps class
    vel = new PVector(0, 0);
    gravAcc = 0.4;
    speed = 5;
    jumpAcc = -5; //jumping goes upwards, so it's negative in a Processing coord-system
    terminalVel = 50; //velocity's upper limit
  }


  void getSidePixels(int frame) { //all collision is color based - this gets the different colors that player needs for collision ("frame = 0" is current frame, "1" is next)
    pixel_LT = get(int(pos.x - (10 + (speed * frame))), int(pos.y - 15)); //('frame' can add speed to the pos to check color for or not, thereby checking either this or the next frame's colors)
    pixel_LM = get(int(pos.x - (10 + (speed * frame))), int(pos.y));      //"
    pixel_LF = get(int(pos.x - (11 + (speed * frame))), int(pos.y + 14)); //colors of pixel on player's left and right side
    canGoLeft = !(m.collisionColors.hasValue(pixel_LT) || m.collisionColors.hasValue(pixel_LM) || m.collisionColors.hasValue(pixel_LF)); //ugly, but works wonders for the look of sidewaysMovement()
    
    pixel_RT = get(int(pos.x + (10 + (speed * frame))), int(pos.y - 15)); //("14" is intentional - "15" is in the ground, and the feet aren't *in* the ground, but *on* it)
    pixel_RM = get(int(pos.x + (10 + (speed * frame))), int(pos.y));      //"
    pixel_RF = get(int(pos.x + (11 + (speed * frame))), int(pos.y + 14)); //"
    canGoRight = !(m.collisionColors.hasValue(pixel_RT) || m.collisionColors.hasValue(pixel_RM) || m.collisionColors.hasValue(pixel_RF));
  }
  
  void getBottomPixels() { //special function for falling-related pixels, so the other colors aren't determined when there's no need
    pixel_LB = get(int(pos.x - (9)), int(pos.y + 15));
    pixel_RB = get(int(pos.x + (9)), int(pos.y + 15));

    pixelHalfFrame = get(int(pos.x), int(pos.y + 15 + vel.y/2)); //colors for player in next half frame and next full frame
    pixelFullFrame = get(int(pos.x), int(pos.y + 15 + vel.y));   //('+ vel' is practially player's pos in the next frame when falling)
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

    getBottomPixels();

    if (pixelHalfFrame == m.black  || pixelFullFrame == m.black  || //checks player's pos in next frame of falling (uses 'gravity/2' in case player is going too fast for just 'gravity'):
        pixelHalfFrame == m.yellow || pixelFullFrame == m.yellow) {

      while (pixel_LB != m.black && pixel_RB != m.black && pixel_LB != m.yellow && pixel_RB != m.yellow) { //while the next frame *isn't* a platform:
        pos.y++; //decend player a little bit down
        getBottomPixels();

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

  void sidewaysMovement() {  //checks color of pixels around player, to see if they are not black. If so, allows player to move in desired direction
    getSidePixels(0); //update pixel colors, so they reflect player's current pos
    
    //if either the top, middle, or foot pixel is a collision color, player *shouldn't move - therefore the "!()" together with the "||" in the following if-statements
    if (canGoRight) {
      pos.x += speed * (int(goRight)); //if 'd' is pressed, 'goRight' becomes true, meaning: "speed * (int(goRight)) <=> speed * 1"
      
      getSidePixels(1);
      if (!canGoRight && goRight) { //if next frame will be inside a wall and player is *still* going right (see also same line for going left):
        getSidePixels(0);
        while (canGoRight) { //if player hasn't reached the wall
          pos.x += 0.1;
          
          getSidePixels(0);
          if (!canGoRight) {
            break; //break out of loop, once player reaches the wall (just like in verticleMovement())
          }
        }
      }
    }//
    else {                                                                        //"
      println("can't go right");                                                  //"
      println("Right Top colliding?    " + m.collisionColors.hasValue(pixel_RT)); //"
      println("Right Middle colliding? " + m.collisionColors.hasValue(pixel_RM)); //"
      println("Right Foot colliding?   " + m.collisionColors.hasValue(pixel_RF)); //"
      println("Right Bottom colliding? " + m.collisionColors.hasValue(pixel_RB)); //debugging
      println();                                                                  //"
      stroke(0, 0, 255);                                                          //"
      point(pos.x+10, pos.y+14);                                                  //"
      stroke(255, 0, 0);                                                          //"
      point(pos.x+9, pos.y+15);                                                   //"
    }                                                                             //"
    
    getSidePixels(0);
    if (canGoLeft) {
      //pos.x = constrain(pos.x + speed * (- int(goLeft)), 11, width - 11); //going right *increases* x-value, but going left *decreases* it - therefore "- int(goLeft)"
      pos.x += speed * (- int(goLeft)); //going right *increases* x-value, but going left *decreases* it - therefore "- int(goLeft)"
      
      getSidePixels(1);
      if (!canGoLeft && goLeft) { //'canGoLeft' is now looking at the next frame, not this one, due to the function call above (yes, it's a little confusing)
      
        getSidePixels(0); //to start checking current frame, instead of the next
        while (canGoLeft) {
          pos.x -= 0.1; //as stated, going left decreases x-value
          
          getSidePixels(0);
          if (!canGoLeft) {
            break;
          }
        }
      }
    }//
    else {                                                                        //"
      println("can't go left");                                                   //"
      println("Left Top colliding?    " + m.collisionColors.hasValue(pixel_LT));  //"
      println("Left Middle colliding? " + m.collisionColors.hasValue(pixel_LM));  //"
      println("Left Foot colliding?   " + m.collisionColors.hasValue(pixel_LF));  //"
      println("Left Bottom colliding? " + m.collisionColors.hasValue(pixel_LB));  //debugging
      println();                                                                  //"
      stroke(0, 0, 255);                                                          //"
      point(pos.x-10, pos.y+14);                                                  //"
      stroke(255, 0, 0);                                                          //"
      point(pos.x-9, pos.y+15);                                                   //"
    }                                                                             //"

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
    angle = atan2(mouseY - pos.y, mouseX - pos.x);  //find angle of mouse pos relative to player's pos

    float dir = (angle - targetAngle) / TWO_PI; //"
    dir -= round(dir);                          //to find the correct direction to face
    dir *= TWO_PI;                              //"

    targetAngle += dir;

    noFill();
    stroke(255);
    pushMatrix();
    translate(pos.x, pos.y);
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
