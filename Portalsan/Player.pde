class Player {
  PVector pos;
  PVector vel;
  PVector playerAim;
  boolean isUp, isDown, isLeft, isRight = false;

  Player() {
    pos = new PVector(width/2, height/2);
    vel = new PVector(5, 5);
    playerAim = new PVector(mouseX, mouseY);
    
  }
  
  
  void render() {
    
  }
  

  void movePlayer() {
    pos.x = constrain(pos.x + vel.x * (int(isRight) - int(isLeft)), 1, width  - 1);
    pos.y = constrain(pos.y + vel.x * (int(isDown)  - int(isUp)), 1, height - 1);
  }

  boolean playerSetMove(int k, boolean b) {
    switch (k) {              // "
    case +'W':                // "
    case UP:                  // "
      return isUp = b;        // "
                              // "
    case +'S':                // this code may be switched out with if-statements, if we need 
    case DOWN:                // "
      return isDown = b;      // "
                              // "
    case +'A':                // "
    case LEFT:                // "
      return isLeft = b;      // "
                              // "
    case +'D':                // "
    case RIGHT:               // "
      return isRight = b;     // "
                              // "
    default:                  // "
      return b;               // "
    }
  }
}
