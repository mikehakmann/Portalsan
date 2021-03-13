class PortalGun {
  float portalX1, portalY1, portalX2, portalY2;
  boolean renderPortal1, renderPortal2;
  boolean haltTP = false; //holding 'shift' halts teleporting

  int shootPortal_CD; //a cooldown on shooting portals
  int tpToPortal1_CD; //a cooldown on teleporting from portal 1
  int tpToPortal2_CD; //a cooldown on teleporting from portal 2


  void firePortal(int portal) {
    if (millis() - shootPortal_CD > 2000) { //if the cooldown time for shooting a portal has passed
      b.firedBullet = true; //basically enables collision for the bullet (see void draw())
      b.updateBulletDir(); //updates the direction, the bullet should travel

      if (portal == 1) { //if portal 1 (green) was fired:
        renderPortal1 = true; //to let the portal render (once bullet hits something)
        portalX1 = -100; //places the portal outside of view, so it looks like it disappears
        portalY1 = 0;    //"
      }
      else { //if not portal 1, then it must be portal 2 (magenta)
        renderPortal2 = true; //to let portal 2 be rendered once bullet collides
        portalX2 = -100; //same as for portal 1
        portalY2 = 0;    //"
      }
      shootPortal_CD = millis();
    }
  }


  void portalTP1() {
    int n = 35;
    if (millis() - tpToPortal1_CD > 500 && renderPortal1  && !haltTP) { //if cooldown is over, portal is rendered, and TP is *not* halted:
      if (p.pos.x >= portalX1 - n  && p.pos.x <= portalX1 + n) {   //if player is within portal 1
        if (p.pos.y >= portalY1 - n  && p.pos.y <= portalY1 + n) { //"
          tpToPortal2_CD = millis(); //functionally reset cooldown for the *OTHER* portal (portal 2), because player will TP to it
          tpToPortal1_CD = 0; //resets cooldown for this portal
          p.pos.x = portalX2; //make player's position be the other portal (i.e. Teleport player)
          p.pos.y = portalY2; //"
        }
      }
      tpToPortal1_CD = millis();
    }
  }

  void portalTP2() {
    int n = 35; //
    if (millis() - tpToPortal2_CD > 499 && renderPortal2 && !haltTP) {
      if (p.pos.x >= portalX2-n  && p.pos.x <= portalX2+n) {
        if (p.pos.y >= portalY2-n  && p.pos.y <= portalY2+n) {
          tpToPortal1_CD = millis(); //functionally resets cooldown for the *OTHER* portal (portal 1)
          tpToPortal2_CD = 0;
          p.pos.x = portalX1;
          p.pos.y = portalY1;
        }
        tpToPortal2_CD = millis();
      }
    }
  }


  void render(float portalX, float portalY) {
    if (renderPortal1 == true) {
      image(portal1, portalX, portalY);
    }
  }


  void render2(float portalX, float portalY) {
    if (renderPortal2 == true) {
      image(portal2, portalX, portalY);
    }
  }
}
