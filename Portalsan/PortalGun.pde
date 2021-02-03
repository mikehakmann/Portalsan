class PortalGun {





  angle = atan2( mouseY - height/2, mouseX - width/2 );

  float dir = (angle - targetAngle) / TWO_PI;
  dir -= round( dir );
  dir *= TWO_PI;

  targetAngle += dir;

  noFill();
  stroke( 255 );
  pushMatrix();
  translate( width/2, height/2 );
  rotate( targetAngle );

  if (angle>=-PI/2 && angle <= PI/2) {
    scale(-1, 1);
  } else {
    scale(-1, -1);
  }
  image(picture, 0, 0);
  popMatrix();
  println(angle);
}
