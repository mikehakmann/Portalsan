float portalX1, portalX2;
float portalY1, portalY2;
boolean renderPortal1;
boolean renderPortal2;


int last_millis;


class PortalGun {

  void portalSpawn1() {
    if ( millis() - last_millis > 2000) {
      b.fire();
      
      
      portalX1 = mouseX;
      portalY1 = mouseY;
      renderPortal1 = true;

      if (portalTimer < 0) {
        render(portalX1, portalY1);
        portalTimer = 2000;
      }
      
      last_millis = millis();
    }
  }

  void portalSpawn2() {
    if ( millis() - last_millis > 2000) {

      portalX2 = mouseX;
      portalY2 = mouseY;
      renderPortal2 = true;

      if (portalTimer < 0) {
        render2(portalX2, portalY2);
        portalTimer = 2000;
      }
      
      last_millis = millis();
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
