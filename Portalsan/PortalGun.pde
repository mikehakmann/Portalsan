float portalX1, portalX2;
float portalY1, portalY2;
boolean renderPortal1;
boolean renderPortal2;

int last_millis1;
int last_millis2;


class PortalGun {

  void portalSpawn1() {
    if ( millis() - last_millis1 > 2000) {
      portalX1 = -100;
      portalY1 = 0;

      b.firedBullet = true;
      b.fire();


      //portalX1 = mouseX;
      //portalY1 = mouseY;
      renderPortal1 = true;

      if (portalTimer < 0) {
        //render(portalX1, portalY1);
        portalTimer = 2000;
      }

      last_millis1 = millis();
    }
  }

  void portalSpawn2() {
    if ( millis() - last_millis1 > 2000) {
      portalX2 = -100;
      portalY2 = 0;
      
      //b.firedBullet = true;
      //b.fire();

      portalX2 = mouseX;
      portalY2 = mouseY;
      renderPortal2 = true;

      if (portalTimer < 0) {
        render2(portalX2, portalY2);
        portalTimer = 2000;
      }

      last_millis1 = millis();
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
  
  
  void portalTP1() {
    int n = 35;
    if ( millis() - last_millis2> 500) {
      if (renderPortal1 == true &&
        p.pos.x >= portalX1 - n  && p.pos.x <= portalX1 + n &&
        p.pos.y >= portalY1 - n  && p.pos.y <= portalY1 + n) {
        println("portal hit!");
        p.pos.x = portalX2;
        p.pos.y = portalY2;
      }
      last_millis2 = millis();
    }
  }

  void portalTP2() {
    int n = 35;
    if ( millis() - last_millis2> 499) {
      if (renderPortal2 == true && p.pos.x >= portalX2-n  && p.pos.x <= portalX2+n) {
        if (renderPortal2== true && p.pos.y >= portalY2-n  && p.pos.y <= portalY2+n) {
          println("portal hit 2!");

          p.pos.x = portalX1;
          p.pos.y = portalY1;
        }
        last_millis2 = millis();
      }
    }
  }
}
