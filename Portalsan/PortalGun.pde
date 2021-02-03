class PortalGun {
  float angle, targetAngle;
  
  void rotateGun() {
    
  
  
  angle = atan2(mouseY - p.pos.y, mouseX - p.pos.x);

  float dir = (angle - targetAngle) / TWO_PI;
  dir -= round( dir );
  dir *= TWO_PI;

  targetAngle += dir;

  noFill();
  stroke( 255 );
  pushMatrix();
  translate(p.pos.x, p.pos.y);
  rotate( targetAngle );

  if (angle>=-PI/2 && angle <= PI/2) {
    scale(-1, 1);
    flipPlayer = true;
  }//
  else {
    scale(-1, -1);
    flipPlayer = false;
  }
  image(portalGun, 0, 0);
  popMatrix();
  println(angle);
  
  }
}
