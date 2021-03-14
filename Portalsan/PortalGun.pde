class PortalGun {
  float portal1_X, portal1_Y, portal2_X, portal2_Y;
  float portal1Angle, portal2Angle;
  boolean renderPortal1, renderPortal2;
  boolean haltTP = false; //holding 'shift' halts teleporting

  int shootPortal_CD; //a cooldown on shooting portals
  int tpToPortal1_CD; //a cooldown on teleporting *from* portal 1
  int tpToPortal2_CD; //a cooldown on teleporting *from* portal 2
  
  void resetPortals(int portal) { //"removes" portals by placing them outside the player's view
    if (portal == 1) {
      portal1_X = -100;
      portal1_Y = 0;
    }
    if (portal == 2) {
      portal2_X = -100;
      portal2_Y = 0;
    }
  }

  void firePortal(int portal) {
    if (millis() - shootPortal_CD > 2000) { //if the cooldown time for shooting a portal has passed
      b.firedBullet = true; //basically enables collision for the bullet (see void draw())
      b.updateBulletDir(); //updates the direction, the bullet should travel

      if (portal == 1) { //if portal 1 (green) was fired:
        renderPortal1 = true; //to let the portal render later if bullet hits something
        resetPortals(1); //resets portal, so it looks like it disappears
      }//
      else { //if not portal 1, then it must be portal 2 (magenta)
        renderPortal2 = true; //to let portal 2 be rendered if bullet hits something
        resetPortals(2);
      }
      shootPortal_CD = millis(); //to reset/restart cooldown time
    }
  }


  void portalTP1() {
    int n = 35;
    if (millis() - tpToPortal1_CD > 500 && renderPortal1  && !haltTP) { //if cooldown is over, portal is rendered, and TP is *not* halted:
      if (p.pos.x >= portal1_X - n  &&  p.pos.x <= portal1_X + n) {   //if player is within portal 1
        if (p.pos.y >= portal1_Y - n  &&  p.pos.y <= portal1_Y + n) { //"
          tpToPortal2_CD = millis(); //functionally reset cooldown for the *OTHER* portal (portal 2), because player will TP to it
          tpToPortal1_CD = 0; //resets cooldown for this portal
          p.pos.x = portal2_X; //make player's position be the other portal (i.e. Teleport player)
          p.pos.y = portal2_Y; //"
        }
      }
    }
  }

  void portalTP2() {
    int n = 35; //
    if (millis() - tpToPortal2_CD > 499 && renderPortal2 && !haltTP) {
      if (p.pos.x >= portal2_X - n  &&  p.pos.x <= portal2_X + n) {
        if (p.pos.y >= portal2_Y - n  &&  p.pos.y <= portal2_Y + n) {
          tpToPortal1_CD = millis(); //functionally resets cooldown for the *OTHER* portal (portal 1)
          tpToPortal2_CD = 0;
          p.pos.x = portal1_X;
          p.pos.y = portal1_Y;
        }
      }
    }
  }


  void renderPortal1(float portalX, float portalY) { //simply renders portal if it should be (i.e. has been fired)
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
