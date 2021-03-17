class PortalGun {
  float portal1_X, portal1_Y, portal2_X, portal2_Y; //coods for portals
  float tpToPortal1_X, tpToPortal1_Y, tpToPortal2_X, tpToPortal2_Y; //teleport coords
  float portal1Angle, portal2Angle; //angle each portal is rotated with
  boolean renderPortal1, renderPortal2; //whether a portal should be rendered
  boolean haltTP = false; //holding 'shift' halts teleporting

  int shootPortal_CD; //a cooldown on shooting portals
  int tpToPortal1_CD; //a cooldown on teleporting *from* portal 1
  int tpToPortal2_CD; //a cooldown on teleporting *from* portal 2
  
  void resetPortals(int portal) { //"removes" portals by placing them outside the player's view
    switch(portal) { //a switch-statement to make things go quicker than an if-statement
      case 0:
        renderPortal1 = false;
        portal1_X = -100;
        portal1_Y = 0;
        
        renderPortal2 = false;
        portal2_X = -100;
        portal2_Y = 0;
        break;
        
      case 1:
        renderPortal1 = false;
        portal1_X = -100;
        portal1_Y = 0;
        break;
        
      case 2:
        renderPortal2 = false;
        portal2_X = -100;
        portal2_Y = 0;
        break;
    }
  }

  void firePortal(int portal) {
    if (millis() - shootPortal_CD > 1500) { //if the cooldown time for shooting a portal has passed
      b.firedBullet = true; //basically enables collision for the bullet (see void draw())
      b.updateBulletDir(); //updates the direction, the bullet should travel

      if (portal == 1) { //if portal 1 (green) was fired:
        resetPortals(1); //resets portal, so it looks like it disappears
        renderPortal1 = true; //to let the portal render later if bullet hits something
      }//
      else { //if not portal 1, then it must be portal 2 (magenta)
        resetPortals(2);
        renderPortal2 = true; //to let portal 2 be rendered if bullet hits something
      }
      shootPortal_CD = millis(); //to reset/restart cooldown time
    }
  }


  void portalTP1() { //teleports player *TO* portal 1
    int n = 20; //plus/minus value for portal collision with player
    if (millis() - tpToPortal1_CD > 500 && renderPortal1  && !haltTP) { //if cooldown is over, portal is rendered, and TP is *not* halted:
      if (p.pos.x >= portal1_X - n  &&  p.pos.x <= portal1_X + n) {   //if player is within portal 1
        if (p.pos.y >= portal1_Y - n  &&  p.pos.y <= portal1_Y + n) { //"
          tpToPortal2_CD = millis(); //functionally reset cooldown for the *OTHER* portal (portal 2), because player will TP to it
          tpToPortal1_CD = 0; //resets cooldown for this portal
          //p.pos.x = portal2_X; //make player's position other portal's TP-coords (i.e. Teleport player)   //original code
          //p.pos.y = portal2_Y; //"                                                                        //original code
          p.pos.x = tpToPortal2_X;
          p.pos.y = tpToPortal2_Y;
          println("teleported to portal 1");
          println("tpToPortal1_X: " + tpToPortal1_X);
          println("tpToPortal1_Y: " + tpToPortal1_Y);
          println();
          println("tpToPortal2_X: " + tpToPortal2_X);
          println("tpToPortal2_Y: " + tpToPortal2_Y);
          println();
        }
      }
    }
  }

  void portalTP2() { //teleports player *TO* portal 2
    int n = 20;
    if (millis() - tpToPortal2_CD > 499 && renderPortal2 && !haltTP) {
      if (p.pos.x >= portal2_X - n  &&  p.pos.x <= portal2_X + n) {
        if (p.pos.y >= portal2_Y - n  &&  p.pos.y <= portal2_Y + n) {
          tpToPortal1_CD = millis(); //functionally resets cooldown for the *OTHER* portal (portal 1)
          tpToPortal2_CD = 0;
          //p.pos.x = portal1_X;  //original code
          //p.pos.y = portal1_Y;  //original code
          p.pos.x = tpToPortal1_X;
          p.pos.y = tpToPortal1_Y;
          println("teleported to portal 2");
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
      
      //println("portal 1 X: " + tpToPortal1_X);
      //println("portal 1 Y: " + tpToPortal1_Y);
    }
  }


  void renderPortal2(float portalX, float portalY) {
    if (renderPortal2 == true) {
      pushMatrix();
      translate(portalX, portalY);
      rotate(portal2Angle);
      image(portal2, 0, 0);
      popMatrix();
      
      //println("portal 2 X: " + tpToPortal2_X);
      //println("portal 2 Y: " + tpToPortal2_Y);
    }
  }
}
