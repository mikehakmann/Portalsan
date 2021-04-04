class Player {
  PVector initialGravity = new PVector(0, 0); //to reset velocity later on when player hits the ground
  PVector pos, vel;

  float gravAcc, tpPosX, tpPosY, transferVel;
  float angle, targetAngle, portalGunDir; //these are for rotating the portal gun
  
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
  } //('canGoLeft' and 'canGoRight' are negated since they checks if pixels are colliding, when it's free space we actually want to check for)
  
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
    if ((m.collisionColors.hasValue(pixel_LB) || m.collisionColors.hasValue(pixel_RB)) && jump) { //if player is on the ground/platform (i.e. not falling) and jumps:
      vel.y = jumpAcc; //set vel to jump (i.e. set it to negative) so player goes upwards
      pos.add(vel); //add the velocity after a jump
      jump = false; //stop the jumping, so player doesn't fly away
    }//
    
    else if (!(m.collisionColors.hasValue(pixel_LB) || m.collisionColors.hasValue(pixel_RB))) { //if the color right at the bottom edge of the player is NOT black or yellow: let player fall
      if (vel.y < terminalVel) { //if velocity is below the limit:
        vel.y += gravAcc;  //add the acceleration to gravity to give an acceleration-like effect
      }
      if (vel.y > terminalVel) { //if terminal velocity has been reached or passed:
        vel.y = terminalVel; //set velocity right *at* the limit
      }
      //pos.add(vel); //add the velocity to player's position
    }//
    
    else { //if color *is* black
      vel = initialGravity.copy(); //reset the velocity
    }

    getBottomPixels(); //update the pixels used for verticle movement/collision
    if (m.collisionColors.hasValue(pixelHalfFrame) || m.collisionColors.hasValue(pixelFullFrame)) { //checks player's pos in next frame of falling (uses 'gravity/2' in case player is going too fast for just 'gravity'):
          
      while (!(m.collisionColors.hasValue(pixel_LB) || m.collisionColors.hasValue(pixel_RB))) { //while the next frame *isn't* a platform:
        pos.y++; //decend player a little bit down
        getBottomPixels();
        
        if (pg.checkHitboxes() == 1) { //if player hits portal 1 instead of the ground:
          transferVel = vel.y; //store vel.y (essentially player's gravity) to add it later
          vel = initialGravity.copy(); //to reset vel completely
          
          switch(pg.portal2_Dir) { //check which way the portal being teleported to is facing:
            case 1: //if it's facing north:
              vel.y -= transferVel; //make the velocity point north (vel has essentially been redirected/rotated after this)
              break; //remember to break out of switch-statement
            
            case 2:
              vel.y += transferVel;
              break;
            
            case 3:
              vel.x += transferVel;
              break;
            
            case 4:
              vel.x -= transferVel;
              break;
          }
          
          pg.tpToPortal2_CD = millis(); //"
          pg.tpToPortal1_CD = 0;        //teleport player
          pos.x = pg.tpToPortal2_X;     //(does the same thing as in portalTP1 from PortalGun class)
          pos.y = pg.tpToPortal2_Y;     //"
          
          break; //remember to break out of while-loop too
        }//
        
        else if (pg.checkHitboxes() == 2) { //if player hits portal 2:
          transferVel = vel.y;
          vel = initialGravity.copy();
          
          switch(pg.portal1_Dir) {
            case 1:
              vel.y -= transferVel;
              break;
            
            case 2:
              vel.y += transferVel;
              break;
            
            case 3:
              vel.x += transferVel;
              break;
            
            case 4:
              vel.x -= transferVel;
              break;
          }
          
          pg.tpToPortal1_CD = millis();
          pg.tpToPortal2_CD = 0;
          pos.x = pg.tpToPortal1_X;
          pos.y = pg.tpToPortal1_Y;
          
          break;
        }//
        
        else if (m.collisionColors.hasValue(pixel_LB) || m.collisionColors.hasValue(pixel_RB)) {
          vel = initialGravity.copy(); //player should stop when hitting the ground
          break; //break out of loop once player reaches/hits the ground
        }
      }
    }
    
    pos.add(vel); //and finally, add the velocity to player
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
    }
    
    if (canGoLeft) {
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
    }

    if (pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0) {  //checks if player is outside the screen (map switching happens before player gets all the way out)
      respawnPlayer(); //if so, respawns player
    }
  }
  

  void respawnPlayer() {
    pos.x = m.spawnX;  //resets players position (looks like player respawns)
    pos.y = m.spawnY;  //"
    vel = initialGravity.copy(); //reset velocity so player doesn't end up inside the ground upon respawn
  }


  void rotateGun() {
    angle = atan2(mouseY - pos.y, mouseX - pos.x);  //find angle of mouse pos relative to player's pos

    portalGunDir = (angle - targetAngle) / TWO_PI; //"
    portalGunDir -= round(portalGunDir);           //to find the correct direction to face
    portalGunDir *= TWO_PI;                        //"

    targetAngle += portalGunDir;

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
