class Bullet {
 PVector bulletPos; //starting outside the map, so it's not visible
 PVector dir;
 float bSpeed, angle;
 boolean fireBullet = false;
 
 Bullet() {
   bulletPos = new PVector(-100, -100);
   dir = new PVector(0, 0);
   bSpeed = 5;
 }
 
 
 void bulletTargeting() {
   //if (mousePressed && mouseButton == LEFT) {
   bulletPos.x = p.pos.x;
   bulletPos.y = p.pos.y;
   
   dir.x = p.pos.x - mouseX;
   dir.y = p.pos.y - mouseY;
   println(dir);
   
   dir.normalize();
   
   dir.x *= bSpeed;
   dir.y *= bSpeed;
   
   bulletPos.x -= dir.x;
   bulletPos.y -= dir.y;
   
   
   }
 //  circle(bulletPos.x, bulletPos.y, 15);
 //}
 
 void fireBullet(float angle) {  //trying to follow the 
   
 }
 
 void updateBullet() {
   
   circle(bulletPos.x, bulletPos.y, 15);
 }
 
 
}
