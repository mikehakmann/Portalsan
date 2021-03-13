


class PortalGun {
  float portalX1, portalY1, portalX2, portalY2;
  boolean renderPortal1, renderPortal2;

  int shootPortal_CD;
  int tpToPortal1_CD;
  int tpToPortal2_CD;


  void firePortal(int portal) {
    if (millis() - shootPortal_CD > 2000) { //if the cooldown time has passed
      b.firedBullet = true;
      b.fire();

      if (portal == 1) {
        renderPortal1 = true;
        portalX1 = -100;
        portalY1 = 0;
      } else {
        renderPortal2 = true;
        portalX2 = -100;
        portalY2 = 0;
      }
      shootPortal_CD = millis();
    }
  }


  void portalTP1() {
    int n = 35;
    if (millis() - tpToPortal1_CD > 500 && renderPortal1 == true) {
      if (p.pos.x >= portalX1 - n  && p.pos.x <= portalX1 + n) {
        if (p.pos.y >= portalY1 - n  && p.pos.y <= portalY1 + n) {
          p.pos.x = portalX2;
          p.pos.y = portalY2;
        }
      }
      tpToPortal1_CD = millis();
    }
  }

  void portalTP2() {
    int n = 35;
    if (millis() - tpToPortal2_CD > 499 && renderPortal2 == true) {
      if (p.pos.x >= portalX2-n  && p.pos.x <= portalX2+n) {
        if (p.pos.y >= portalY2-n  && p.pos.y <= portalY2+n) {
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
