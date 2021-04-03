class PortalGun {
  float portal1_X, portal1_Y, portal2_X, portal2_Y; //coods for portals
  float tpToPortal1_X, tpToPortal1_Y, tpToPortal2_X, tpToPortal2_Y; //teleport coords
  float portal1Angle, portal2Angle; //angle each portal is rotated with
  float tempTP_X, tempTP_Y;
  boolean renderPortal1, renderPortal2; //whether a portal should be rendered
  boolean haltTP = false; //holding 'shift' halts teleporting

  int shootPortal_CD, tpToPortal1_CD, tpToPortal2_CD; //cooldowns for shooting portals and teleporting to them
  int bounds = 20; //plus/minus value for portal collision with player
  int portal1_Dir, portal2_Dir; //directions which the portals are facing (north = 1, south = 2, and so on - determined in'setRotation()' from Bullet class)


  int checkHitboxes() { //function to check if player collides with a portal
    if (!haltTP) {
      if (p.pos.x >= portal1_X - bounds  &&  p.pos.x <= portal1_X + bounds) {   //"
        if (p.pos.y >= portal1_Y - bounds  &&  p.pos.y <= portal1_Y + bounds) { //if player collides with portal 1:
          return 1; //return '1' to indicate this
        }
      }
  
      if (p.pos.x >= portal2_X - bounds  &&  p.pos.x <= portal2_X + bounds) {
        if (p.pos.y >= portal2_Y - bounds  &&  p.pos.y <= portal2_Y + bounds) {
          return 2;
        }
      }
    }
    return 0; //return 0, just so function always returns something
  }


  void resetPortals(int portal) { //"removes" portals by placing them outside the player's view
    switch(portal) { //a switch-statement to make things go quicker than an if-statement
      case 0: //resets both portals
        renderPortal1 = false; //to avoid rendering it
        portal1_X = -100; //place portal somewhere outside the display window
        portal1_Y = 0;    //"
        tpToPortal1_X = portal1_X; //reset teleportation coords, for good measure
        tpToPortal1_Y = portal1_Y; //"
  
        renderPortal2 = false;
        portal2_X = -100;
        portal2_Y = 0;
        tpToPortal2_X = portal2_X;
        tpToPortal2_Y = portal2_Y;
        break;
  
      case 1: //resets only portal 1
        renderPortal1 = false;
        portal1_X = -100;
        portal1_Y = 0;
        tpToPortal1_X = portal1_X;
        tpToPortal1_Y = portal1_Y;
        break;
  
      case 2: //resets only portal 2
        renderPortal2 = false;
        portal2_X = -100;
        portal2_Y = 0;
        tpToPortal2_X = portal2_X;
        tpToPortal2_Y = portal2_Y;
        break;
    }
  }

  void firePortal(int portal) {
    b.firedBullet = true; //basically enables collision for the bullet (see void draw())
    b.updateBulletDir(); //updates the direction, the bullet should travel

    if (portal == 1) { //if portal 1 (green) was fired:
      resetPortals(1); //resets portal 1, so it looks like it disappears
    }//
    else { //if not portal 1, then it must be portal 2 (magenta)
      resetPortals(2);
    }
    
    shootPortal_CD = millis(); //to reset/restart cooldown time
  }


  void portalTP1() { //teleports player to portal 1
    if (millis() - tpToPortal1_CD > 500 && renderPortal1) { //if cooldown is over, portal is rendered:
      if (checkHitboxes() == 1) { //if player is within portal 1:
        tpToPortal2_CD = millis(); //reset cooldown for the *OTHER* portal (portal 2), because player will TP to it
        tpToPortal1_CD = 0;        //ends cooldown for this portal
        p.pos.x = tpToPortal2_X;   //make player's position other portal's TP-coords
        p.pos.y = tpToPortal2_Y;   //(i.e. teleport player to correct side of other portal)
      }
    }
  }

  void portalTP2() { //teleports player to portal 2
    if (millis() - tpToPortal2_CD > 500 && renderPortal2) {
      if (checkHitboxes() == 2) {
        tpToPortal1_CD = millis(); //resets cooldown for the *OTHER* portal (portal 1)
        tpToPortal2_CD = 0;
        p.pos.x = tpToPortal1_X;
        p.pos.y = tpToPortal1_Y;
      }
    }
  }


  void renderPortal1(float portalX, float portalY) { //simply renders portal if it should be (i.e. if it has been fired)
    if (renderPortal1 == true) {
      pushMatrix();
      translate(portalX, portalY);
      rotate(portal1Angle);
      image(portal1, 0, 0);
      popMatrix();
    }
  }


  void renderPortal2(float portalX, float portalY) {
    if (renderPortal2 == true) {
      pushMatrix();
      translate(portalX, portalY);
      rotate(portal2Angle);
      image(portal2, 0, 0);
      popMatrix();
    }
  }
}
